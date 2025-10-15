module average_calculator #(parameter m = 8, parameter n = 4) (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [m-1:0] inputx,
    output logic [m-1:0] result,
    output logic done
);

    logic init_sum, init_shift, load, shift;
    
    // controller instance
    average_calc_controller #(.n(n)) controller (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .init_sum(init_sum),
        .init_shift(init_shift),
        .load(load),
        .shift(shift),
        .done(done)
    );
    
    // datapath instance
    average_calc_datapath #(.m(m), .n(n)) datapath (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .shift(shift),
        .init_sum(init_sum),
        .init_shift(init_shift),
        .inputx(inputx),
        .result(result)
    );

endmodule