module average_calc_datapath #(
    parameter m = 8,
    parameter n = 4
) (
    input logic clk,
    input logic rst_n,
    input logic load,
    input logic shift, 
    input logic init_sum,
    input logic init_shift,
    input logic [m-1:0] inputx,
    output logic [m-1:0] result
);

    localparam k = $clog2(n);  // calculate the shift bits
    localparam acc_width = m + k;  // accumulator width

    logic [acc_width-1:0] accumulator;
    logic [m-1:0] result_reg;

    // accumulator
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 0;
        end else if (init_sum) begin
            accumulator <= 0;
        end else if (load) begin
            //  n times load, accumulate inputx
            // datapath simply accumulates inputx when load is asserted.
            accumulator <= accumulator + inputx;
        end
    end

    // result register (shift operation with rounding)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 0;
        end else if (init_shift) begin
            result_reg <= 0;
        end else if (shift) begin
            // divide accumulator by n (n = 2^k)
            // add n/2 before shifting for proper rounding
            result_reg <= (accumulator + (n >> 1)) >> k;
        end
    end
    
    assign result = result_reg;

endmodule