`timescale 1ns / 1ps

module sigmoid_tb;
    // Parameters matching the sigmoid module
    parameter INPUT_WIDTH = 16;
    parameter OUTPUT_WIDTH = 16;
    parameter FRAC_WIDTH = 10;

    // Testbench variables
    reg signed [INPUT_WIDTH-1:0] x;
    wire signed [OUTPUT_WIDTH-1:0] y;

    // Function to convert fixed-point to real
    function real fixed_point_to_real;
        input signed [OUTPUT_WIDTH-1:0] fixed_point;
        begin
            fixed_point_to_real = $itor(fixed_point) / $itor(1 << FRAC_WIDTH);
        end
    endfunction

    // Instantiate the sigmoid module
    sigmoid #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) sigmoid_inst(
        .x(x),
        .y(y)
    );

    // Test stimulus
    integer i;
    real x_real, y_real;

    initial begin
        // Print header
        $display("Starting Sigmoid Function Test");
        $display("Time\tx_real\ty_real");
        $monitor("%0t\t%f\t%f", $time, x_real, y_real);

        // Initialize
        x = 0;
        #10;

        // Test range of values
        for (i = -6; i <= 6; i = i + 1) begin
            test_point(i);
        end

        #100;
        $display("Sigmoid Function Test Complete");
        $finish;
    end

    // Task to test a specific input value
    task test_point;
        input real test_value;
        begin
            // Convert real input to fixed-point
            x = test_value * (1 << FRAC_WIDTH);
            x_real = test_value;
            #10;
            
            // Convert fixed-point output to real
            y_real = fixed_point_to_real(y);
            
            // Display results
            $display("Test Point: x = %f, sigmoid(x) = %f", x_real, y_real);
        end
    endtask

endmodule