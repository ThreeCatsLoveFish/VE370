`timescale 1ns / 1ps

module instru_memory(
  input [31:0] addr,
  output reg [6:0]  funct7, // [31-25]
  output reg [2:0]  funct3, // [14-12]
  output reg [6:0]  opcode, // [6-0]
  output reg [31:0] instru  // [31-0]
);

  parameter NOP = 32'b00000000000000000000000000010011;
  parameter SIZE = 128;
  reg [31:0] mem [SIZE - 1:0];

  // initially set instruction to nop
  integer n;
  initial begin
    for (n = 0; n < SIZE; n = n + 1) begin
      mem[n] = NOP;
    end
    $readmemb("D:/Study/SJTU/Junior/2021SU/VE370/Project/p2/individual/test/case.txt", mem);
    instru = NOP;
  end

  always @(addr) begin
    if (addr != -4) begin
      instru = mem[addr >> 2];
    end
    funct7 = instru[31:25];
    funct3 = instru[14:12];
    opcode = instru[6:0];

    // $display("instruction = 0x%H", instru);
    // $display("funct7 = 0x%H", funct7);
    // $display("funct3 = 0x%H", funct3);
    // $display("opcode = 0x%H", opcode);
  end

endmodule
