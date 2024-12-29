//module axis_neural_network #(
//    parameter INPUT_WIDTH = 16,
//    parameter WEIGHT_WIDTH = 16,
//    parameter BIAS_WIDTH = 16,
//    parameter ACTIVATION_WIDTH = 16,
//    parameter FRAC_WIDTH = 10
//)(
//    // Clock and reset
//    input wire aclk,
//    input wire aresetn,
    
//    // Control
//    input wire en,
    
//    // AXI Stream slave interface
//    output wire s_axis_tready,
//    input wire [INPUT_WIDTH*9-1:0] s_axis_tdata,  // 9 inputs concatenated
//    input wire s_axis_tvalid,
//    input wire s_axis_tlast,
    
//    // AXI Stream master interface
//    input wire m_axis_tready,
//    output wire [ACTIVATION_WIDTH*9-1:0] m_axis_tdata,  // 9 outputs concatenated
//    output wire m_axis_tvalid,
//    output wire m_axis_tlast,
    
//    // Random seed input
//    input wire [7:0] random_seed
//);

//    // Internal signals
//    wire signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9;
//    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;
    
//    // AXI-Stream control logic
//    reg valid_reg;
//    reg last_reg;
    
//    // Input data unpacking
//    assign x1 = s_axis_tdata[INPUT_WIDTH*1-1:INPUT_WIDTH*0];
//    assign x2 = s_axis_tdata[INPUT_WIDTH*2-1:INPUT_WIDTH*1];
//    assign x3 = s_axis_tdata[INPUT_WIDTH*3-1:INPUT_WIDTH*2];
//    assign x4 = s_axis_tdata[INPUT_WIDTH*4-1:INPUT_WIDTH*3];
//    assign x5 = s_axis_tdata[INPUT_WIDTH*5-1:INPUT_WIDTH*4];
//    assign x6 = s_axis_tdata[INPUT_WIDTH*6-1:INPUT_WIDTH*5];
//    assign x7 = s_axis_tdata[INPUT_WIDTH*7-1:INPUT_WIDTH*6];
//    assign x8 = s_axis_tdata[INPUT_WIDTH*8-1:INPUT_WIDTH*7];
//    assign x9 = s_axis_tdata[INPUT_WIDTH*9-1:INPUT_WIDTH*8];
    
//    // Output data packing
//    assign m_axis_tdata[ACTIVATION_WIDTH*1-1:ACTIVATION_WIDTH*0] = out1;
//    assign m_axis_tdata[ACTIVATION_WIDTH*2-1:ACTIVATION_WIDTH*1] = out2;
//    assign m_axis_tdata[ACTIVATION_WIDTH*3-1:ACTIVATION_WIDTH*2] = out3;
//    assign m_axis_tdata[ACTIVATION_WIDTH*4-1:ACTIVATION_WIDTH*3] = out4;
//    assign m_axis_tdata[ACTIVATION_WIDTH*5-1:ACTIVATION_WIDTH*4] = out5;
//    assign m_axis_tdata[ACTIVATION_WIDTH*6-1:ACTIVATION_WIDTH*5] = out6;
//    assign m_axis_tdata[ACTIVATION_WIDTH*7-1:ACTIVATION_WIDTH*6] = out7;
//    assign m_axis_tdata[ACTIVATION_WIDTH*8-1:ACTIVATION_WIDTH*7] = out8;
//    assign m_axis_tdata[ACTIVATION_WIDTH*9-1:ACTIVATION_WIDTH*8] = out9;
    
//    // AXI Stream control signals
//    assign s_axis_tready = en && m_axis_tready;
//    assign m_axis_tvalid = valid_reg && en;
//    assign m_axis_tlast = last_reg;
    
//    // Valid and last signal registration
//    always @(posedge aclk or negedge aresetn) begin
//        if (!aresetn) begin
//            valid_reg <= 1'b0;
//            last_reg <= 1'b0;
//        end
//        else begin
//            if (s_axis_tready && s_axis_tvalid) begin
//                valid_reg <= 1'b1;
//                last_reg <= s_axis_tlast;
//            end
//            else if (m_axis_tready) begin
//                valid_reg <= 1'b0;
//                last_reg <= 1'b0;
//            end
//        end
//    end
    
