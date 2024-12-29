module neuron_16input #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10,
    parameter ACTIVATION_TYPE = "NONE"
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16,
    input signed [WEIGHT_WIDTH-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16,
    input signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    neuron #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .BIAS_WIDTH(BIAS_WIDTH),
        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH),
        .NUM_INPUTS(16),
        .ACTIVATION_TYPE(ACTIVATION_TYPE)
    ) neuron_inst (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
        .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16),
        .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8),
        .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16),
        .b(b),
        .y(y)
    );
endmodule