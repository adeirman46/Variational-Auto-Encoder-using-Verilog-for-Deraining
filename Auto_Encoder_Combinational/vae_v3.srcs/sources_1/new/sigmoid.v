`timescale 1ns / 1ps

module sigmoid #(
    parameter INPUT_WIDTH = 16,     // Input fixed-point width
    parameter OUTPUT_WIDTH = 16,     // Output fixed-point width
    parameter FRAC_WIDTH = 10       // Fractional bits for fixed-point
)(
    input wire signed [INPUT_WIDTH-1:0] x,
    output wire signed [OUTPUT_WIDTH-1:0] y
);

// Fixed point constants (scaled by 2^FRAC_WIDTH)
localparam signed [OUTPUT_WIDTH-1:0] 
    CONST_0_002 = 16'h0001,      // 0.002 * 2^10 ≈ 2
    CONST_0_998 = 16'h03FE,      // 0.998 * 2^10 ≈ 1022
    
    // Slopes (multiplied by 2^FRAC_WIDTH)
    SLOPE_1 = 16'h0009,          // 0.009 * 2^10 ≈ 9
    SLOPE_2 = 16'h0022,          // 0.033 * 2^10 ≈ 34
    SLOPE_3 = 16'h006B,          // 0.105 * 2^10 ≈ 107
    SLOPE_4 = 16'h00C7,          // 0.195 * 2^10 ≈ 199
    SLOPE_5 = 16'h0100,          // 0.250 * 2^10 ≈ 256
    
    // Intercepts (multiplied by 2^FRAC_WIDTH)
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

// Temporary variables for calculation
wire signed [2*INPUT_WIDTH-1:0] temp_mult;
wire signed [OUTPUT_WIDTH-1:0] slope, intercept;
wire signed [OUTPUT_WIDTH-1:0] result;

// Slope and intercept selection logic
assign slope = (x < BP_N4) ? SLOPE_1 :
              (x < BP_N25) ? SLOPE_2 :
              (x < BP_N15) ? SLOPE_3 :
              (x < BP_N07) ? SLOPE_4 :
              (x < BP_0) ? SLOPE_5 :
              (x < BP_07) ? SLOPE_5 :
              (x < BP_15) ? SLOPE_4 :
              (x < BP_25) ? SLOPE_3 :
              (x < BP_4) ? SLOPE_2 : SLOPE_1;

assign intercept = (x < BP_N4) ? INTERCEPT_1 :
                  (x < BP_N25) ? INTERCEPT_2 :
                  (x < BP_N15) ? INTERCEPT_3 :
                  (x < BP_N07) ? INTERCEPT_4 :
                  (x < BP_0) ? INTERCEPT_5 :
                  (x < BP_07) ? INTERCEPT_6 :
                  (x < BP_15) ? INTERCEPT_7 :
                  (x < BP_25) ? INTERCEPT_8 :
                  (x < BP_4) ? INTERCEPT_9 : INTERCEPT_10;

assign temp_mult = (x * slope) >>> FRAC_WIDTH;
assign result = temp_mult[OUTPUT_WIDTH-1:0] + intercept;

// Final output selection
assign y = (x <= BP_N6) ? CONST_0_002 :
          (x >= BP_6) ? CONST_0_998 : result;

endmodule