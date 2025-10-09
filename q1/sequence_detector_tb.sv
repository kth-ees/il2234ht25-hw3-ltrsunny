module sequence_detector_tb;

    logic clk;
    logic rst_n;
    logic input_sequence;
    logic detected_behavioral;
    logic detected_structural;

    sequence_detector_behavioral uut (
        .clk(clk),
        .rst_n(rst_n),
        .input_sequence(input_sequence),
        .detected(detected_behavioral)
    );

    sequence_detector_structural uut2 (
        .clk(clk),
        .rst_n(rst_n),
        .input_sequence(input_sequence),
        .detected(detected_structural)
    );

	// …
	// Add your description here
	// …

    end
endmodule