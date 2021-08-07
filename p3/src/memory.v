// Main Memory

`timescale 1ns / 1ps

module memory (
  input isMemRead,
  input isLock,
  input [9:0] address, // byte address
  input [127:0] writeData,
  output reg [127:0] readData
);

  reg [63:0] mem [1023:0];

  integer i;
  initial begin
    for (i=0; i<1024; i=i+1) begin
      mem[i] = 0;
    end
    // TODO: Add initial data here
    mem[8'b00000000] = 64'b00000000000000000011110011000011; // 0x3cc3
    mem[8'b00000001] = 64'b00000000000000000000000000000011; // 0x3
    mem[8'b10000000] = 64'b00000000000000000000110011001100; // 0xccc
    mem[8'b10000001] = 64'b00000100000000000000110011001100; // 0xccc
    mem[8'b11000000] = 64'b00000000000000000000000011000011; // 0xc3
    mem[8'b11000001] = 64'b00000100000000000000000011000011; // 0xc3
  end

  always @(*) begin
    if (isLock == 0) begin
      if (isMemRead == 1) begin // read
        readData = {mem[{address[9:3],1'b0}], mem[{address[9:3],1'b1}]};
      end else begin // write
        mem[{address[9:3],1'b0}] = writeData[127:64];
        mem[{address[9:3],1'b1}] = writeData[63:0];
      end
    end
  end

endmodule
