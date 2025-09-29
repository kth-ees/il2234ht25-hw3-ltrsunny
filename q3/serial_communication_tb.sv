module serial_communication_tb;

	logic clk;
	logic rst_n;    
	logic serData;
	logic outValid;
	
	serial_communication dut (
		.clk(clk),
		.rst_n(rst_n),
		.serData(serData),
		.outValid(outValid)
	);

	// …
	// Add your description here
	// …

endmodule