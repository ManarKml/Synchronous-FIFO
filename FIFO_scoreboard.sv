package FIFO_scoreboard_pkg;
	import FIFO_transaction_pkg::*;
	import shared_pkg::*;

	class FIFO_scoreboard;
		logic [FIFO_WIDTH-1:0] data_out_ref;

		logic [FIFO_WIDTH-1:0] queue [$];

		function void reference_model(FIFO_transaction FIFO_txn);
			int size = queue.size();
			if (!FIFO_txn.rst_n) begin
				queue.delete();
				data_out_ref = 0;
			end
			else begin
				// Read operation
				if (FIFO_txn.rd_en && (size > 0)) begin
					data_out_ref = queue.pop_front();
				end

				// Write operation
				if (FIFO_txn.wr_en && (size < FIFO_DEPTH)) begin
					queue.push_back(FIFO_txn.data_in);
				end
			end
		endfunction : reference_model

		function void check_data(FIFO_transaction FIFO_txn);
			reference_model(FIFO_txn);
			if (FIFO_txn.data_out != data_out_ref) begin
				error_count++;
				$display("ERROR! At t=%0t FIFO_txn=%p", $time, FIFO_txn);
				$display("  Expected -> data_out=%0h", data_out_ref);
				$display("  Actual   -> data_out=%0h", FIFO_txn.data_out);
			end
			else begin
				correct_count++;
			end
		endfunction : check_data
	endclass : FIFO_scoreboard
endpackage : FIFO_scoreboard_pkg