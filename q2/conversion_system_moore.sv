module conversion_system_moore (
  input  logic clk,
  input  logic rst_n,
  input  logic x,
  output logic z
);

  // 1. State Definition using Enumerated Type
  typedef enum logic { STATE_0, STATE_1 } state_t;
  state_t current_state, next_state;

  // 2. State Register (Sequential Logic)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= STATE_1; // Initial output is '1'
    end else begin
      current_state <= next_state;
    end
  end

  // 3. Next-State Logic (Combinational Logic)
  always_comb begin
    next_state = current_state; // Default: stay in the same state
    case (current_state)
      STATE_0: begin
        if (x == 1'b0) begin
          next_state = STATE_1; // Toggle
        end
      end
      STATE_1: begin
        if (x == 1'b0) begin
          next_state = STATE_0; // Toggle
        end
      end
    endcase
  end

  // 4. Output Logic (Combinational Logic for Moore)
  // Output depends ONLY on current_state
  always_comb begin
    case (current_state)
      STATE_0: z = 1'b0;
      STATE_1: z = 1'b1;
      default:   z = 1'b0;
    endcase
  end

endmodule