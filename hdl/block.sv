`timescale 1ns/1ps
`default_nettype none

module block
    #(
        parameter N = 16
    )
    (
        input wire clk,
        input wire rst,
        input wire [N-1:0] a,
        input wire [N-1:0] b,
        output logic [N-1:0] a_out,
        output logic [N-1:0] b_out,
        output logic [N*2 - 1:0] c_out
    );

    
    logic [N*2 - 1:0] product;
    
    always_comb begin : MULTIPLICATION
        product = a_out * b_out;
    end


    always_ff @(posedge clk, posedge rst) begin : REGISTER
        if(rst) begin
            a_out=0;
            b_out=0;
            c_out=0;
        end else begin
            a_out = a;
            b_out = b;
            c_out = c_out + product;
        end

    end
endmodule