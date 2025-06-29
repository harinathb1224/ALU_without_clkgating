`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2025 12:44:27
// Design Name: 
// Module Name: ALU_System_tb
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

`timescale 1ns/1ps

module ALU_System_tb();

    // Test signals
    reg [3:0] A, B;
    reg [2:0] opcode;
    reg clk, reset_n;
    wire [3:0] d_out;
    wire carry_out;

    // Instantiate ALU with fast clock divider
    ALU_System dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .clk(clk),
        .reset_n(reset_n),
        .d_out(d_out),
        .carry_out(carry_out)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    // Reset and test sequence
    initial begin
        // Initialize and reset
        A = 0; B = 0; opcode = 0;
        reset_n = 0;  // Assert reset
        #20 reset_n = 1;  // Release reset

        // Test ADD (opcode=000)
        opcode = 3'b000;
        A = 4'b0011; B = 4'b0101;  #50;  // 3 + 5 = 8 (1000)
        A = 4'b1111; B = 4'b0001;  #50;  // 15 + 1 = 0 (carry=1)

        // Test SUB (opcode=001)
        opcode = 3'b001;
        A = 4'b1000; B = 4'b0011;  #50;  // 8 - 3 = 5 (0101)

        // Test SHL (opcode=110)
        opcode = 3'b110;
        A = 4'b0001;  #50;  // 1 << 1 = 2 (0010)

        // Terminate
        #100 $finish;
    end

    // Waveform dumping (for debugging)
    initial begin
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, ALU_System_tb);
    end

endmodule

