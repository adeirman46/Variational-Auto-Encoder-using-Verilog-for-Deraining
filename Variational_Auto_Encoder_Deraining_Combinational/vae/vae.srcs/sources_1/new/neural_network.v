`timescale 1ns / 1ps

module neural_network #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    // Input: 4x4 patch (16 inputs)
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16,
    input [7:0] random_seed,  // Random seed for sampling
    // Output: 4x4 patch (16 outputs)
    output signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16
);

    // Include weights and biases
    `include "vae_weights.v"

    // Internal signals for encoder pathway
    wire signed [ACTIVATION_WIDTH-1:0] h1_1, h1_2, h1_3, h1_4;  // First hidden layer outputs (16->4)
    wire signed [ACTIVATION_WIDTH-1:0] mu1, mu2;                 // Mu outputs (4->2)
    wire signed [ACTIVATION_WIDTH-1:0] sigma1, sigma2;           // Sigma outputs (4->2)
    wire signed [ACTIVATION_WIDTH-1:0] epsilon1, epsilon2;       // Random normal variables
    wire signed [ACTIVATION_WIDTH-1:0] z1, z2;                   // Sampled latent variables
    wire signed [ACTIVATION_WIDTH-1:0] h3_1, h3_2, h3_3, h3_4;  // Decoder hidden layer outputs (2->4)

    // First encoder layer (16->4)
    neuron_16input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_1 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
        .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16),
        .w1(w1_11), .w2(w1_21), .w3(w1_31), .w4(w1_41), .w5(w1_51), .w6(w1_61), .w7(w1_71), .w8(w1_81),
        .w9(w1_91), .w10(w1_101), .w11(w1_111), .w12(w1_121), .w13(w1_131), .w14(w1_141), .w15(w1_151), .w16(w1_161),
        .b(b1_1), .y(h1_1)
    );

    neuron_16input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_2 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
        .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16),
        .w1(w1_12), .w2(w1_22), .w3(w1_32), .w4(w1_42), .w5(w1_52), .w6(w1_62), .w7(w1_72), .w8(w1_82),
        .w9(w1_92), .w10(w1_102), .w11(w1_112), .w12(w1_122), .w13(w1_132), .w14(w1_142), .w15(w1_152), .w16(w1_162),
        .b(b1_2), .y(h1_2)
    );

    neuron_16input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_3 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
        .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16),
        .w1(w1_13), .w2(w1_23), .w3(w1_33), .w4(w1_43), .w5(w1_53), .w6(w1_63), .w7(w1_73), .w8(w1_83),
        .w9(w1_93), .w10(w1_103), .w11(w1_113), .w12(w1_123), .w13(w1_133), .w14(w1_143), .w15(w1_153), .w16(w1_163),
        .b(b1_3), .y(h1_3)
    );

    neuron_16input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_4 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
        .x9(x9), .x10(x10), .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15), .x16(x16),
        .w1(w1_14), .w2(w1_24), .w3(w1_34), .w4(w1_44), .w5(w1_54), .w6(w1_64), .w7(w1_74), .w8(w1_84),
        .w9(w1_94), .w10(w1_104), .w11(w1_114), .w12(w1_124), .w13(w1_134), .w14(w1_144), .w15(w1_154), .w16(w1_164),
        .b(b1_4), .y(h1_4)
    );

    // Mu encoder neurons (4->2)
    neuron_4input #(.ACTIVATION_TYPE("SOFTPLUS")) mu1_neuron (
        .x1(h1_1), .x2(h1_2), .x3(h1_3), .x4(h1_4),
        .w1(w_mu_11), .w2(w_mu_21), .w3(w_mu_31), .w4(w_mu_41),
        .b(b_mu_1), .y(mu1)
    );

    neuron_4input #(.ACTIVATION_TYPE("SOFTPLUS")) mu2_neuron (
        .x1(h1_1), .x2(h1_2), .x3(h1_3), .x4(h1_4),
        .w1(w_mu_12), .w2(w_mu_22), .w3(w_mu_32), .w4(w_mu_42),
        .b(b_mu_2), .y(mu2)
    );

    // Sigma encoder neurons (4->2)
    neuron_4input #(.ACTIVATION_TYPE("SOFTPLUS")) sigma1_neuron (
        .x1(h1_1), .x2(h1_2), .x3(h1_3), .x4(h1_4),
        .w1(w_sigma_11), .w2(w_sigma_21), .w3(w_sigma_31), .w4(w_sigma_41),
        .b(b_sigma_1), .y(sigma1)
    );

    neuron_4input #(.ACTIVATION_TYPE("SOFTPLUS")) sigma2_neuron (
        .x1(h1_1), .x2(h1_2), .x3(h1_3), .x4(h1_4),
        .w1(w_sigma_12), .w2(w_sigma_22), .w3(w_sigma_32), .w4(w_sigma_42),
        .b(b_sigma_2), .y(sigma2)
    );

    // Generate random normal samples
    random_normal #(
        .WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) rn1 (
        .rand_in(random_seed),
        .rand_out(epsilon1)
    );

    random_normal #(
        .WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) rn2 (
        .rand_in(random_seed + 8'd1),
        .rand_out(epsilon2)
    );
    
    // Reparameterization trick: z = mu + sigma * epsilon
    wire signed [2*ACTIVATION_WIDTH-1:0] sigma1_epsilon1 = sigma1 * epsilon1;
    wire signed [2*ACTIVATION_WIDTH-1:0] sigma2_epsilon2 = sigma2 * epsilon2;
    
    assign z1 = mu1 + (sigma1_epsilon1 >>> FRAC_WIDTH);
    assign z2 = mu2 + (sigma2_epsilon2 >>> FRAC_WIDTH);

    // Decoder first layer (2->4)
    neuron_2input #(.ACTIVATION_TYPE("SOFTPLUS")) d1_1 (
        .x1(z1), .x2(z2),
        .w1(w3_11), .w2(w3_21),
        .b(b3_1), .y(h3_1)
    );

    neuron_2input #(.ACTIVATION_TYPE("SOFTPLUS")) d1_2 (
        .x1(z1), .x2(z2),
        .w1(w3_12), .w2(w3_22),
        .b(b3_2), .y(h3_2)
    );

    neuron_2input #(.ACTIVATION_TYPE("SOFTPLUS")) d1_3 (
        .x1(z1), .x2(z2),
        .w1(w3_13), .w2(w3_23),
        .b(b3_3), .y(h3_3)
    );

    neuron_2input #(.ACTIVATION_TYPE("SOFTPLUS")) d1_4 (
        .x1(z1), .x2(z2),
        .w1(w3_14), .w2(w3_24),
        .b(b3_4), .y(h3_4)
    );

    // Output layer neurons (4->16)
    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out1_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_11), .w2(w4_21), .w3(w4_31), .w4(w4_41),
        .b(b4_1), .y(out1)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out2_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_12), .w2(w4_22), .w3(w4_32), .w4(w4_42),
        .b(b4_2), .y(out2)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out3_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_13), .w2(w4_23), .w3(w4_33), .w4(w4_43),
        .b(b4_3), .y(out3)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out4_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_14), .w2(w4_24), .w3(w4_34), .w4(w4_44),
        .b(b4_4), .y(out4)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out5_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_15), .w2(w4_25), .w3(w4_35), .w4(w4_45),
        .b(b4_5), .y(out5)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out6_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_16), .w2(w4_26), .w3(w4_36), .w4(w4_46),
        .b(b4_6), .y(out6)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out7_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_17), .w2(w4_27), .w3(w4_37), .w4(w4_47),
        .b(b4_7), .y(out7)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out8_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_18), .w2(w4_28), .w3(w4_38), .w4(w4_48),
        .b(b4_8), .y(out8)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out9_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_19), .w2(w4_29), .w3(w4_39), .w4(w4_49),
        .b(b4_9), .y(out9)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out10_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_110), .w2(w4_210), .w3(w4_310), .w4(w4_410),
        .b(b4_10), .y(out10)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out11_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_111), .w2(w4_211), .w3(w4_311), .w4(w4_411),
        .b(b4_11), .y(out11)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out12_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_112), .w2(w4_212), .w3(w4_312), .w4(w4_412),
        .b(b4_12), .y(out12)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out13_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_113), .w2(w4_213), .w3(w4_313), .w4(w4_413),
        .b(b4_13), .y(out13)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out14_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_114), .w2(w4_214), .w3(w4_314), .w4(w4_414),
        .b(b4_14), .y(out14)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out15_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_115), .w2(w4_215), .w3(w4_315), .w4(w4_415),
        .b(b4_15), .y(out15)
    );

    neuron_4input #(.ACTIVATION_TYPE("SIGMOID")) out16_neuron (
        .x1(h3_1), .x2(h3_2), .x3(h3_3), .x4(h3_4),
        .w1(w4_116), .w2(w4_216), .w3(w4_316), .w4(w4_416),
        .b(b4_16), .y(out16)
    );

endmodule