`timescale 1ns / 1ps

module data_memory(
  input clk,
  input MemWrite,
  input MemRead,
  input MemtoReg,
  input [63:0] addr,
  input [63:0] ALUresult,
  input [63:0] writeData,
  output reg [63:0] readData
);

  parameter NONE = 64'b0;
  parameter SIZE = 128;
  reg [63:0] mem [SIZE - 1:0];

  // initially set default data to 0
  integer i;
  initial begin
    for (i = 0; i < SIZE; i = i + 1) begin
      mem[i] = NONE;
    end
  end

  // Write back Data Memory or ALU result
  always @(addr, MemRead, MemtoReg, ALUresult) begin
    if (MemRead == 1) begin
      if (MemtoReg == 1) begin
        readData = mem[addr];
      end else begin
        readData = ALUresult;
      end
    end else begin
      readData = ALUresult;
    end
  end

  // Write memory
  always @(posedge clk) begin
    if (MemWrite == 1) begin
      mem[addr] = writeData;
    end
  end

endmodule
