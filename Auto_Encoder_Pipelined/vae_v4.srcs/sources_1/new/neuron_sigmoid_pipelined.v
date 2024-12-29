`timescale 1ns / 1ps

module neuron_sigmoid_pipelined #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input wire clk,
    input wire signed [INPUT_WIDTH-1:0] x1, x2,
    input wire signed [WEIGHT_WIDTH-1:0] w1, w2,
    input wire signed [BIAS_WIDTH-1:0] b,
    output wire signed [ACTIVATION_WIDTH-1:0] y
);
    // MAC unit outputs
    wire signed [2*INPUT_WIDTH-1:0] mac_out1, mac_out2;
    
    // Pipeline registers
    reg signed [2*INPUT_WIDTH-1:0] sum_stage1;
    reg signed [ACTIVATION_WIDTH-1:0] scaled_sum, biased_sum;

    // Instantiate MAC units
    pipelined_mac mac1 (
        .clk(clk),
        .x(x1),
        .w(w1),
        .acc_in('d0),
        .acc_out(mac_out1)
    );

    pipelined_mac mac2 (
        .clk(clk),
        .x(x2),
        .w(w2),
        .acc_in('d0),
        .acc_out(mac_out2)
    );

    // Pipeline stages for accumulation and scaling
    always @(posedge clk) begin
        // Stage 1: Sum MAC outputs
        sum_stage1 <= mac_out1 + mac_out2;
        
        // Stage 2: Scale result
        scaled_sum <= sum_stage1 >>> FRAC_WIDTH;
        
        // Stage 3: Add bias
        biased_sum <= scaled_sum + b;
    end

    // Final sigmoid activation
    sigmoid_pipelined sigmoid_act (
        .clk(clk),
        .x(biased_sum),
        .y(y)
    );

endmodule