
//`timescale 1ns / 1ps

//module neural_network_tb;
//    parameter INPUT_WIDTH = 16;
//    parameter WEIGHT_WIDTH = 16;
//    parameter BIAS_WIDTH = 16;
//    parameter ACTIVATION_WIDTH = 16;
//    parameter FRAC_WIDTH = 10;
//    parameter TOTAL_PATCHES = 1024;
//    parameter TOTAL_VALUES = TOTAL_PATCHES * 16;
    
//    // Inputs
//    reg signed [INPUT_WIDTH-1:0] pixel_values [15:0];
//    reg [7:0] random_seed;
    
//    // Outputs 
//    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8;
//    wire signed [ACTIVATION_WIDTH-1:0] out9, out10, out11, out12, out13, out14, out15, out16;
    
//    // File handles and counters
//    integer outfile;
//    integer i, j;
//    integer completed_patches;
    
//    // Fixed point arrays
//    reg [15:0] raindrop_values [0:TOTAL_VALUES-1];
//    real fixed_point_values[0:15];
    
//    // Function to convert fixed-point to real
//    function real fixed_point_to_real;
//        input signed [ACTIVATION_WIDTH-1:0] fixed_point;
//        begin
//            fixed_point_to_real = $itor(fixed_point) / $itor(1 << FRAC_WIDTH);
//        end
//    endfunction

//    // Instantiate VAE neural network
//    neural_network #(
//        .INPUT_WIDTH(INPUT_WIDTH),
//        .WEIGHT_WIDTH(WEIGHT_WIDTH),
//        .BIAS_WIDTH(BIAS_WIDTH),
//        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
//        .FRAC_WIDTH(FRAC_WIDTH)
//    ) dut (
//        .x1(pixel_values[0]), .x2(pixel_values[1]), .x3(pixel_values[2]), .x4(pixel_values[3]),
//        .x5(pixel_values[4]), .x6(pixel_values[5]), .x7(pixel_values[6]), .x8(pixel_values[7]),
//        .x9(pixel_values[8]), .x10(pixel_values[9]), .x11(pixel_values[10]), .x12(pixel_values[11]),
//        .x13(pixel_values[12]), .x14(pixel_values[13]), .x15(pixel_values[14]), .x16(pixel_values[15]),
//        .random_seed(random_seed),
//        .out1(out1), .out2(out2), .out3(out3), .out4(out4),
//        .out5(out5), .out6(out6), .out7(out7), .out8(out8),
//        .out9(out9), .out10(out10), .out11(out11), .out12(out12),
//        .out13(out13), .out14(out14), .out15(out15), .out16(out16)
//    );

//    initial begin
//        // Initialize variables
//        random_seed = 8'd128;
//        completed_patches = 0;
        
//        // Load memory file
//        $readmemh("raindrop_hex.txt", raindrop_values);
        
//        // Open output file
//        outfile = $fopen("results.txt", "w");
        
//        // Process all patches
//        for (i = 0; i < TOTAL_VALUES; i = i + 16) begin
//            // Load 16 pixels for current patch
//            for (j = 0; j < 16; j = j + 1) begin
//                pixel_values[j] = raindrop_values[i+j];
//            end
            
//            // Wait for outputs to stabilize
//            #10;
            
//            // Write outputs in simple format
//            $fdisplay(outfile, "%f", fixed_point_to_real(out1));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out2));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out3));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out4));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out5));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out6));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out7));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out8));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out9));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out10));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out11));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out12));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out13));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out14));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out15));
//            $fdisplay(outfile, "%f", fixed_point_to_real(out16));
//        end
        
//        $fclose(outfile);
//        $finish;
//    end

//    // Timeout watchdog
//    initial begin
//        #11000
//        $display("Simulation timeout reached!");
//        $finish;
//    end

//endmodule

