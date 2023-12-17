    `timescale 1ns/1ps
`default_nettype none

module controller #(
    parameter WEIGHT_WID = 15,
    parameter INPUT_WID = 8,
    parameter SYS_ARRAY_WIDTH = 15,
    parameter N = 16,
    parameter AROW = 15,
    parameter ACOL = 15,
    parameter BROW = 15,
    parameter BCOL = 15,
    parameter FIXED_POINT_POSITION = 10,
    parameter OFFSET = 2
    )(
        input wire clk,
        input wire rst,
        input wire [2:0] control

    );
    
    logic [AROW:0] a_ena;
    logic [BCOL:0] b_ena;

    assign a_ena[0] = 1;
    assign b_ena[0] = 1;

    bram 
    #(
    .A_WID(WEIGHT_WID),
    .SYS_ARRAY_WIDTH(SYS_ARRAY_WIDTH)
    ) WEIGHT_RAM (.clk_i(clk), en, we, reset_i, .addr, .di(), .dout);

    bram 
    #(
    .A_WID(INPUT_WID),
    .SYS_ARRAY_WIDTH(1)
    ) INPUT_RAM (.clk_i(clk), en, we, reset_i, addr, di, dout);


    generate
        for (genvar row = 0; row<AROW; row++) begin
            shifter
            #(
               .N(N),
               .LEN(1)
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
               assign b_col[BROW - row - 1] = b[row][col];
            end

            shifter
            #(
               .N(N),
               .LEN(1)
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

    systolic_array #(.N(N),
    .AROW(AROW),
    .ACOL(ACOL),
    .BROW(BROW),
    .BCOL(BCOL),
    .FIXED_POINT_POSITION(FIXED_POINT_POSITION)
    )
    SYS_ARR(
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .a_shift(a_shift),
        .b_shift(b_shift),
        .sys_array(sys_array)
    );
    enum logic [4:0] {READ_WEIGHT, MEM_CTRL_RST, MEM_WRITE, MEM_WB,
                EXECUTE_R, EXECUTE_I, JAL, ALU_WB, BEQ, BNE, DECODE_WAIT,
                MEM_ADR_WAIT, MEM_READ_WAIT, ALU_WB_WAIT, MEM_WB_WAIT} mem_control;
    always_ff @(posedge clk) begin

        case (mem_control)
            MEM_CTRL_RST : begin

            end
            READ_WEIGHT : begin

            end

        endcase
    end
endmodule