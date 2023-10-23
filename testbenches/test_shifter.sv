`timescale 1ns/1ps
`default_nettype none

module shifter_tb;

    parameter CLK_PERIOD_NS = 5;
    parameter N = 16;
    parameter LEN = 3;

    logic clk;
    logic rst;
    logic valid;
    logic ena;
    logic [LEN-1:0][N-1:0] a;
    wire [N-1:0] out;

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    shifter #(
        .N(N),
        .LEN(LEN)
    ) UUT(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .valid(valid),
        .a(a),
        .out(out)
    );

    initial begin
        $dumpfile("shifter.fst");
        $dumpvars(0, UUT);
        valid = 0;
        clk = 0;
        rst = 1'b1;
        ena = 1'b0;
        a = 0;
        
        repeat(10) @(negedge clk);
        
        rst = 1'b0;
        ena = 1'b1;
        valid = 1;
        a[0] = 16'hAAAA;
        a[1] = 16'hBBBB;
        a[2] = 16'hCCCC;
        
        repeat(1) @(negedge clk);
        valid = 0;
        repeat(10) @(negedge clk);
        $finish;
    end
endmodule