//    // Neural network instance
//    neural_network #(
//        .INPUT_WIDTH(INPUT_WIDTH),
//        .WEIGHT_WIDTH(WEIGHT_WIDTH),
//        .BIAS_WIDTH(BIAS_WIDTH),
//        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
//        .FRAC_WIDTH(FRAC_WIDTH)
//    ) nn_inst (
//        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5),
//        .x6(x6), .x7(x7), .x8(x8), .x9(x9),
//        .random_seed(random_seed),
//        .out1(out1), .out2(out2), .out3(out3),
//        .out4(out4), .out5(out5), .out6(out6),
//        .out7(out7), .out8(out8), .out9(out9)
//    );

//endmodule

module axis_neural_network #(
    parameter INPUT_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter BIAS_WIDTH = 16,
    parameter ACTIVATION_WIDTH = 16,
    parameter FRAC_WIDTH = 10,
    // Set total width to nearest standard AXI width that can accommodate our data
    parameter AXIS_TDATA_WIDTH = 256  // Standardized AXI Stream width
)(
    // Clock and reset
    input wire aclk,
    input wire aresetn,
    
    // Control
    input wire en,
    
    // AXI Stream slave interface
    output wire s_axis_tready,
    input wire [AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input wire [(AXIS_TDATA_WIDTH/8)-1:0] s_axis_tkeep,
    input wire s_axis_tvalid,
    input wire s_axis_tlast,
    
    // AXI Stream master interface
    input wire m_axis_tready,
    output wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
    output wire [(AXIS_TDATA_WIDTH/8)-1:0] m_axis_tkeep,
    output wire m_axis_tvalid,
    output wire m_axis_tlast,
    
    // Random seed input
    input wire [7:0] random_seed
);

    // Internal signals
    wire signed [INPUT_WIDTH-1:0] x1, x2, x3, x4, x5, x6, x7, x8, x9;
    wire signed [ACTIVATION_WIDTH-1:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;
    
    // AXI-Stream control logic
    reg valid_reg;
    reg last_reg;
    
    // Input data unpacking - ensure proper alignment
    assign x1 = s_axis_tdata[INPUT_WIDTH*1-1:INPUT_WIDTH*0];
    assign x2 = s_axis_tdata[INPUT_WIDTH*2-1:INPUT_WIDTH*1];
    assign x3 = s_axis_tdata[INPUT_WIDTH*3-1:INPUT_WIDTH*2];
    assign x4 = s_axis_tdata[INPUT_WIDTH*4-1:INPUT_WIDTH*3];
    assign x5 = s_axis_tdata[INPUT_WIDTH*5-1:INPUT_WIDTH*4];
    assign x6 = s_axis_tdata[INPUT_WIDTH*6-1:INPUT_WIDTH*5];
    assign x7 = s_axis_tdata[INPUT_WIDTH*7-1:INPUT_WIDTH*6];
    assign x8 = s_axis_tdata[INPUT_WIDTH*8-1:INPUT_WIDTH*7];
    assign x9 = s_axis_tdata[INPUT_WIDTH*9-1:INPUT_WIDTH*8];
    
    // Output data packing - zero pad the unused bits
    assign m_axis_tdata = {
        {(AXIS_TDATA_WIDTH - ACTIVATION_WIDTH*9){1'b0}}, // Zero padding
        out9, out8, out7, out6, out5, out4, out3, out2, out1
    };
    
    // TKEEP signal - mark which bytes are valid
    localparam VALID_BYTES = (ACTIVATION_WIDTH * 9) / 8;
    assign m_axis_tkeep = {(AXIS_TDATA_WIDTH/8){1'b0}} | ({(VALID_BYTES){1'b1}});
    
    // AXI Stream control signals
    assign s_axis_tready = en && m_axis_tready;
    assign m_axis_tvalid = valid_reg && en;
    assign m_axis_tlast = last_reg;
    
    // Valid and last signal registration
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            valid_reg <= 1'b0;
            last_reg <= 1'b0;
        end
        else begin
            if (s_axis_tready && s_axis_tvalid) begin
                valid_reg <= 1'b1;
                last_reg <= s_axis_tlast;
            end
            else if (m_axis_tready) begin
                valid_reg <= 1'b0;
                last_reg <= 1'b0;
            end
        end
    end
    
    // Neural network instance
    neural_network #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .BIAS_WIDTH(BIAS_WIDTH),
        .ACTIVATION_WIDTH(ACTIVATION_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) nn_inst (
        .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5),
        .x6(x6), .x7(x7), .x8(x8), .x9(x9),
        .random_seed(random_seed),
        .out1(out1), .out2(out2), .out3(out3),
        .out4(out4), .out5(out5), .out6(out6),
        .out7(out7), .out8(out8), .out9(out9)
    );

endmodule