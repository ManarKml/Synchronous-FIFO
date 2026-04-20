module FIFO_top;
	bit clk;

	initial begin
		forever #1 clk = ~clk;
	end

	FIFO_if F_if (clk);
	FIFO dut (F_if);
	FIFO_monitor mon (F_if);
	FIFO_tb tb (F_if);

	always_comb begin
	if(!F_if.rst_n) begin
		a_data_out_rst: assert final(F_if.data_out == 0);
		a_wr_ack_rst: assert final(F_if.wr_ack == 0);
		a_full_rst: assert final(F_if.full == 0);
		a_empty_rst: assert final(F_if.empty == 1);
		a_almostfull_rst: assert final(F_if.almostfull == 0);
		a_almostempty_rst: assert final(F_if.almostempty == 0);
		a_underflow_rst: assert final(F_if.underflow == 0);
		a_overflow_rst: assert final(F_if.overflow == 0);
	end
end

endmodule : FIFO_top