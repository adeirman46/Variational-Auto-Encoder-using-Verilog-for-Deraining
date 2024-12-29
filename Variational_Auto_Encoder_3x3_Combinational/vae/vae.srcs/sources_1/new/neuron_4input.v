module neuron_4input #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10,
    parameter ACTIVATION_TYPE = "NONE"
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4,
    input signed [WEIGHT_WIDTH-1:0] w1, w2, w3, w4,
    input signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    wire signed [INPUT_WIDTH-1:0] zero = 0;
    
    neuron #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .BIAS_WIDTH(BIAS_WIDTH),
        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH),
        .NUM_INPUTS(4),
        .ACTIVATION_TYPE(ACTIVATION_TYPE)
    ) neuron_inst (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(zero), .x6(zero), .x7(zero), .x8(zero), .x9(zero),
        .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(zero), .w6(zero), .w7(zero), .w8(zero), .w9(zero),
        .b(b),
        .y(y)
    );
endmodule