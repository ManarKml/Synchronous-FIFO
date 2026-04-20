package FIFO_coverage_pkg;
	import FIFO_transaction_pkg::*;
	class FIFO_coverage;
		FIFO_transaction F_cvg_txn;

		covergroup CovGrp;
			wr_en_cp: coverpoint F_cvg_txn.wr_en { option.weight = 0; }
			rd_en_cp: coverpoint F_cvg_txn.rd_en { option.weight = 0; }

			wr_ack_cp: coverpoint F_cvg_txn.wr_ack { option.weight = 0; }
			full_cp: coverpoint F_cvg_txn.full { option.weight = 0; }
			empty_cp: coverpoint F_cvg_txn.empty { option.weight = 0; }
			overflow_cp: coverpoint F_cvg_txn.overflow { option.weight = 0; }
			underflow_cp: coverpoint F_cvg_txn.underflow { option.weight = 0; }
			almostfull_cp: coverpoint F_cvg_txn.almostfull { option.weight = 0; }
			almostempty_cp: coverpoint F_cvg_txn.almostempty { option.weight = 0; }

			wr_rd_ack_cp: cross wr_en_cp, rd_en_cp, wr_ack_cp {
				illegal_bins ack_without_wr = binsof(wr_ack_cp) intersect {1} &&
											  binsof(wr_en_cp) intersect {0};
			}
			wr_rd_full_cp: cross wr_en_cp, rd_en_cp, full_cp {
				illegal_bins wr_when_full = binsof(rd_en_cp) intersect {1} &&
											binsof(full_cp) intersect {1};
			}
			wr_rd_empty_cp: cross wr_en_cp, rd_en_cp, empty_cp {
				illegal_bins rd_when_empty = binsof(wr_en_cp) intersect {1} &&
											 binsof(empty_cp) intersect {1};
			}
			wr_rd_overflow_cp: cross wr_en_cp, rd_en_cp, overflow_cp {
				illegal_bins overflow_without_wr = binsof(overflow_cp) intersect {1} &&
												   binsof(wr_en_cp) intersect {0};
			}
			wr_rd_underflow_cp: cross wr_en_cp, rd_en_cp, underflow_cp {
				illegal_bins underflow_without_rd = binsof(underflow_cp) intersect {1} &&
													binsof(rd_en_cp) intersect {0};
			}
			wr_rd_almostfull_cp: cross wr_en_cp, rd_en_cp, almostfull_cp;
			wr_rd_almostempty_cp: cross wr_en_cp, rd_en_cp, almostempty_cp;
		endgroup : CovGrp

		function new;
			F_cvg_txn = new;
			CovGrp = new;
		endfunction : new

		function void sample_data(FIFO_transaction F_txn);
			F_cvg_txn = F_txn;
			CovGrp.sample();
		endfunction : sample_data
	endclass : FIFO_coverage
endpackage : FIFO_coverage_pkg