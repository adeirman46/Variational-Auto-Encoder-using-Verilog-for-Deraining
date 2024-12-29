module neural_network_tb;
    parameter INPUT_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter BIAS_WIDTH = 16;
    parameter ACTIVATION_WIDTH = 16;
    parameter FRAC_WIDTH = 10;
    
    reg clk;
    reg signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9;
    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Function to convert fixed-point to real
    function real fixed_point_to_real;
        input signed [ACTIVATION_WIDTH-1:0] fixed_point;
        begin
            fixed_point_to_real = $itor(fixed_point) / $itor(1 << FRAC_WIDTH);
        end
    endfunction

    // Task to display input pattern
    task display_input_pattern;
        begin
            $display("Input Pattern:");
            $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x1), fixed_point_to_real(x2), fixed_point_to_real(x3));
            $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x4), fixed_point_to_real(x5), fixed_point_to_real(x6));
            $display("%1.1f %1.1f %1.1f", fixed_point_to_real(x7), fixed_point_to_real(x8), fixed_point_to_real(x9));
        end
    endtask

    // Task to display output values
    task display_outputs;
        begin
            $display("\nOutputs:");
            $display("out1=%f, out2=%f, out3=%f", fixed_point_to_real(out1), fixed_point_to_real(out2), fixed_point_to_real(out3));
            $display("out4=%f, out5=%f, out6=%f", fixed_point_to_real(out4), fixed_point_to_real(out5), fixed_point_to_real(out6));
            $display("out7=%f, out8=%f, out9=%f", fixed_point_to_real(out7), fixed_point_to_real(out8), fixed_point_to_real(out9));
        end
    endtask

    // Instantiate neural network
    neural_network_pipelined #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .BIAS_WIDTH(BIAS_WIDTH),
        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) dut (
        .clk(clk),
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5),
        .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .out1(out1), .out2(out2), .out3(out3),
        .out4(out4), .out5(out5), .out6(out6),
        .out7(out7), .out8(out8), .out9(out9)
    );

    initial begin
        // Initialize all inputs to zero
        x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0;
        x6 = 0; x7 = 0; x8 = 0; x9 = 0;
        
        // Wait for initial reset
        repeat(10) @(posedge clk);
        
        // Test Case 1: Circle pattern
        $display("\nTest Case 1 (Circle):");
        x1 = 16'd1 << FRAC_WIDTH; x2 = 16'd1 << FRAC_WIDTH; x3 = 16'd1 << FRAC_WIDTH;
        x4 = 16'd1 << FRAC_WIDTH; x5 = 16'd0; x6 = 16'd1 << FRAC_WIDTH;
        x7 = 16'd1 << FRAC_WIDTH; x8 = 16'd1 << FRAC_WIDTH; x9 = 16'd1 << FRAC_WIDTH;
        
        display_input_pattern();
        
        // Wait for pipeline to process (total pipeline stages = MAC + ReLU + Sigmoid stages)
        repeat(25) @(posedge clk);
        
        display_outputs();
        
        // Reset inputs between patterns
        x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0;
        x6 = 0; x7 = 0; x8 = 0; x9 = 0;
        
        repeat(10) @(posedge clk);
        
        // Test Case 2: Cross pattern
        $display("\nTest Case 2 (Cross):");
        x1 = 16'd1 << FRAC_WIDTH; x2 = 16'd0; x3 = 16'd1 << FRAC_WIDTH;
        x4 = 16'd0; x5 = 16'd1 << FRAC_WIDTH; x6 = 16'd0;
        x7 = 16'd1 << FRAC_WIDTH; x8 = 16'd0; x9 = 16'd1 << FRAC_WIDTH;
        
        display_input_pattern();
        
        // Wait for pipeline to process
        repeat(25) @(posedge clk);
        
        display_outputs();
        
        // Final wait and finish
        repeat(10) @(posedge clk);
        $finish;
    end

endmodule