`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2025 10:54:53
// Design Name: 
// Module Name: ALU_System
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU_System (
    input [3:0] A,          // 4-bit input A (now guaranteed to update)
    input [3:0] B,          // 4-bit input B
    input [2:0] opcode,     // Operation selector
    input clk,              // Global clock
    input reset_n,          // Active-low reset
    output reg [3:0] d_out, // Output register
    output carry_out        // Carry-out flag
);

    // Clock Divider (Reduced for simulation)
    parameter DIV_FACTOR = 5;  // Small value for quick simulation
    reg [31:0] counter;
    reg clk_divided;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_divided <= 0;
        end else begin
            if (counter == DIV_FACTOR - 1) begin
                clk_divided <= ~clk_divided;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // ALU Core Logic (Fixed to ensure A is processed)
    reg [4:0] alu_result;  // 5-bit to include carry

    always @(*) begin
        case (opcode)
            3'b000: alu_result = A + B;        // ADD
            3'b001: alu_result = A - B;        // SUB
            3'b010: alu_result = {1'b0, A & B}; // AND
            3'b011: alu_result = {1'b0, A | B}; // OR
            3'b100: alu_result = {1'b0, A ^ B}; // XOR
            3'b101: alu_result = {1'b0, ~A};    // NOT
            3'b110: alu_result = A << 1;        // SHL (MSB->carry)
            3'b111: alu_result = {1'b0, A[3], A[2:0]}; // SHR (LSB->carry)
            default: alu_result = 5'b0;         // Default
        endcase
    end

    assign carry_out = alu_result[4];  // Carry/borrow flag

    // Output register (synchronized to divided clock)
    always @(posedge clk_divided or negedge reset_n) begin
        if (!reset_n) begin
            d_out <= 0;
        end else begin
            d_out <= alu_result[3:0];  // Update only on clk_divided
        end
    end

    // Debugging: Monitor A and ALU operations
    initial begin
        $monitor("Time=%t: A=%b B=%b op=%b | alu_result=%b d_out=%b", 
                 $time, A, B, opcode, alu_result, d_out);
    end

endmodule