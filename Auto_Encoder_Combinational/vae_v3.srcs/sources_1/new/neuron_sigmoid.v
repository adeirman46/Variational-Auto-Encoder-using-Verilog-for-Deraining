`timescale 1ns / 1ps

module neuron_sigmoid #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input signed [INPUT_WIDTH-1:0] x1, x2,
    input signed [WEIGHT_WIDTH-1:0] w1, w2,
    input signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    // Intermediate signals with wider bit widths
    wire signed [2*INPUT_WIDTH-1:0] prod1, prod2;
    wire signed [2*INPUT_WIDTH-1:0] sum_temp;
    wire signed [ACTIVATION_WIDTH-1:0] sum_scaled;

    // Calculate products with full precision
    assign prod1 = x1 * w1;
    assign prod2 = x2 * w2;

    // Sum products and scale back to fixed point
    assign sum_temp = prod1 + prod2;
    assign sum_scaled = (sum_temp >>> FRAC_WIDTH) + b;

    // Sigmoid activation
    sigmoid #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) sigmoid_activation (
        .x(sum_scaled),
        .y(y)
    );

endmodule