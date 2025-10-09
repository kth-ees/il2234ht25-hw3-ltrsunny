module sequence_detector_behavioral(
    input logic clk,
    input logic rst_n,
    input logic input_sequence,
    output logic detected
);

	// State definitions
    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010, 
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101
    } state_t;
    
    state_t current_state, next_state;
    
    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state and output logic
    always_comb begin
        case (current_state)
            S0: begin
                detected = 1'b0;
                next_state = input_sequence ? S1 : S0;
            end
            S1: begin
                detected = 1'b0;
                next_state = input_sequence ? S2 : S0;
            end
            S2: begin
                detected = 1'b0;
                next_state = input_sequence ? S3 : S0;
            end
            S3: begin
                detected = 1'b0;
                next_state = input_sequence ? S4 : S0;
            end
            S4: begin
                detected = 1'b0;
                next_state = input_sequence ? S5 : S0;
            end
            S5: begin
                detected = input_sequence ? 1'b1 : 1'b0;
                next_state = input_sequence ? S5 : S0;
            end
            default: begin
                detected = 1'b0;
                next_state = S0;
            end
        endcase
    end
endmodule
