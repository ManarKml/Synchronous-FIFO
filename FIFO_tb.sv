module FIFO_tb (FIFO_if.tb F_if);
	import shared_pkg::*;
	import FIFO_transaction_pkg::*;
	
	FIFO_transaction F_txn = new;

	initial begin
		correct_count = 0;
		error_count = 0;
		test_finished = 0;

		assert_reset();
		@(negedge F_if.clk);	

		for (int i = 0; i < 1000; i++) begin
			assert(F_txn.randomize());
			F_if.rst_n = F_txn.rst_n;
			F_if.data_in = F_txn.data_in;
			F_if.wr_en = F_txn.wr_en;
			F_if.rd_en = F_txn.rd_en;

			@(negedge F_if.clk);

			-> etrigger;
		end

		test_finished = 1;
	end

	task assert_reset;
		-> etrigger;
		F_if.rst_n = 0;
		@(negedge F_if.clk);
		F_if.rst_n = 1;
	endtask : assert_reset
endmodule : FIFO_tb