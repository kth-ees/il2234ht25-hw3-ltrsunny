module serial_communication(
    input logic clk,
    input logic rst_n,
    input logic serData,
    output logic outValid
);
// 1. State definition
typedef enum logic [2:0] {
    S_IDLE,  // Initial state, searching for start sequence
    S1,      // Received start sequence bit 1 (0)
    S2,      // Received start sequence bit 2 (1)
    S3,      // Received start sequence bit 3 (1)
    S4,      // Received start sequence bit 4 (0)
    S5,      // Received start sequence bit 5 (1)
    S6       // Received complete start sequence, output valid data (32 cycles)
} state_t;

// 2. Internal signal declaration
state_t current_state;  // Current state register
state_t next_state;     // Next state logic (combinational)
logic [4:0] data_cnt;   // 32-bit data counter (0~31, 5 bits are enough)

// 3. State register sequential logic (synchronous update, asynchronous reset)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_IDLE;  // Reset to initial state
    end else begin
        current_state <= next_state;  // Update state on clock edge
    end
end

// 4. Next state combinational logic (determine next state based on current state and serData)
always_comb begin
    next_state = current_state;  // Default to hold current state (avoid latch)
    case (current_state)
        S_IDLE: begin
            if (serData == 1'b0) begin  // Match start sequence bit 1 (0)
                next_state = S1;
            end
        end
        S1: begin
            if (serData == 1'b1) begin  // Match start sequence bit 2 (1)
                next_state = S2;
            end else begin
                next_state = S_IDLE;    // No match, restart search
            end
        end
        S2: begin
            if (serData == 1'b1) begin  // Match start sequence bit 3 (1)
                next_state = S3;
            end else begin
                next_state = S_IDLE;
            end
        end
        S3: begin
            if (serData == 1'b0) begin  // Match start sequence bit 4 (0)
                next_state = S4;
            end else begin
                next_state = S_IDLE;
            end
        end
        S4: begin
            if (serData == 1'b1) begin  // Match start sequence bit 5 (1)
                next_state = S5;
            end else begin
                next_state = S_IDLE;
            end
        end
        S5: begin
            if (serData == 1'b0) begin  // Match start sequence bit 6 (0), enter data reception
                next_state = S6;
            end else begin
                next_state = S_IDLE;
            end
        end
        S6: begin
            if (data_cnt == 5'd31) begin  // Count 32 cycles (0~31), return to search
                next_state = S_IDLE;
            end
        end
        default: next_state = S_IDLE;  // Exception state protection
    endcase
end

// 5. 32-bit data counter (count only in S6 state, reset in other states)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_cnt <= 5'd0;  // Reset to zero
    end else begin
        if (current_state == S6) begin
            data_cnt <= data_cnt + 1'b1;  // Increment every clock cycle
        end else begin
            data_cnt <= 5'd0;  // Reset in non-data states
        end
    end
end

// 6. Moore output logic (output 1 only in S6 state, 0 in other states)
assign outValid = (current_state == S6) ? 1'b1 : 1'b0;

endmodule