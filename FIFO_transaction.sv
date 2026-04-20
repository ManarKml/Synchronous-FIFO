package FIFO_transaction_pkg;
	import shared_pkg::*;
	
	class FIFO_transaction;
		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow;
		logic full, empty, almostfull, almostempty, underflow;

		integer RD_EN_ON_DIST;
		integer WR_EN_ON_DIST;

		constraint con_1 {
			rst_n dist {0:= 2, 1:= 98};
		}
		constraint con_2 {
			wr_en dist {0:= (100 - WR_EN_ON_DIST), 1:= WR_EN_ON_DIST};
		}
		constraint con_3 {
			rd_en dist {0:= (100 - RD_EN_ON_DIST), 1:= RD_EN_ON_DIST};
		}

		function new (input int RD_EN_ON_DIST = 30, input int WR_EN_ON_DIST = 70);
			this.RD_EN_ON_DIST = RD_EN_ON_DIST;
			this.WR_EN_ON_DIST = WR_EN_ON_DIST;
		endfunction : new
	endclass : FIFO_transaction
endpackage : FIFO_transaction_pkg