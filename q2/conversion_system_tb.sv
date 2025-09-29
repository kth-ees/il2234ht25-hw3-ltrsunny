module conversion_system_tb ();
  
  logic clk, rst_n, x, z_mealy, z_moore;

  conversion_system_mealy mealy_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_mealy));
  conversion_system_moore moore_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_moore));

	// …
	// Add your description here
	// …

endmodule