`timescale 1ns / 1ps

module neural_network_tb;
    parameter INPUT_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter BIAS_WIDTH = 16;
    parameter ACTIVATION_WIDTH = 16;
    parameter FRAC_WIDTH = 10;
    parameter PATCH_SIZE = 16;
    parameter NUM_PATCHES = 1024;
    parameter TOTAL_VALUES = NUM_PATCHES * PATCH_SIZE;
    
    // Inputs
    reg signed [INPUT_WIDTH-1:0] pixel_values [0:PATCH_SIZE-1];  // Array to hold patch pixels
    reg [7:0] random_seed;
    
    // Outputs 
    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8;
    wire signed [ACTIVATION_WIDTH-1:0] out9, out10, out11, out12, out13, out14, out15, out16;
    
    // File handles and counters
    integer outfile, infile;
    integer patch_idx, pixel_idx;
    integer scan_success;
    
    // Storage arrays
    reg [15:0] raindrop_values [0:TOTAL_VALUES-1];  // Input image data
    real output_values [0:PATCH_SIZE-1];            // Converted output values
    
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
        .x1(pixel_values[0]), .x2(pixel_values[1]), .x3(pixel_values[2]), .x4(pixel_values[3]),
        .x5(pixel_values[4]), .x6(pixel_values[5]), .x7(pixel_values[6]), .x8(pixel_values[7]),
        .x9(pixel_values[8]), .x10(pixel_values[9]), .x11(pixel_values[10]), .x12(pixel_values[11]),
        .x13(pixel_values[12]), .x14(pixel_values[13]), .x15(pixel_values[14]), .x16(pixel_values[15]),
        .random_seed(random_seed),
        .out1(out1), .out2(out2), .out3(out3), .out4(out4),
        .out5(out5), .out6(out6), .out7(out7), .out8(out8),
        .out9(out9), .out10(out10), .out11(out11), .out12(out12),
        .out13(out13), .out14(out14), .out15(out15), .out16(out16)
    );

    // Store output values in array for easier processing
    always @* begin
        output_values[0] = fixed_point_to_real(out1);
        output_values[1] = fixed_point_to_real(out2);
        output_values[2] = fixed_point_to_real(out3);
        output_values[3] = fixed_point_to_real(out4);
        output_values[4] = fixed_point_to_real(out5);
        output_values[5] = fixed_point_to_real(out6);
        output_values[6] = fixed_point_to_real(out7);
        output_values[7] = fixed_point_to_real(out8);
        output_values[8] = fixed_point_to_real(out9);
        output_values[9] = fixed_point_to_real(out10);
        output_values[10] = fixed_point_to_real(out11);
        output_values[11] = fixed_point_to_real(out12);
        output_values[12] = fixed_point_to_real(out13);
        output_values[13] = fixed_point_to_real(out14);
        output_values[14] = fixed_point_to_real(out15);
        output_values[15] = fixed_point_to_real(out16);
    end

    initial begin
        // Initialize variables
        random_seed = 8'd128;  // Starting random seed
        
        // Load input data
        $readmemh("raindrop_hex.txt", raindrop_values);
        
        // Open output file
        outfile = $fopen("results4.txt", "w");
        if (!outfile) begin
            $display("Error: Could not open results.txt for writing");
            $finish;
        end
        
        // Process all patches
        for (patch_idx = 0; patch_idx < NUM_PATCHES; patch_idx = patch_idx + 1) begin
            // Load current patch pixels
            for (pixel_idx = 0; pixel_idx < PATCH_SIZE; pixel_idx = pixel_idx + 1) begin
                pixel_values[pixel_idx] = raindrop_values[patch_idx * PATCH_SIZE + pixel_idx];
            end
            
            // Allow time for combinational logic to settle
            #10;
            
            // Write all outputs for current patch
            for (pixel_idx = 0; pixel_idx < PATCH_SIZE; pixel_idx = pixel_idx + 1) begin
                $fdisplay(outfile, "%f", output_values[pixel_idx]);
            end
            
            // Optional: Progress indicator
            if ((patch_idx + 1) % 100 == 0) begin
                $display("Processed %0d/%0d patches", patch_idx + 1, NUM_PATCHES);
            end
        end
        
        $fclose(outfile);
        $display("Simulation completed successfully");
        $finish;
    end

    // Simulation timeout watchdog
    initial begin
        #(11000);  // Adjust timeout value as needed
        $display("Error: Simulation timeout - possible infinite loop");
        $finish;
    end

endmodule