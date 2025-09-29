module sin_tb;
    logic        clk;
    logic        rst_n;
    logic [15:0] x;
    logic        start;
    logic [15:0] result;
    logic        done;

    sin uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .start(start),
        .result(result),
        .done(done)
    );

	// …
	// Add your description here
	// …

endmodule


     