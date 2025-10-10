module conversion_system_tb ();
  
  logic clk, rst_n, x, z_mealy, z_moore;

  conversion_system_mealy mealy_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_mealy));
  conversion_system_moore moore_fsm(.clk(clk), .rst_n(rst_n), .x(x), .z(z_moore));

// Clock Generation: Create a clock with a 10ns period.
  localparam CLK_PERIOD = 10;
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

   // Reset and Stimulus Generation
  initial begin
    // Define the input test sequence from the problem description
    logic [13:0] test_vector = 14'b10001110011010;

    // 1. Apply reset at the beginning of the simulation
    rst_n = 1'b0; // Assert active-low reset
    x = 1'b0;     // Keep input stable during reset
    repeat (2) @(posedge clk); // Hold reset for 2 clock cycles
    
    // 2. De-assert reset to start FSM operation
    rst_n = 1'b1;
    @(posedge clk);

    // 3. Apply the input stimulus vector bit-by-bit
    for (int i = 13; i >= 0; i--) begin
      x = test_vector[i];
      @(posedge clk); // Wait for the next clock edge
    end

    // 4. End the simulation after a short delay
    #20;
    $stop;
  end
endmodule