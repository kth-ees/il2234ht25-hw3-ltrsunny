module average_calculator_tb;
	parameter m = 8;
	parameter n = 4;
	
	logic clk;
	logic rst_n;    
	logic start;
	logic [m-1:0] inputx;
	logic [m-1:0] result;
	logic done;

	average_calculator #(m, n) dut (
		.clk(clk),
		.rst_n(rst_n),
		.start(start),
		.inputx(inputx),
		.result(result),
		.done(done)
	);

	// …
	// Add your description here
	// …
	
endmodule
