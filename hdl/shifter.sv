`timescale 1ns/1ps
`default_nettype none

module shifter
    #(
        parameter N = 16,
        parameter LEN = 3
    )
    (
        input wire clk,
        input wire rst,
        input wire ena,
        input wire valid,
        input wire [LEN-1:0][N-1:0] a,
        output logic [N-1:0] out,
        output logic ena_next
    );

    logic [LEN-1:0][N-1:0] a_reg;
    always_ff @(posedge clk, posedge rst) begin : SHIFTING
        if (rst) begin
            a_reg = 0; 
            out = 0;
            ena_next = 0;
        end
        else if (valid) begin
            a_reg = a;
        end
        else if (ena) begin
            out = a_reg[0];
            a_reg = {16'h0, a_reg[LEN-1:1]};
            ena_next = 1;
        end
    end
endmodule
