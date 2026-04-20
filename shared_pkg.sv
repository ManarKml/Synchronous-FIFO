package shared_pkg;
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	bit test_finished;
	static integer correct_count;
	static integer error_count;
	event etrigger;
endpackage : shared_pkg