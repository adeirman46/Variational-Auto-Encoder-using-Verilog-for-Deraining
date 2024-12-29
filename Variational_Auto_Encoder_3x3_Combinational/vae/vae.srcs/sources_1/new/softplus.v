`timescale 1ns / 1ps

module softplus #(
    parameter INPUT_WIDTH = 16,     // Input fixed-point width
    parameter OUTPUT_WIDTH = 16,     // Output fixed-point width
    parameter FRAC_WIDTH = 10       // Fractional bits for fixed-point
)(
    input wire signed [INPUT_WIDTH-1:0] x,
    output wire signed [OUTPUT_WIDTH-1:0] y
);

// Fixed point constants (scaled by 2^FRAC_WIDTH)
localparam signed [OUTPUT_WIDTH-1:0] 
    CONST_0_002 = 16'h0001,      // 0.002 * 2^10 ? 2
    
    // Slopes (multiplied by 2^FRAC_WIDTH)
    SLOPE_1 = 16'h0012,          // 0.018 * 2^10 ? 18
    SLOPE_2 = 16'h002D,          // 0.044 * 2^10 ? 45
    SLOPE_3 = 16'h007B,          // 0.120 * 2^10 ? 123
    SLOPE_4 = 16'h00E1,          // 0.220 * 2^10 ? 225
    SLOPE_5 = 16'h01D0,          // 0.454 * 2^10 ? 464
    SLOPE_6 = 16'h0237,          // 0.557 * 2^10 ? 567
    SLOPE_7 = 16'h02C6,          // 0.700 * 2^10 ? 710
    SLOPE_8 = 16'h0320,          // 0.780 * 2^10 ? 800
    SLOPE_9 = 16'h039A,          // 0.900 * 2^10 ? 922
    SLOPE_10 = 16'h03C3,         // 0.940 * 2^10 ? 963
    
    // Intercepts (multiplied by 2^FRAC_WIDTH)
    INTERCEPT_1 = 16'h0070,      // 0.110 * 2^10 ? 113
    INTERCEPT_2 = 16'h00DB,      // 0.214 * 2^10 ? 219
    INTERCEPT_3 = 16'h019C,      // 0.403 * 2^10 ? 412
    INTERCEPT_4 = 16'h0233,      // 0.553 * 2^10 ? 563
    INTERCEPT_5 = 16'h02C4,      // 0.693 * 2^10 ? 708
    INTERCEPT_6 = 16'h02C4,      // 0.693 * 2^10 ? 708
    INTERCEPT_7 = 16'h0296,      // 0.650 * 2^10 ? 666
    INTERCEPT_8 = 16'h0266,      // 0.600 * 2^10 ? 614
    INTERCEPT_9 = 16'h0199,      // 0.400 * 2^10 ? 409
    INTERCEPT_10 = 16'h0133;     // 0.300 * 2^10 ? 307

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
              (x < BP_07) ? SLOPE_6 :
              (x < BP_15) ? SLOPE_7 :
              (x < BP_25) ? SLOPE_8 :
              (x < BP_4) ? SLOPE_9 : SLOPE_10;

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
          (x >= BP_6) ? (x + INTERCEPT_6) : result;

endmodule