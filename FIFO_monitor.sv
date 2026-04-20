import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;

module FIFO_monitor (FIFO_if.mon F_if);
	FIFO_transaction FIFO_txn;
	FIFO_scoreboard FIFO_sb;
	FIFO_coverage FIFO_cov;

	initial begin
		FIFO_txn = new();
		FIFO_sb  = new();
		FIFO_cov = new();
		
		forever begin
			wait(etrigger.triggered);
			@(negedge F_if.clk);
			FIFO_txn.data_in = F_if.data_in;
			FIFO_txn.wr_en = F_if.wr_en;
			FIFO_txn.rd_en = F_if.rd_en;
			FIFO_txn.rst_n = F_if.rst_n;
			FIFO_txn.data_out = F_if.data_out;
			FIFO_txn.wr_ack = F_if.wr_ack;
			FIFO_txn.empty = F_if.empty;
			FIFO_txn.full = F_if.full;
			FIFO_txn.almostempty = F_if.almostempty;
			FIFO_txn.almostfull = F_if.almostfull;
			FIFO_txn.overflow = F_if.overflow;
			FIFO_txn.underflow = F_if.underflow;

			fork
				begin
					FIFO_cov.sample_data(FIFO_txn);
				end

				begin
					FIFO_sb.check_data(FIFO_txn);
				end
			join

			if (test_finished) begin
				$display("Correct count = %d, Error count = %d", correct_count, error_count);
				$stop;
			end
		end
	end
endmodule : FIFO_monitor