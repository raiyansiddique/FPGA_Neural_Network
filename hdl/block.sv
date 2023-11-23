`timescale 1ns/1ps
`default_nettype none

module block
    #(
        parameter N = 16,
        parameter FIXED_POINT_POSITION = 10,
        parameter MAX_VALUE = 2**(N-1) - 1,
        parameter MIN_VALUE = -(2**(N-1))
    )
    (
        input wire clk,
        input wire rst,
        input wire [N-1:0] a,
        input wire [N-1:0] b,
        output logic [N-1:0] a_out,
        output logic [N-1:0] b_out,
        output logic [N-1:0] c_out
    );

    
    logic [N*2 - 1:0] product;
    logic [N-1:0] rectified_product;
    logic overflow, underflow, add_overflow, add_undeflow;
    logic [N:0]extended_sum;
    logic [N-1:0] final_sum;

    always_comb begin : MULTIPLICATION
        product = a_out * b_out;
    end
    always_comb begin : OVER_AND_UNDERFLOW_PRODUCT_DETECTION
        overflow = $signed(product[2*N-1: FIXED_POINT_POSITION]) > MAX_VALUE;
        underflow = $signed(product[2*N-1: FIXED_POINT_POSITION]) < MIN_VALUE;
    end


    always_comb begin : PRODUCT_RECTIFICATION
        if (overflow) begin
            rectified_product = MAX_VALUE;
        end else if (underflow) begin
            rectified_product = MIN_VALUE;
        end else begin
            rectified_product = product[2*N-(N-FIXED_POINT_POSITION) - 1 : FIXED_POINT_POSITION];
        end
    end

    always_comb begin : EXTENDED_ADD
        extended_sum = rectified_product + c_out;
    end

    always_comb begin : ADD_OVERFLOW
        if($signed(extended_sum) > MAX_VALUE) begin
            final_sum = MAX_VALUE;
        end else if ($signed(extended_sum) < MIN_VALUE) begin
            final_sum = MIN_VALUE;
        end else begin
            final_sum = extended_sum[N-1:0];
        end

    end
    always_ff @(posedge clk, posedge rst) begin : REGISTER
        if(rst) begin
            a_out=0;
            b_out=0;
            c_out=0;
        end else begin
            a_out = a;
            b_out = b;
            c_out = final_sum;
        end

    end
endmodule


// module fixed_point_adder
//     #(
//         parameter N = 16, // Total number of bits
//         parameter F = 4   // Number of fractional bits
//     )
//     (
//         input wire signed [N-1:0] a,
//         input wire signed [N-1:0] b,
//         output reg signed [N-1:0] sum,
//         output reg overflow,
//         output reg underflow
//     );

//     // Intermediate sum with one extra bit to detect overflow/underflow
//     wire signed [N:0] extended_sum = {a[N-1], a} + {b[N-1], b};

//     always @(*) begin
//         // Check for overflow and underflow
//         if (extended_sum > 2**(N-F-1)-1) begin
//             overflow = 1;
//             underflow = 0;
//             sum = 2**(N-F-1)-1; // Max representable value
//         end else if (extended_sum < -2**(N-F-1)) begin
//             overflow = 0;
//             underflow = 1;
//             sum = -2**(N-F-1); // Min representable value
//         end else begin
//             overflow = 0;
//             underflow = 0;
//             sum = extended_sum[N-1:0]; // Truncate to N bits
//         end
//     end
// endmodule
