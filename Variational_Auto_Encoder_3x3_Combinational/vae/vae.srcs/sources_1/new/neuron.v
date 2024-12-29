`timescale 1ns / 1ps

module neuron #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10,
    parameter NUM_INPUTS = 9,
    parameter ACTIVATION_TYPE = "NONE" // "NONE", "SIGMOID", "SOFTPLUS"
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9,
    input signed [WEIGHT_WIDTH-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9,
    input signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    // Intermediate signals
    wire signed [2*INPUT_WIDTH-1:0] products [NUM_INPUTS-1:0];
    wire signed [2*INPUT_WIDTH-1:0] sum_temp;
    wire signed [ACTIVATION_WIDTH-1:0] sum_scaled;
    wire signed [ACTIVATION_WIDTH-1:0] activation_out;
    
    // Calculate products based on NUM_INPUTS
    generate
        if (NUM_INPUTS == 9) begin
            assign products[0] = x1 * w1;
            assign products[1] = x2 * w2;
            assign products[2] = x3 * w3;
            assign products[3] = x4 * w4;
            assign products[4] = x5 * w5;
            assign products[5] = x6 * w6;
            assign products[6] = x7 * w7;
            assign products[7] = x8 * w8;
            assign products[8] = x9 * w9;
        end
        else if (NUM_INPUTS == 4) begin
            assign products[0] = x1 * w1;
            assign products[1] = x2 * w2;
            assign products[2] = x3 * w3;
            assign products[3] = x4 * w4;
        end
        else if (NUM_INPUTS == 2) begin
            assign products[0] = x1 * w1;
            assign products[1] = x2 * w2;
        end
    endgenerate

    // Sum all products
    integer j;
    reg signed [2*INPUT_WIDTH-1:0] sum_reg;
    always @* begin
        sum_reg = 0;
        for (j = 0; j < NUM_INPUTS; j = j + 1) begin
            sum_reg = sum_reg + products[j];
        end
    end
    assign sum_temp = sum_reg;
    
    // Scale back to fixed point and add bias
    assign sum_scaled = (sum_temp >>> FRAC_WIDTH) + b;

    // Activation function based on parameter
    generate
        if (ACTIVATION_TYPE == "SIGMOID") begin
            sigmoid #(
                .INPUT_WIDTH(INPUT_WIDTH),
                .OUTPUT_WIDTH(ACTIVATION_WIDTH),
                .FRAC_WIDTH(FRAC_WIDTH)
            ) act (
                .x(sum_scaled),
                .y(activation_out)
            );
        end
        else if (ACTIVATION_TYPE == "SOFTPLUS") begin
            softplus #(
                .INPUT_WIDTH(INPUT_WIDTH),
                .OUTPUT_WIDTH(ACTIVATION_WIDTH),
                .FRAC_WIDTH(FRAC_WIDTH)
            ) act (
                .x(sum_scaled),
                .y(activation_out)
            );
        end
        else begin // "NONE"
            assign activation_out = sum_scaled;
        end
    endgenerate

    assign y = activation_out;

endmodule