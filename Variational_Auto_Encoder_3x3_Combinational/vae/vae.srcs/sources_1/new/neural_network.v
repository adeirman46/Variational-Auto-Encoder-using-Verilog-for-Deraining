`timescale 1ns / 1ps

module neural_network #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10
)(
    input signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9,
    input [7:0] random_seed,  // Random seed for sampling
    output signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9
);

    wire signed [WEIGHT_WIDTH-1:0] w1_11 = -16'd14; // -0.0139 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_12 = -16'd190; // -0.1857 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_13 = 16'd125; // 0.1222 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_14 = -16'd322; // -0.3141 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_21 = -16'd79; // -0.0771 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_22 = 16'd228; // 0.2226 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_23 = 16'd709; // 0.6922 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_24 = 16'd217; // 0.2124 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_31 = 16'd894; // 0.8731 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_32 = -16'd535; // -0.5221 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_33 = -16'd653; // -0.6375 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_34 = -16'd596; // -0.5822 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_41 = -16'd438; // -0.4274 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_42 = 16'd953; // 0.9308 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_43 = 16'd1195; // 1.1673 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_44 = 16'd790; // 0.7714 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_51 = 16'd569; // 0.5561 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_52 = -16'd1214; // -1.1853 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_53 = -16'd510; // -0.4985 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_54 = -16'd425; // -0.4153 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_61 = -16'd329; // -0.3213 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_62 = 16'd1104; // 1.0781 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_63 = 16'd435; // 0.4248 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_64 = 16'd786; // 0.7672 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_71 = 16'd394; // 0.3846 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_72 = -16'd325; // -0.3177 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_73 = -16'd259; // -0.2532 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_74 = 16'd96; // 0.0933 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_81 = 16'd156; // 0.1524 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_82 = 16'd520; // 0.5077 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_83 = 16'd621; // 0.6067 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_84 = 16'd657; // 0.6417 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_91 = 16'd557; // 0.5443 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_92 = -16'd98; // -0.0959 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_93 = 16'd10; // 0.0095 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w1_94 = -16'd9; // -0.0092 * 1024
    
    wire signed [WEIGHT_WIDTH-1:0] w_mu_11 = 16'd853; // 0.8326 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_12 = -16'd178; // -0.1735 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_21 = -16'd1021; // -0.9972 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_22 = 16'd460; // 0.4487 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_31 = -16'd895; // -0.8742 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_32 = 16'd238; // 0.2322 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_41 = -16'd266; // -0.2599 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_mu_42 = 16'd320; // 0.3129 * 1024
    
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_11 = -16'd1141; // -1.1142 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_12 = -16'd172; // -0.1681 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_21 = -16'd502; // -0.4907 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_22 = -16'd878; // -0.8570 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_31 = -16'd433; // -0.4227 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_32 = -16'd193; // -0.1880 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_41 = 16'd38; // 0.0374 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w_sigma_42 = -16'd361; // -0.3526 * 1024
    
    wire signed [WEIGHT_WIDTH-1:0] w3_11 = 16'd1023; // 0.9988 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_12 = -16'd1283; // -1.2526 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_13 = -16'd988; // -0.9648 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_14 = 16'd1116; // 1.0896 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_21 = -16'd167; // -0.1632 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_22 = 16'd943; // 0.9212 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_23 = 16'd644; // 0.6290 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w3_24 = 16'd174; // 0.1700 * 1024
    
    wire signed [WEIGHT_WIDTH-1:0] w4_11 = 16'd531; // 0.5189 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_12 = -16'd740; // -0.7222 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_13 = 16'd926; // 0.9045 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_14 = -16'd958; // -0.9358 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_15 = 16'd865; // 0.8449 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_16 = -16'd688; // -0.6723 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_17 = 16'd967; // 0.9445 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_18 = -16'd783; // -0.7648 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_19 = 16'd416; // 0.4061 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_21 = 16'd208; // 0.2029 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_22 = 16'd599; // 0.5849 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_23 = 16'd94; // 0.0922 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_24 = -16'd18; // -0.0179 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_25 = -16'd663; // -0.6475 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_26 = 16'd467; // 0.4561 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_27 = 16'd28; // 0.0275 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_28 = 16'd772; // 0.7538 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_29 = 16'd294; // 0.2868 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_31 = 16'd299; // 0.2915 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_32 = 16'd461; // 0.4505 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_33 = 16'd498; // 0.4868 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_34 = 16'd837; // 0.8170 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_35 = -16'd272; // -0.2656 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_36 = 16'd690; // 0.6741 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_37 = 16'd648; // 0.6325 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_38 = 16'd115; // 0.1125 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_39 = 16'd766; // 0.7480 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_41 = 16'd471; // 0.4598 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_42 = -16'd633; // -0.6178 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_43 = 16'd145; // 0.1413 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_44 = -16'd630; // -0.6150 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_45 = 16'd706; // 0.6890 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_46 = -16'd423; // -0.4131 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_47 = 16'd285; // 0.2785 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_48 = -16'd507; // -0.4956 * 1024
    wire signed [WEIGHT_WIDTH-1:0] w4_49 = 16'd467; // 0.4558 * 1024
    
    wire signed [BIAS_WIDTH-1:0] b1_1 = 16'd288; // 0.2810 * 1024
    wire signed [BIAS_WIDTH-1:0] b1_2 = -16'd105; // -0.1026 * 1024
    wire signed [BIAS_WIDTH-1:0] b1_3 = -16'd741; // -0.7233 * 1024
    wire signed [BIAS_WIDTH-1:0] b1_4 = -16'd663; // -0.6472 * 1024
    
    wire signed [BIAS_WIDTH-1:0] b_mu_1 = 16'd4; // 0.0042 * 1024
    wire signed [BIAS_WIDTH-1:0] b_mu_2 = -16'd197; // -0.1926 * 1024
    wire signed [BIAS_WIDTH-1:0] b_sigma_1 = -16'd433; // -0.4229 * 1024
    wire signed [BIAS_WIDTH-1:0] b_sigma_2 = -16'd290; // -0.2828 * 1024
    
    wire signed [BIAS_WIDTH-1:0] b3_1 = 16'd678; // 0.6623 * 1024
    wire signed [BIAS_WIDTH-1:0] b3_2 = 16'd650; // 0.6345 * 1024
    wire signed [BIAS_WIDTH-1:0] b3_3 = 16'd918; // 0.8965 * 1024
    wire signed [BIAS_WIDTH-1:0] b3_4 = 16'd446; // 0.4357 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_1 = 16'd780; // 0.7619 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_2 = 16'd126; // 0.1226 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_3 = 16'd686; // 0.6702 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_4 = 16'd155; // 0.1515 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_5 = -16'd425; // -0.4154 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_6 = -16'd735; // -0.7181 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_7 = -16'd48; // -0.0464 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_8 = 16'd96; // 0.0937 * 1024
    wire signed [BIAS_WIDTH-1:0] b4_9 = 16'd238; // 0.2319 * 1024

// Internal signals for encoder pathway
    wire signed [ACTIVATION_WIDTH-1:0] h1_1, h1_2, h1_3, h1_4;  // First hidden layer outputs
    wire signed [ACTIVATION_WIDTH-1:0] mu1, mu2;                 // Mu outputs
    wire signed [ACTIVATION_WIDTH-1:0] sigma1, sigma2;           // Sigma outputs
    wire signed [ACTIVATION_WIDTH-1:0] epsilon1, epsilon2;       // Random normal variables
    wire signed [ACTIVATION_WIDTH-1:0] z1, z2;                   // Sampled latent variables
    wire signed [ACTIVATION_WIDTH-1:0] h3_1, h3_2, h3_3, h3_4;  // Decoder hidden layer outputs

    // First encoder layer (9->4)
    neuron_9input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_1 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_11), .w2(w1_21), .w3(w1_31), .w4(w1_41), .w5(w1_51), .w6(w1_61), .w7(w1_71), .w8(w1_81), .w9(w1_91),
        .b(b1_1), .y(h1_1)
    );

    neuron_9input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_2 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_12), .w2(w1_22), .w3(w1_32), .w4(w1_42), .w5(w1_52), .w6(w1_62), .w7(w1_72), .w8(w1_82), .w9(w1_92),
        .b(b1_2), .y(h1_2)
    );

    neuron_9input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_3 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_13), .w2(w1_23), .w3(w1_33), .w4(w1_43), .w5(w1_53), .w6(w1_63), .w7(w1_73), .w8(w1_83), .w9(w1_93),
                .b(b1_3), .y(h1_3)
    );
    
    neuron_9input #(.ACTIVATION_TYPE("SOFTPLUS")) n1_4 (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .w1(w1_14), .w2(w1_24), .w3(w1_34), .w4(w1_44), .w5(w1_54), .w6(w1_64), .w7(w1_74), .w8(w1_84), .w9(w1_94),
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

//    // Sample from normal distribution
//    random_normal rn1 (
//        .rand_in(random_seed),
//        .rand_out(z1)
//    );

//    random_normal rn2 (
//        .rand_in(random_seed + 8'd1),
//        .rand_out(z2)
//    );
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
    
    // Scale back to fixed point and add mu
    assign z1 = mu1 + (sigma1_epsilon1 >>> FRAC_WIDTH);
    assign z2 = mu2 + (sigma2_epsilon2 >>> FRAC_WIDTH);

    // First decoder layer (2->4)
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

    // Output layer neurons (4->9)
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

endmodule
    