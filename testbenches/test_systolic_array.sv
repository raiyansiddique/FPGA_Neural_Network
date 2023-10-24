`timescale 1ns/1ps
`default_nettype none

module systolic_array_tb;

    parameter CLK_PERIOD_NS = 5;
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
    wire [AROW-1:0][BCOL-1:0][2*N-1:0] sys_array;
    always #(CLK_PERIOD_NS/2) clk = ~clk;

    systolic_array #(.N(N),
    .AROW(AROW),
    .ACOL(ACOL),
    .BROW(BROW),
    .BCOL(BCOL))
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

        // Initialize 4x4 matrix 'a'
        a[0][0] = 16'd1; a[0][1] = 16'd2; a[0][2] = 16'd3; a[0][3] = 16'd4;
        a[1][0] = 16'd5; a[1][1] = 16'd6; a[1][2] = 16'd7; a[1][3] = 16'd8;
        a[2][0] = 16'd9; a[2][1] = 16'd10; a[2][2] = 16'd11; a[2][3] = 16'd12;
        a[3][0] = 16'd13; a[3][1] = 16'd14; a[3][2] = 16'd15; a[3][3] = 16'd16;

        // Initialize 4x4 matrix 'b'
        b[0][0] = 16'd17; b[0][1] = 16'd18; b[0][2] = 16'd19; b[0][3] = 16'd20;
        b[1][0] = 16'd21; b[1][1] = 16'd22; b[1][2] = 16'd23; b[1][3] = 16'd24;
        b[2][0] = 16'd25; b[2][1] = 16'd26; b[2][2] = 16'd27; b[2][3] = 16'd28;
        b[3][0] = 16'd29; b[3][1] = 16'd30; b[3][2] = 16'd31; b[3][3] = 16'd32;
        
        repeat(1) @(negedge clk);
        valid = 0;
        repeat(20) @(negedge clk);
        $finish;
    end
endmodule
