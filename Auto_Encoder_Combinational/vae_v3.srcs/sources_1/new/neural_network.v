`timescale 1ns / 1ps

module neural_network #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9,
    output signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9
);

    // Layer 1 weights (multiplied by 2^10 and rounded)
    // First neuron weights
    wire signed [WEIGHT_WIDTH-1:0] w1_11 = 16'd370;  // 0.3613 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_12 = 16'd920;  // 0.8988 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_13 = 16'd29;   // 0.0284 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_14 = 16'd951;  // 0.9284 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_15 = -16'd711; // -0.6947 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_16 = 16'd706;  // 0.6894 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_17 = -16'd57;  // -0.0558 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_18 = 16'd838;  // 0.8179 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_19 = 16'd410;  // 0.4003 * 1024
    
    // Second neuron weights
    wire signed [WEIGHT_WIDTH-1:0] w1_21 = -16'd29;   // -0.0283 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_22 = 16'd1428;  // 1.3945 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_23 = 16'd285;   // 0.2787 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_24 = 16'd1383;  // 1.3510 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_25 = -16'd885;  // -0.8640 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_26 = 16'd1296;  // 1.2655 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_27 = 16'd173;   // 0.1692 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_28 = 16'd1394;  // 1.3617 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_29 = 16'd272;   // 0.2656 * 1024

    // Layer 1 biases
    wire signed [BIAS_WIDTH-1:0] b1_1 = -16'd50;   // -0.0492 * 1024
    wire signed [BIAS_WIDTH-1:0] b1_2 = 16'd309;   // 0.3013 * 1024

    // Layer 2 weights
    // Output 1
    wire signed [WEIGHT_WIDTH-1:0] w2_11 = 16'd189;   // 0.1848 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_12 = 16'd650;   // 0.6348 * 1024
    // Output 2
    wire signed [WEIGHT_WIDTH-1:0] w2_21 = 16'd332;   // 0.3247 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_22 = 16'd1167;  // 1.1399 * 1024
    // Output 3
    wire signed [WEIGHT_WIDTH-1:0] w2_31 = 16'd180;   // 0.1762 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_32 = 16'd540;   // 0.5278 * 1024
    // Output 4
    wire signed [WEIGHT_WIDTH-1:0] w2_41 = 16'd1018;  // 0.9945 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_42 = 16'd633;   // 0.6184 * 1024
    // Output 5
    wire signed [WEIGHT_WIDTH-1:0] w2_51 = -16'd331;  // -0.3234 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_52 = -16'd1200; // -1.1716 * 1024
    // Output 6
    wire signed [WEIGHT_WIDTH-1:0] w2_61 = 16'd1717;  // 1.6764 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_62 = 16'd201;   // 0.1964 * 1024
    // Output 7
    wire signed [WEIGHT_WIDTH-1:0] w2_71 = 16'd833;   // 0.8135 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_72 = 16'd678;   // 0.6623 * 1024
    // Output 8
    wire signed [WEIGHT_WIDTH-1:0] w2_81 = 16'd393;   // 0.3843 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_82 = 16'd1135;  // 1.1086 * 1024
    // Output 9
    wire signed [WEIGHT_WIDTH-1:0] w2_91 = 16'd315;   // 0.3079 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w2_92 = 16'd1151;  // 1.1244 * 1024

    // Layer 2 biases
    wire signed [BIAS_WIDTH-1:0] b2_1 = 16'd2730;  // 2.6662 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_2 = -16'd3354; // -3.2753 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_3 = 16'd2707;  // 2.6440 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_4 = -16'd3158; // -3.0844 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_5 = 16'd3390;  // 3.3103 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_6 = -16'd2958; // -2.8892 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_7 = 16'd3042;  // 2.9706 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_8 = -16'd3390; // -3.3105 * 1024
    wire signed [BIAS_WIDTH-1:0] b2_9 = 16'd3088;  // 3.0157 * 1024

    // Layer 1 outputs
    wire signed [ACTIVATION_WIDTH-1:0] l1_out1, l1_out2;

    // First hidden layer neuron (ReLU)
    neuron_relu n1_1 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_11), .w2(w1_12), .w3(w1_13), .w4(w1_14), .w5(w1_15), 
        .w6(w1_16), .w7(w1_17), .w8(w1_18), .w9(w1_19),
        .b(b1_1),
        .y(l1_out1)
    );

    // Second hidden layer neuron (ReLU)
    neuron_relu n1_2 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_21), .w2(w1_22), .w3(w1_23), .w4(w1_24), .w5(w1_25), 
        .w6(w1_26), .w7(w1_27), .w8(w1_28), .w9(w1_29),
        .b(b1_2),
        .y(l1_out2)
    );

    // Output layer neurons (Sigmoid)
    neuron_sigmoid n2_1 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_11), .w2(w2_12), .b(b2_1), .y(out1));
    neuron_sigmoid n2_2 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_21), .w2(w2_22), .b(b2_2), .y(out2));
    neuron_sigmoid n2_3 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_31), .w2(w2_32), .b(b2_3), .y(out3));
    neuron_sigmoid n2_4 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_41), .w2(w2_42), .b(b2_4), .y(out4));
    neuron_sigmoid n2_5 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_51), .w2(w2_52), .b(b2_5), .y(out5));
    neuron_sigmoid n2_6 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_61), .w2(w2_62), .b(b2_6), .y(out6));
    neuron_sigmoid n2_7 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_71), .w2(w2_72), .b(b2_7), .y(out7));
    neuron_sigmoid n2_8 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_81), .w2(w2_82), .b(b2_8), .y(out8));
    neuron_sigmoid n2_9 (.x1(l1_out1), .x2(l1_out2), 
                        .w1(w2_91), .w2(w2_92), .b(b2_9), .y(out9));

endmodule