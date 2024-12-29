`timescale 1ns / 1ps
module random_normal_tb;
    // Parameters
    parameter WIDTH = 16;
    parameter FRAC_WIDTH = 10;
    
    // Testbench signals
    reg [7:0] rand_in;
    wire signed [WIDTH-1:0] rand_out;
    
    // Test variables
    integer i;
    real float_val;
    integer file;
    
    // DUT instantiation
    random_normal #(
        .WIDTH(WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) uut (
        .rand_in(rand_in),
        .rand_out(rand_out)
    );
    
    // Convert fixed point to real for display
    function real fixed2real;
        input signed [WIDTH-1:0] fixed;
        real div;
        begin
            div = 2.0 ** FRAC_WIDTH;
            fixed2real = $itor(fixed) / div;
        end
    endfunction
    
    // Test stimulus
    initial begin
        // Open CSV file
        file = $fopen("normal_dist.csv", "w");
        
        // Write header
        $fwrite(file, "Input,Output\n");
        
        // Initialize
        rand_in = 0;
        
        // Test all input values
        for (i = 0; i <= 255; i = i + 1) begin
            rand_in = i;
            #10;
            float_val = fixed2real(rand_out);
            // Write to CSV file
            $fwrite(file, "%d,%f\n", i, float_val);
        end
        
        // Close file
        $fclose(file);
        
        #10 $finish;
    end
endmodule