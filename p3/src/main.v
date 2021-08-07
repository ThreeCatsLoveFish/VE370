// data bus for cache 2b

`timescale 1ns / 1ps

`include "TLB.v"
`include "cache.v"
`include "memory.v"

module main (
  input isRead,
  input [9:0] address,
  input [63:0] writeData,
  output [63:0] readData,
  output isHit
);

  wire isMemRead;
  wire isLock;
  wire [127:0] memWriteData;
  wire [127:0] memReadData;
  wire [7:0] TLBAddr;
  wire [9:0] physicalAddr;
  wire [9:0] memAddress;

  assign physicalAddr = {TLBAddr, address[1:0]};

  TLB TLBAsset(
    address[9:2],
    TLBAddr
  );

  cache cache(
    .isRead (isRead),
    .address (physicalAddr),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit),
    .isMemRead (isMemRead),
    .memWriteData (memWriteData),
    .isLock (isLock),
    .memAddress (memAddress),
    .memReadData (memReadData)
  );

  memory mem(
    .isMemRead (isMemRead),
    .isLock (isLock),
    .address (memAddress),
    .writeData (memWriteData),
    .readData (memReadData)
  );

endmodule
