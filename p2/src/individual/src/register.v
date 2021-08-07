`timescale 1ns / 1ps

module register(
  input clk,
  input RegWrite,
  input Branch,
  input Jump,
  input [31:0] pc,
  input [31:0] instru,
  input [63:0] WriteData,
  output [63:0] ReadData1,
  output [63:0] ReadData2
);

  reg [63:0] RegData [31:0]; // register data
  
  // initialize the regester data
  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      RegData[i] = 64'b0;
    end
  end

  assign ReadData1 = RegData[instru[19:15]];
  assign ReadData2 = RegData[instru[24:20]];

  always @(posedge clk) begin
    if (RegWrite == 1 & instru[11:7] != 5'b0) begin
      if (Branch == 1 & Jump == 1) begin
        RegData[instru[11:7]] = {32'b0, pc + 4};
      end else begin
        RegData[instru[11:7]] = WriteData;       
      end
    end
  end

endmodule
