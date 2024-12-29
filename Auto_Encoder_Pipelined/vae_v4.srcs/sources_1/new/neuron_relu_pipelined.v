`timescale 1ns / 1ps

module neuron_relu_pipelined #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input wire clk,
    input wire signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9,
    input wire signed [WEIGHT_WIDTH-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9,
    input wire signed [BIAS_WIDTH-1:0] b,
    output reg signed [ACTIVATION_WIDTH-1:0] y
);
    // MAC unit outputs
    wire signed [2*INPUT_WIDTH-1:0] mac_out1, mac_out2, mac_out3;
    wire signed [2*INPUT_WIDTH-1:0] mac_out4, mac_out5, mac_out6;
    wire signed [2*INPUT_WIDTH-1:0] mac_out7, mac_out8, mac_out9;
    
    // Pipeline registers
    reg signed [2*INPUT_WIDTH-1:0] sum_stage1, sum_stage2, sum_final;
    reg signed [ACTIVATION_WIDTH-1:0] scaled_sum, biased_sum;
    
    // Instantiate MAC units for each input-weight pair
    pipelined_mac mac1 (.clk(clk), .x(x1), .w(w1), .acc_in('d0), .acc_out(mac_out1));
    pipelined_mac mac2 (.clk(clk), .x(x2), .w(w2), .acc_in('d0), .acc_out(mac_out2));
    pipelined_mac mac3 (.clk(clk), .x(x3), .w(w3), .acc_in('d0), .acc_out(mac_out3));
    pipelined_mac mac4 (.clk(clk), .x(x4), .w(w4), .acc_in('d0), .acc_out(mac_out4));
    pipelined_mac mac5 (.clk(clk), .x(x5), .w(w5), .acc_in('d0), .acc_out(mac_out5));
    pipelined_mac mac6 (.clk(clk), .x(x6), .w(w6), .acc_in('d0), .acc_out(mac_out6));
    pipelined_mac mac7 (.clk(clk), .x(x7), .w(w7), .acc_in('d0), .acc_out(mac_out7));
    pipelined_mac mac8 (.clk(clk), .x(x8), .w(w8), .acc_in('d0), .acc_out(mac_out8));
    pipelined_mac mac9 (.clk(clk), .x(x9), .w(w9), .acc_in('d0), .acc_out(mac_out9));

    // Pipeline stages
    always @(posedge clk) begin
        // Stage 1: First level of accumulation
        sum_stage1 <= mac_out1 + mac_out2 + mac_out3 + mac_out4 + mac_out5;
        sum_stage2 <= mac_out6 + mac_out7 + mac_out8 + mac_out9;
        
        // Stage 2: Complete accumulation
        sum_final <= sum_stage1 + sum_stage2;
        
        // Stage 3: Scale result
        scaled_sum <= sum_final >>> FRAC_WIDTH;
        
        // Stage 4: Add bias
        biased_sum <= scaled_sum + b;
        
        // Stage 5: ReLU activation
        y <= (biased_sum < 0) ? 0 : biased_sum;
    end

endmodule