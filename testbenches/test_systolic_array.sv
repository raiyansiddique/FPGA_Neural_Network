`timescale 1ns/1ps
`default_nettype none

module systolic_array_tb;

    parameter CLK_PERIOD_NS = 5;
    parameter FIXED_POINT_POSITION = 4;
    parameter N = 16;
    parameter AROW = 4;  // Changed from 3 to 4
    parameter ACOL = 4;  // Changed from 3 to 4
    parameter BROW = 4;  // Changed from 3 to 4
    parameter BCOL = 4;  // Changed from 3 to 4

    logic clk;
    logic rst;
    logic valid;
    logic [AROW-1:0][ACOL-1:0][N-1:0] a;
    logic [BROW-1:0][BCOL-1:0][N-1:0] b;
    wire [AROW-1:0][BCOL-1:0][N-1:0] sys_array;
    always #(CLK_PERIOD_NS/2) clk = ~clk;

    systolic_array #(.N(N),
    .AROW(AROW),
    .ACOL(ACOL),
    .BROW(BROW),
    .BCOL(BCOL),
    .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    )
    UUT(
        .*
    );

    initial begin
        $dumpfile("systolic_array.fst");
        $dumpvars(0, UUT);
        clk = 0;
        rst = 1'b1;
        valid = 0;
        a = 0;
        b = 0;
        repeat(1) @(negedge clk);

        rst = 1'b0;
        valid = 1;

        // Initialize 4x4 matrix 'a' with signed fixed-point numbers
        a[0][0] = 16'sd16;    // 1.0 in fixed-point
        a[0][1] = 16'sd32;    // 2.0 in fixed-point
        a[0][2] = 16'sd48;    // 3.0 in fixed-point
        a[0][3] = 16'sd64;    // 4.0 in fixed-point
        a[1][0] = 16'sd80;    // 5.0 in fixed-point
        a[1][1] = 16'sd96;    // 6.0 in fixed-point
        a[1][2] = 16'sd112;   // 7.0 in fixed-point
        a[1][3] = 16'sd128;   // 8.0 in fixed-point
        a[2][0] = 16'sd144;   // 9.0 in fixed-point
        a[2][1] = 16'sd160;   // 10.0 in fixed-point
        a[2][2] = 16'sd176;   // 11.0 in fixed-point
        a[2][3] = 16'sd192;   // 12.0 in fixed-point
        a[3][0] = 16'sd208;   // 13.0 in fixed-point
        a[3][1] = 16'sd224;   // 14.0 in fixed-point
        a[3][2] = 16'sd240;   // 15.0 in fixed-point
        a[3][3] = 16'sd256;   // 16.0 in fixed-point

        // Initialize 4x4 matrix 'b' with signed fixed-point numbers
        b[0][0] = 16'sd272;   // 17.0 in fixed-point
        b[0][1] = 16'sd288;   // 18.0 in fixed-point
        b[0][2] = 16'sd304;   // 19.0 in fixed-point
        b[0][3] = 16'sd320;   // 20.0 in fixed-point
        b[1][0] = 16'sd336;   // 21.0 in fixed-point
        b[1][1] = 16'sd352;   // 22.0 in fixed-point
        b[1][2] = 16'sd368;   // 23.0 in fixed-point
        b[1][3] = 16'sd384;   // 24.0 in fixed-point
        b[2][0] = 16'sd400;   // 25.0 in fixed-point
        b[2][1] = 16'sd416;   // 26.0 in fixed-point
        b[2][2] = 16'sd432;   // 27.0 in fixed-point
        b[2][3] = 16'sd448;   // 28.0 in fixed-point
        b[3][0] = 16'sd464;   // 29.0 in fixed-point
        b[3][1] = 16'sd480;   // 30.0 in fixed-point
        b[3][2] = 16'sd496;   // 31.0 in fixed-point
        b[3][3] = 16'sd512;   // 32.0 in fixed-point


        
        repeat(1) @(negedge clk);
        valid = 0;
        repeat(20) @(negedge clk);
        $finish;
    end
endmodule
