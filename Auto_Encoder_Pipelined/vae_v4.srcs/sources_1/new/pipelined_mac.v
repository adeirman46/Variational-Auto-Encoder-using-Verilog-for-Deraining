`timescale 1ns / 1ps

module pipelined_mac #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 32,
    parameter FRAC_WIDTH = 10
)(
    input wire clk,
    input wire signed [INPUT_WIDTH-1:0] x,
    input wire signed [WEIGHT_WIDTH-1:0] w,
    input wire signed [OUTPUT_WIDTH-1:0] acc_in,
    output reg signed [OUTPUT_WIDTH-1:0] acc_out
);
    // Pipeline registers
    reg signed [2*INPUT_WIDTH-1:0] prod_r;
    
    always @(posedge clk) begin
        // Stage 1: Multiplication
        prod_r <= x * w;
        // Stage 2: Accumulation
        acc_out <= acc_in + prod_r;
    end
endmodule