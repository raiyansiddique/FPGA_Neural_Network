`timescale 1ns/1ps
`default_nettype none

module bram #(
    parameter A_WID = 15,
    parameter SYS_ARRAY_WIDTH = 15
    ) (clk_i, en, we, reset_i, addr, di, dout);
input wire clk_i;
input wire en;
input wire we;
input wire reset_i;
input wire [2**A_WID-1:0] addr; 
input wire [SYS_ARRAY_WIDTH-1:0][15:0] di;
output logic [SYS_ARRAY_WIDTH-1:0][15:0] dout;
logic [15:0] ram [SYS_ARRAY_WIDTH-1:0][2**A_WID-1:0];
initial begin
    $readmemb("./mem/sigmoid.mem", ram);
end
always @(posedge clk_i)
    begin
        if (en) 
        begin
            if (we) 
                ram[addr] <= di;
            if (reset_i) 
                dout <= 0;
            else
                dout <= ram[addr];
        end
    end
endmodule