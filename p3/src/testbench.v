`timescale 1ns / 1ps

`include "main.v"

module testbench;

  reg isRead;
  reg [11:0] address;
  reg [63:0] writeData;
  wire [63:0] readData;
  wire isHit;

  integer currTime;

  main uut(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit)
  );

  initial begin
    /* Time 0: init*/
    currTime = 0; isRead = 1; address = 0; writeData = 0;
    /* Time 10: miss, readData=0x3cc3 */
    #10 isRead = 1; address = 10'b0000000000;
    /* Time 20: hit, writeData */
    #10 isRead = 0; address = 10'b0000000000; writeData = 64'b1000000001000000000000101110111111111;
    /* Time 30: hit, readData=0xff */
    #10 isRead = 1; address = 10'b0000000000;
    // Here in the main memory, the first word should be 0x3cc3 [write-back]
    
    /* Time 40: miss, readData=0xccc */
    #10 isRead = 1; address = 10'b0000000101;
    // Here in the main memory, the first word should be 0x3cc3 [2-way write-back]

    /* Time 50: hit, readData=0xff [2-way feature] */
    #10 isRead = 1; address = 10'b0000001100; 
    /* Time 60: miss, readData=0xc3 */
    #10 isRead = 1; address = 10'b0000001101;
    /* Time 70: miss, readData=0xccc */
    #10 isRead = 1; address = 10'b0000010000;
    /* Time 100: stop*/
    #30 $stop;

    // Here in the main memory, the first word should be 0x000000ff [write-back]
  end

  always #10 begin
    $display("--------------------------- Time: %d ---------------------------", currTime);
    $display("isRead: %d, address: 0x%H, isHit: %d", isRead, address, isHit);
    $display("writeData: 0x%H, readData: 0x%H", writeData, readData);
    $display("mem[0]: 0x%H, mem[0x200]: 0x%H, mem[0x300]: 0x%H",
      uut.mem.mem[0], uut.mem.mem[128], uut.mem.mem[192]);
    $display("mem[1]: 0x%H, mem[0x201]: 0x%H, mem[0x301]: 0x%H",
      uut.mem.mem[1], uut.mem.mem[129], uut.mem.mem[193]);
    currTime = currTime + 10;
  end

endmodule
