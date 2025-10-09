module sequence_detector_structural(
    input logic clk,
    input logic rst_n,
    input logic input_sequence,
    output logic detected
);
    
    // use 5 flip-flops to store the state of the last 5 inputs
    logic [4:0] q;
    
    // D flip-flop 0 - stores the current input
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[0] <= 1'b0;
        else q[0] <= input_sequence;
    end
    
    // D flip-flop 1 - stores the previous input
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[1] <= 1'b0;
        else q[1] <= q[0] & input_sequence;
    end
    
    // D flip-flop 2 - stores the input from two cycles ago
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[2] <= 1'b0;
        else q[2] <= q[1] & input_sequence;
    end
    
    // D flip-flop 3 - stores the input from three cycles ago
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[3] <= 1'b0;
        else q[3] <= q[2] & input_sequence;
    end
    
    // D flip-flop 4 - stores the input from four cycles ago
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[4] <= 1'b0;
        else q[4] <= q[3] & input_sequence;
    end
    
    // output logic: detected is high when all 5 flip-flops are high
    assign detected = q[4] & input_sequence;
    
endmodule