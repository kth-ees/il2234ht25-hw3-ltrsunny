module conversion_system_mealy (
  input  logic clk,
  input  logic rst_n,
  input  logic x,
  output logic z
);

  // 1. State Definition using Enumerated Type
  typedef enum logic { S0, S1 } state_t;
  state_t current_state, next_state;

  // 2. State Register (Sequential Logic)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= S1; // Initial state: output should be '1'
    end else begin
      current_state <= next_state;
    end
  end

  // Register the output to avoid combinational ambiguity around async reset
  // and to ensure a well-defined value (z=1) at and immediately after reset.
  logic z_reg;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      z_reg <= 1'b1; // force z = 1 during reset
    end else begin
      // Mealy: z depends on current_state and input x at the clock edge
      case (current_state)
        S0: begin
          if (x == 1'b0)
            z_reg <= 1'b1; // S0 with x=0
          else
            z_reg <= 1'b0; // S0 with x=1
        end
        S1: begin
          if (x == 1'b0)
            z_reg <= 1'b0; // S1 with x=0
          else
            z_reg <= 1'b1; // S1 with x=1
        end
        default: z_reg <= 1'b1;
      endcase
    end
  end

  // Drive output from registered value
  assign z = z_reg;

  // 3. Next-State Logic (Combinational Logic)
  always_comb begin
    next_state = current_state; // Default: stay in the same state
    case (current_state)
      S0: begin
        if (x == 1'b0) begin
          next_state = S1; // Toggle
        end
      end
      S1: begin
        if (x == 1'b0) begin
          next_state = S0; // Toggle
        end
      end
    endcase
  end

  

endmodule