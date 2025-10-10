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

// clock 
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;  
end

// reset
initial begin
    rst_n = 1'b0; 
    #15 rst_n = 1'b1;  // release reset after 15ns
end

// test scenarios
initial begin
    serData = 1'b1;  // initial value (idle state)
	
    #20;  // wait for reset release

    // --------------------------
    // scenario 1: Normal complete reception (start sequence + 32 bits data)
    // --------------------------
    
    // Send start sequence 011010 (6 clock cycles, defined in q3.pdf 1-2)
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6（outValid=1）
    // Send 32 bits random valid data 
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;  // wait for return to search state

    // --------------------------
    // scenario 2: Start sequence 2 bit error (partial match recovery)
    // --------------------------

    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b0; #10;  // Bit 2: 0 (error) → S1→S_IDLE
    // Resend correct start sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    // send 32 bits random valid data
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;

    // --------------------------
    // scenario 3: Start sequence 5th bit error (near match recovery)
    // --------------------------

    // send first 4 bits correct sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b0; #10;  // Bit 5: 0 (wrong)→ S4→S_IDLE
    // resend correct start sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    // valid 32 bits data
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;

    // --------------------------
    // scenario 4: Reset triggered during data reception
    // --------------------------
    
    // Send correct start sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6（outValid=1）
    // Receive 9 valid data bits before triggering reset
    repeat(9) begin
        serData = $random;
        #10;
    end
    rst_n = 1'b0; #20;  // Pull down reset for 2 clock cycles
    rst_n = 1'b1; #10;  // Release reset
    // After reset, re-receive
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;

    // --------------------------
    // scenario 5: Two consecutive start sequences (no gap)
    // --------------------------
    
    // First start sequence + 32 bits data
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    repeat(32) begin
        serData = $random;
        #10;
    end
    // Immediately send the 2nd start sequence (no gap)
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;

    // --------------------------
    // scenario 6: Start sequence partially matched, then delayed re-match
    // --------------------------
   
    // send first 3 bits correct sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    // Delay 7 clock cycles (serData=1, wrong)
    repeat(7) begin
        serData = 1'b1;
        #10;
    end
    // Resend correct start sequence
    serData = 1'b0; #10;  // Bit 1: 0 → S_IDLE→S1
    serData = 1'b1; #10;  // Bit 2: 1 → S1→S2
    serData = 1'b1; #10;  // Bit 3: 1 → S2→S3
    serData = 1'b0; #10;  // Bit 4: 0 → S3→S4
    serData = 1'b1; #10;  // Bit 5: 1 → S4→S5
    serData = 1'b0; #10;  // Bit 6: 0 → S5→S6
    repeat(32) begin
        serData = $random;
        #10;
    end
    #10;

    $stop;
end



endmodule