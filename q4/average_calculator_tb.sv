module average_calculator_tb;
    parameter m = 8;
    parameter n = 4;

    logic clk;
    logic rst_n;
    logic start;
    logic [m-1:0] inputx;
    logic [m-1:0] result;
    logic done;
    
    // test vectors
    int unsigned seq1 [n];
    int unsigned seq2 [n];
    
    average_calculator #(.m(m), .n(n)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .inputx(inputx),
        .result(result),
        .done(done)
    );

    // clock: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // initialize
        rst_n = 0;
        start = 0;
        inputx = 0;

        // release reset
        repeat (2) @(negedge clk);
        rst_n = 1;

        // Test case 1: 10,20,30,40 -> average 25
        seq1[0] = 10; seq1[1] = 20; seq1[2] = 30; seq1[3] = 40;

        // pulse start for one clock cycle
        @(negedge clk);
        start <= 1;
        @(negedge clk);
        start <= 0;

        // apply inputs - each input for one clock cycle
        for (int i = 0; i < n; i++) begin
            @(negedge clk);
            inputx <= seq1[i];
        end

        // wait for done
        wait(done == 1);
        @(negedge clk);
        $display("[%0t] Test1: result=%0d (expected 25)", $time, result);

        // small delay
        repeat (2) @(negedge clk);

        // Test case 2: 1,3,5,7 -> average 4
        seq2[0] = 1; seq2[1] = 3; seq2[2] = 5; seq2[3] = 7;

        @(negedge clk);
        start <= 1;
        @(negedge clk);
        start <= 0;

        // apply inputs - each input for one clock cycle
        for (int i = 0; i < n; i++) begin
            @(negedge clk);
            inputx <= seq2[i];
        end

        wait(done == 1);
        @(negedge clk);
        $display("[%0t] Test2: result=%0d (expected 4)", $time, result);

        repeat (4) @(negedge clk);
        $display("[%0t] Simulation completed", $time);
        $stop;
    end

endmodule