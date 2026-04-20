////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;

module FIFO(FIFO_if.dut F_if);
 
localparam max_fifo_addr = $clog2(F_if.FIFO_DEPTH);

reg [F_if.FIFO_WIDTH-1:0] mem [F_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		wr_ptr <= 0;
		F_if.wr_ack <= 0;				// reset ack flag
		F_if.overflow <= 0;				// reset overflow flag
	end
	else if (F_if.wr_en && count < F_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= F_if.data_in;
		F_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		F_if.wr_ack <= 0; 
		if (F_if.full & F_if.wr_en)
			F_if.overflow <= 1;
		else
			F_if.overflow <= 0;
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		rd_ptr <= 0;
		F_if.underflow <= 0;			// reset underflow flag
		F_if.data_out <= 0;				// reset data output
	end
	else if (F_if.rd_en && count != 0) begin
		F_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else if (F_if.empty & F_if.rd_en)	// added this part to handle sequential underflow flag
		F_if.underflow <= 1;
	else
		F_if.underflow <= 0;
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		count <= 0;
	end
	else begin 
		// added conditions to increment/decrement count when rd_en & wr_en are HIGH
		if	( ( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full ) || (({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.empty ) )
			count <= count + 1;
		else if ( ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty ) || ( ({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.full ) )
			count <= count - 1;
	end
end

assign F_if.full = (count == F_if.FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
assign F_if.almostfull = (count == F_if.FIFO_DEPTH-1)? 1 : 0; // changed the condition from FIFO_DEPTH-2 to FIFO_DEPTH-1
assign F_if.almostempty = (count == 1)? 1 : 0;


////////////////////////////////////////////////////////////////////////////////
// Assertions		
////////////////////////////////////////////////////////////////////////////////

always_comb begin
	if(!F_if.rst_n) begin
		a_wr_ptr_rst: assert final(wr_ptr == 0);
		a_rd_ptr_rst: assert final(rd_ptr == 0);
		a_count_rst: assert final(count == 0);
	end
end

a_wr_ack: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && !F_if.full) |=> F_if.wr_ack);
c_wr_ack: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && !F_if.full) |=> F_if.wr_ack);

a_overflow: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && F_if.full) |=> F_if.overflow);
c_overflow: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && F_if.full) |=> F_if.overflow);

a_underflow: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.rd_en && F_if.empty) |=> F_if.underflow);
c_underflow: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.rd_en && F_if.empty) |=> F_if.underflow);

a_empty: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) count == 0 |-> F_if.empty);
c_empty: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) count == 0 |-> F_if.empty);

a_full: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == FIFO_DEPTH) |-> F_if.full);
c_full: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == FIFO_DEPTH) |-> F_if.full);

a_almostfull: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == FIFO_DEPTH-1) |-> F_if.almostfull);
c_almostfull: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == FIFO_DEPTH-1) |-> F_if.almostfull);

a_almostempty: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == 1) |-> F_if.almostempty);
c_almostempty: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == 1) |-> F_if.almostempty);

a_wr_ptr_wrap: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (wr_ptr == FIFO_DEPTH-1 && F_if.wr_en && !F_if.full) |=> wr_ptr == 0);
c_wr_ptr_wrap: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (wr_ptr == FIFO_DEPTH-1 && F_if.wr_en && !F_if.full) |=> wr_ptr == 0);

a_rd_ptr_wrap: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (rd_ptr == FIFO_DEPTH-1 && F_if.rd_en && !F_if.empty) |=> rd_ptr == 0);
c_rd_ptr_wrap: cover  property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (rd_ptr == FIFO_DEPTH-1 && F_if.rd_en && !F_if.empty) |=> rd_ptr == 0);

a_wr_ptr_bound: assert property (@(posedge F_if.clk) wr_ptr < FIFO_DEPTH);
c_wr_ptr_bound: cover  property (@(posedge F_if.clk) wr_ptr < FIFO_DEPTH);

a_rd_ptr_bound: assert property (@(posedge F_if.clk) rd_ptr < FIFO_DEPTH);
c_rd_ptr_bound: cover  property (@(posedge F_if.clk) rd_ptr < FIFO_DEPTH);

a_count_bound: assert property (@(posedge F_if.clk) count <= FIFO_DEPTH);
c_count_bound: cover  property (@(posedge F_if.clk) count <= FIFO_DEPTH);

endmodule