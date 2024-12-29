`timescale 1ns / 1ps

module neuron_relu #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9,
    input signed [WEIGHT_WIDTH-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9,
    input signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    // Intermediate wider bit widths to prevent overflow
    wire signed [2*INPUT_WIDTH-1:0] prod1, prod2, prod3, prod4, prod5, prod6, prod7, prod8, prod9;
    wire signed [2*INPUT_WIDTH-1:0] sum_temp;
    wire signed [ACTIVATION_WIDTH-1:0] sum_scaled;
    
    // Calculate products with full precision
    assign prod1 = x1 * w1;
    assign prod2 = x2 * w2;
    assign prod3 = x3 * w3;
    assign prod4 = x4 * w4;
    assign prod5 = x5 * w5;
    assign prod6 = x6 * w6;
    assign prod7 = x7 * w7;
    assign prod8 = x8 * w8;
    assign prod9 = x9 * w9;

    // Sum all products and scale back to fixed point
    assign sum_temp = prod1 + prod2 + prod3 + prod4 + prod5 + prod6 + prod7 + prod8 + prod9;
    assign sum_scaled = (sum_temp >>> FRAC_WIDTH) + b;

    // ReLU activation
    assign y = (sum_scaled < 0) ? 0 : sum_scaled;

endmodule