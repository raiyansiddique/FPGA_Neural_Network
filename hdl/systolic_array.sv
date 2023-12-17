`timescale 1ns/1ps
`default_nettype none

module systolic_array
    #(
        parameter N = 16,
        parameter AROW = 3,
        parameter ACOL = 3,
        parameter BROW = 3,
        parameter BCOL = 3,
        parameter FIXED_POINT_POSITION = 10
    )
    (
        input wire clk,
        input wire rst,
        input wire valid,
        input wire [AROW-1:0][N-1:0] a_shift,
        input wire [BCOL-1:0][N-1:0] b_shift,
        output logic [AROW-1:0][BCOL-1:0][N-1:0] sys_array
    );
    logic [AROW:0][BCOL:0][N-1:0] a_con;
    logic [AROW:0][BCOL:0][N-1:0] b_con;

    generate
        for (genvar row = 0; row < AROW; row++) begin
            assign a_con[row][0] = a_shift[row];
        end
        for (genvar col = 0; col < BCOL; col++) begin
            assign b_con[0][col] = b_shift[col];
        end
    endgenerate

    generate
    genvar row, col;
    for (genvar row = 0; row < AROW; row++) begin
        for (genvar col = 0; col < BCOL; col++) begin : BLOCKS
            
            block
            #(
                .N(N),
                .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
            ) BLOCK
            (
                .clk(clk),
                .rst(rst),
                .a(a_con[row][col]),
                .b(b_con[row][col]),
                .a_out(a_con[row][col+1]),
                .b_out(b_con[row+1][col]),
                .c_out(sys_array[row][col])
            ); 
        end
    end
    endgenerate


endmodule
