`timescale 1ns/1ps
`default_nettype none

module systolic_array
    #(
        parameter N = 16,
        parameter AROW = 3,
        parameter ACOL = 3,
        parameter BROW = 3,
        parameter BCOL = 3
    )
    (
        input wire clk,
        input wire rst,
        input wire valid,
        input wire [AROW-1:0][ACOL-1:0][N-1:0] a,
        input wire [BROW-1:0][BCOL-1:0][N-1:0] b,
        output logic [AROW-1:0][BCOL-1:0][2*N-1:0] sys_array
    );
    logic [AROW:0][BCOL:0][N-1:0] a_con;
    logic [AROW:0][BCOL:0][N-1:0] b_con;
    logic [AROW-1:0][N-1:0] a_shift;
    logic [BCOL-1:0][N-1:0] b_shift;
    logic [AROW:0] a_ena;
    logic [BCOL:0] b_ena;

    assign a_ena[0] = 1;
    assign b_ena[0] = 1;
    generate
        for (genvar row = 0; row < AROW; row++) begin
            assign a_con[row][0] = a_shift[row];
        end
        for (genvar col = 0; col < BCOL; col++) begin
            assign b_con[0][col] = b_shift[col];
        end
    endgenerate

    generate
        for (genvar row = 0; row<AROW; row++) begin
            shifter
            #(
               .N(N),
               .LEN(AROW)
            ) SHIFTER_A
            (
                .clk(clk),
                .rst(rst),
                .ena(a_ena[row]),
                .valid(valid),
                .a(a[row]),
                .out(a_shift[row]),
                .ena_next(a_ena[row+1])
            );
        end
    endgenerate

    generate
        for (genvar col = 0; col<BCOL; col++) begin
            wire [BROW][N-1:0]b_col;
            for (genvar row = 0; row<BROW; row++) begin
               assign b_col[row] = b[row][col];
            end

            shifter
            #(
               .N(N),
               .LEN(BCOL)
            ) SHIFTER_B
            (
                .clk(clk),
                .rst(rst),
                .ena(b_ena[col]),
                .valid(valid),
                .a(b_col),
                .out(b_shift[col]),
                .ena_next(b_ena[col+1])
            );
        end
    endgenerate

    generate
    genvar row, col;
    for (genvar row = 0; row < AROW; row++) begin
        for (genvar col = 0; col < BCOL; col++) begin : BLOCKS
            
            block
            #(
                .N(N)
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
