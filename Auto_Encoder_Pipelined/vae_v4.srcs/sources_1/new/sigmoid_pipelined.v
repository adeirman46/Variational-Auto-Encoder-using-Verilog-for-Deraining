`timescale 1ns / 1ps

module sigmoid_pipelined #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input wire clk,
    input wire signed [INPUT_WIDTH-1:0] x,
    output reg signed [OUTPUT_WIDTH-1:0] y
);
    // Fixed point constants (scaled by 2^FRAC_WIDTH)
    localparam signed [OUTPUT_WIDTH-1:0] 
        CONST_0_002 = 16'h0001,      // 0.002 * 2^10 ≈ 2
        CONST_0_998 = 16'h03FE;      // 0.998 * 2^10 ≈ 1022
    
    // Slopes (multiplied by 2^FRAC_WIDTH)
    localparam signed [OUTPUT_WIDTH-1:0]
        SLOPE_1 = 16'h0009,          // 0.009 * 2^10 ≈ 9
        SLOPE_2 = 16'h0022,          // 0.033 * 2^10 ≈ 34
        SLOPE_3 = 16'h006B,          // 0.105 * 2^10 ≈ 107
        SLOPE_4 = 16'h00C7,          // 0.195 * 2^10 ≈ 199
        SLOPE_5 = 16'h0100;          // 0.250 * 2^10 ≈ 256

    // Intercepts (multiplied by 2^FRAC_WIDTH)
    localparam signed [OUTPUT_WIDTH-1:0]
        INTERCEPT_1 = 16'h0037,      // 0.055 * 2^10 ≈ 55
        INTERCEPT_2 = 16'h009A,      // 0.151 * 2^10 ≈ 154
        INTERCEPT_3 = 16'h0153,      // 0.332 * 2^10 ≈ 339
        INTERCEPT_4 = 16'h01DC,      // 0.467 * 2^10 ≈ 478
        INTERCEPT_5 = 16'h0200,      // 0.500 * 2^10 ≈ 512
        INTERCEPT_6 = 16'h0200,      // 0.500 * 2^10 ≈ 512
        INTERCEPT_7 = 16'h0224,      // 0.533 * 2^10 ≈ 546
        INTERCEPT_8 = 16'h02AD,      // 0.668 * 2^10 ≈ 684
        INTERCEPT_9 = 16'h0366,      // 0.849 * 2^10 ≈ 870
        INTERCEPT_10 = 16'h03C7;     // 0.945 * 2^10 ≈ 967

    // Breakpoints (scaled appropriately for the input fixed-point format)
    localparam signed [INPUT_WIDTH-1:0]
        BP_N6  = -6 << FRAC_WIDTH,
        BP_N4  = -4 << FRAC_WIDTH,
        BP_N25 = -5 << (FRAC_WIDTH-1),  // -2.5
        BP_N15 = -3 << (FRAC_WIDTH-1),  // -1.5
        BP_N07 = -7 << (FRAC_WIDTH-3),  // -0.7
        BP_0   = 0,
        BP_07  = 7 << (FRAC_WIDTH-3),   // 0.7
        BP_15  = 3 << (FRAC_WIDTH-1),   // 1.5
        BP_25  = 5 << (FRAC_WIDTH-1),   // 2.5
        BP_4   = 4 << FRAC_WIDTH,
        BP_6   = 6 << FRAC_WIDTH;

    // Pipeline registers
    reg signed [INPUT_WIDTH-1:0] x_r1, x_r2;
    reg signed [OUTPUT_WIDTH-1:0] slope_r, intercept_r;
    reg signed [2*INPUT_WIDTH-1:0] mult_r;
    reg signed [OUTPUT_WIDTH-1:0] result_r;

    // Stage 1: Input registration and breakpoint comparison
    reg signed [OUTPUT_WIDTH-1:0] slope_next, intercept_next;
    
    always @(*) begin
        // Combinational selection of slope and intercept
        if (x <= BP_N6) begin
            slope_next = 0;
            intercept_next = CONST_0_002;
        end
        else if (x >= BP_6) begin
            slope_next = 0;
            intercept_next = CONST_0_998;
        end
        else if (x < BP_N4) begin
            slope_next = SLOPE_1;
            intercept_next = INTERCEPT_1;
        end
        else if (x < BP_N25) begin
            slope_next = SLOPE_2;
            intercept_next = INTERCEPT_2;
        end
        else if (x < BP_N15) begin
            slope_next = SLOPE_3;
            intercept_next = INTERCEPT_3;
        end
        else if (x < BP_N07) begin
            slope_next = SLOPE_4;
            intercept_next = INTERCEPT_4;
        end
        else if (x < BP_0) begin
            slope_next = SLOPE_5;
            intercept_next = INTERCEPT_5;
        end
        else if (x < BP_07) begin
            slope_next = SLOPE_5;
            intercept_next = INTERCEPT_6;
        end
        else if (x < BP_15) begin
            slope_next = SLOPE_4;
            intercept_next = INTERCEPT_7;
        end
        else if (x < BP_25) begin
            slope_next = SLOPE_3;
            intercept_next = INTERCEPT_8;
        end
        else if (x < BP_4) begin
            slope_next = SLOPE_2;
            intercept_next = INTERCEPT_9;
        end
        else begin
            slope_next = SLOPE_1;
            intercept_next = INTERCEPT_10;
        end
    end

    // Pipeline stages
    always @(posedge clk) begin
        // Stage 1: Register input and parameters
        x_r1 <= x;
        slope_r <= slope_next;
        intercept_r <= intercept_next;
        
        // Stage 2: Multiplication
        mult_r <= x_r1 * slope_r;
        x_r2 <= x_r1;
        
        // Stage 3: Scaling and addition
        result_r <= (mult_r >>> FRAC_WIDTH) + intercept_r;
        
        // Stage 4: Final output with boundary conditions
        if (x_r2 <= BP_N6)
            y <= CONST_0_002;
        else if (x_r2 >= BP_6)
            y <= CONST_0_998;
        else
            y <= result_r;
    end

endmodule