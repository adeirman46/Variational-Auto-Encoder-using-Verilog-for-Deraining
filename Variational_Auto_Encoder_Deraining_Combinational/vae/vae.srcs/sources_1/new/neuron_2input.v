module neuron_2input #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10,
    parameter ACTIVATION_TYPE = "NONE"
)(
    input signed [INPUT_WIDTH-1:0] x1, x2,
    input signed [WEIGHT_WIDTH-1:0] w1, w2,
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
        .NUM_INPUTS(2),
        .ACTIVATION_TYPE(ACTIVATION_TYPE)
    ) neuron_inst (
        .x1(x1), .x2(x2),
        .x3(zero), .x4(zero), .x5(zero), .x6(zero), .x7(zero), .x8(zero),
        .x9(zero), .x10(zero), .x11(zero), .x12(zero), .x13(zero), .x14(zero),
        .x15(zero), .x16(zero),
        .w1(w1), .w2(w2),
        .w3(zero), .w4(zero), .w5(zero), .w6(zero), .w7(zero), .w8(zero),
        .w9(zero), .w10(zero), .w11(zero), .w12(zero), .w13(zero), .w14(zero),
        .w15(zero), .w16(zero),
        .b(b),
        .y(y)
    );
endmodule