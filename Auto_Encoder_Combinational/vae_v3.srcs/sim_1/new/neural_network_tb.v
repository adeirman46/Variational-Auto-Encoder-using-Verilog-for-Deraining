module neural_network_tb;
    parameter INPUT_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter BIAS_WIDTH = 16;
    parameter ACTIVATION_WIDTH = 16;
    parameter FRAC_WIDTH = 10;
    
    reg signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9;
    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;

    // Function to convert fixed-point to real
    function real fixed_point_to_real;
        input signed [ACTIVATION_WIDTH-1:0] fixed_point;
        begin
            fixed_point_to_real = $itor(fixed_point) / $itor(1 << FRAC_WIDTH);
        end
    endfunction

    // Instantiate neural network
    neural_network #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .BIAS_WIDTH(BIAS_WIDTH),
        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) dut (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5),
        .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .out1(out1), .out2(out2), .out3(out3),
        .out4(out4), .out5(out5), .out6(out6),
        .out7(out7), .out8(out8), .out9(out9)
    );

    // Test stimulus
    initial begin
        // Initialize
        x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0;
        x6 = 0; x7 = 0; x8 = 0; x9 = 0;
        
        // Test Case 1: Circle pattern
        #100;
        x1 = 16'd1 << FRAC_WIDTH; x2 = 16'd1 << FRAC_WIDTH; x3 = 16'd1 << FRAC_WIDTH;
        x4 = 16'd1 << FRAC_WIDTH; x5 = 16'd0; x6 = 16'd1 << FRAC_WIDTH;
        x7 = 16'd1 << FRAC_WIDTH; x8 = 16'd1 << FRAC_WIDTH; x9 = 16'd1 << FRAC_WIDTH;
        
        // Wait for combinational delay
        #100;
        $display("Test Case 1 (Circle) Results:");
        $display("Input Pattern:");
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x1), fixed_point_to_real(x2), fixed_point_to_real(x3));
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x4), fixed_point_to_real(x5), fixed_point_to_real(x6));
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x7), fixed_point_to_real(x8), fixed_point_to_real(x9));
        $display("\nOutputs:");
        $display("out1=%f, out2=%f, out3=%f", fixed_point_to_real(out1), fixed_point_to_real(out2), fixed_point_to_real(out3));
        $display("out4=%f, out5=%f, out6=%f", fixed_point_to_real(out4), fixed_point_to_real(out5), fixed_point_to_real(out6));
        $display("out7=%f, out8=%f, out9=%f", fixed_point_to_real(out7), fixed_point_to_real(out8), fixed_point_to_real(out9));
        
        // Test Case 2: Cross pattern
        #100;
        x1 = 16'd1 << FRAC_WIDTH; x2 = 16'd0; x3 = 16'd1 << FRAC_WIDTH;
        x4 = 16'd0; x5 = 16'd1 << FRAC_WIDTH; x6 = 16'd0;
        x7 = 16'd1 << FRAC_WIDTH; x8 = 16'd0; x9 = 16'd1 << FRAC_WIDTH;
        
        // Wait for combinational delay
        #100;
        $display("\nTest Case 2 (Cross) Results:");
        $display("Input Pattern:");
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x1), fixed_point_to_real(x2), fixed_point_to_real(x3));
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x4), fixed_point_to_real(x5), fixed_point_to_real(x6));
        $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x7), fixed_point_to_real(x8), fixed_point_to_real(x9));
        $display("\nOutputs:");
        $display("out1=%f, out2=%f, out3=%f", fixed_point_to_real(out1), fixed_point_to_real(out2), fixed_point_to_real(out3));
        $display("out4=%f, out5=%f, out6=%f", fixed_point_to_real(out4), fixed_point_to_real(out5), fixed_point_to_real(out6));
        $display("out7=%f, out8=%f, out9=%f", fixed_point_to_real(out7), fixed_point_to_real(out8), fixed_point_to_real(out9));
        
        // Add more test cases as needed
        #100;
        $finish;
    end
endmodule