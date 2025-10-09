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

    // clk generation
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    // test sequence
    initial begin
        // initialize signals
        rst_n = 1'b0;
        input_sequence = 1'b0;
        
        // wait for a while and release reset
        #20;
        rst_n = 1'b1;

        // test sequence 1: 5 consecutive 1s
        #10;
        input_sequence = 1'b1;
        #50; // 5 clock cycles

        // test sequence 2: continue with 1 more 1, verify hold
        #10;

        // test sequence 3: input 0, reset sequence
        input_sequence = 1'b0;
        #10;

        // test sequence 4: interrupted sequence (3 1s + 0 + 5 1s)
        input_sequence = 1'b1;
        #30; // 3 clock cycles
        input_sequence = 1'b0;
        #10; // 1 clock cycle
        input_sequence = 1'b1;
        #50; // 5 clock cycles

        // test sequence 5: 4 consecutive 1s followed by 0
        input_sequence = 1'b1;
        #40; // 4 clock cycles
        input_sequence = 1'b0;
        #10;

        // finish simulation
        #100;
        $stop;
    end

endmodule