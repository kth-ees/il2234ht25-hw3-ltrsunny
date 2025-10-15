module average_calc_controller #(parameter n = 4) (
    input logic clk,
    input logic rst_n,
    input logic start,
    output logic init_sum,
    output logic init_shift,
    output logic load,
    output logic shift,
    output logic done
);
    // Define FSM states
    typedef enum logic [2:0] {
        S_IDLE,
        S_INIT,
        S_INPUT,
        S_CALCULATE,
        S_DONE
    } state_t;

    state_t state_reg, state_next;
    
    // Counter to track number of inputs loaded
    localparam CNT_WIDTH = $clog2(n);
    logic [CNT_WIDTH-1:0] cycle_counter;

    // Process 1: State Register (sequential)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= S_IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    // Counter logic: reset in INIT, increment while in INPUT state
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_counter <= '0;
        end else if (state_reg == S_INIT) begin
            cycle_counter <= '0;
        end else if (state_reg == S_INPUT) begin
            cycle_counter <= cycle_counter + 1'b1;
        end
    end

    // Process 2: Next-State Logic (combinational)
    always_comb begin
        state_next = state_reg; // Default to stay in current state
        case (state_reg)
            S_IDLE: begin
                if (start) begin
                    state_next = S_INIT;
                end
            end
            S_INIT: begin
                state_next = S_INPUT;
            end
            S_INPUT: begin
                if (cycle_counter == n-1) begin
                    state_next = S_CALCULATE;
                end else begin
                    state_next = S_INPUT;
                end
            end
            S_CALCULATE: begin
                state_next = S_DONE;
            end
            S_DONE: begin
                state_next = S_IDLE;  // Return to idle immediately
            end
            default: state_next = S_IDLE;
        endcase
    end

    // Process 3: Output Logic (combinational)
    always_comb begin
        // Default values
        init_sum   = 1'b0;
        init_shift = 1'b0;
        load       = 1'b0;
        shift      = 1'b0;
        done       = 1'b0;

        case (state_reg)
            S_IDLE:      ; // Use default values
            S_INIT:      begin 
                init_sum = 1'b1; 
                init_shift = 1'b1; 
            end
            S_INPUT:     load = 1'b1;
            S_CALCULATE: shift = 1'b1;
            S_DONE:      done = 1'b1;
            default:     ; // Use default values
        endcase
    end

endmodule