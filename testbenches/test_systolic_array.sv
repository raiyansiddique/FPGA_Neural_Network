`timescale 1ns/1ps
`default_nettype none

module systolic_array_tb;

    parameter CLK_PERIOD_NS = 5;
    parameter N = 16;
    parameter AROW = 3;
    parameter ACOL = 3;
    parameter BROW = 3;
    parameter BCOL = 3;

    logic clk;
    logic rst;
    logic valid;
    logic [AROW-1:0][ACOL-1:0][N-1:0] a;
    logic [BROW-1:0][BCOL-1:0][N-1:0] b;
    wire [AROW-1:0][BCOL-1:0][2*N-1:0] sys_array;
    always #(CLK_PERIOD_NS/2) clk = ~clk;

    systolic_array #()
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
        a[0][0] = 16'd11;
        a[1][0] = 16'd11;
        a[2][0] = 16'd11;
        a[0][1] = 16'd11;
        a[1][1] = 16'd11;
        a[2][1] = 16'd11;
        a[0][2] = 16'd11;
        a[1][2] = 16'd11;
        a[2][2] = 16'd11;
        
        b[0][0] = 16'd12;
        b[1][0] = 16'd12;
        b[2][0] = 16'd12;
        b[0][1] = 16'd12;
        b[1][1] = 16'd12;
        b[2][1] = 16'd12;
        b[0][2] = 16'd12;
        b[1][2] = 16'd12;
        b[2][2] = 16'd12;
        repeat(1) @(negedge clk);
        valid = 0;
        repeat(10) @(negedge clk);
        $finish;
    end
endmodule