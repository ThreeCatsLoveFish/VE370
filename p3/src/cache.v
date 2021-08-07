// cache

`timescale 1ns / 1ps

module cache (
  // with cpu
  input isRead,
  input [9:0] address,
  input [63:0] writeData,
  output reg [63:0] readData,
  output reg isHit,
  // with main memory
  output reg isMemRead,
  output reg [127:0] memWriteData,
  output reg isLock,
  output reg [31:0] memAddress,
  input [127:0] memReadData
);

  reg [136:0] block [3:0];

  integer i;
  initial begin
    for (i=0; i<4; i=i+1) begin
      block[i] = 0;
    end
    isMemRead = 1;
    memWriteData = 0;
    isLock = 1;
  end

  reg [5:0] tag;
  reg index;
  reg [1:0] realIndex;
  reg wordOffset;

  always @(*) begin
    /* parse the address */
    tag = address[9:4];
    index = address[3];
    wordOffset = address[2];

    if (isRead == 1) begin // read
      /* check the cache block */
      isMemRead = 1;
      if (block[2*index][136]==1 && block[2*index][133:128]==tag) begin // hit
        realIndex = 2*index;
        isHit = 1;
        block[2*index][134] = 1; // recently accessed
        block[2*index+1][134] = 0;
      end else if (block[2*index+1][136]==1 && block[2*index+1][133:128]==tag) begin
        realIndex = 2*index+1;
        isHit = 1;
        block[2*index+1][134] = 1;
        block[2*index][134] = 0;
      end else begin // miss
        isHit = 0;
        /* locate the block with LRU algorithm */
        if(block[2*index][134]==0) begin
          realIndex=2*index;
          block[2*index][134]=1;
          block[2*index+1][134]=0;
        end else begin
          realIndex=2*index+1;
          block[2*index+1][134]=1;
          block[2*index][134]=0;
        end
        /* check whether the block is dirty */
        if (block[realIndex][135]==1) begin // dirty
          /* write back to main memory */
          isMemRead = 0;
          memAddress = {block[realIndex][134:128],index,wordOffset,2'b0}; // for consistency, we insert wordOffset (but not used)
          memWriteData = block[realIndex][127:0];
          isLock = 0;
          #1;
          isLock = 1;
        end
        /* call main memory */
        isMemRead = 1;
        memAddress = address;
        isLock = 0;
        #1; // wait for main memory to respond
        isLock = 1;
        /* update the block */
        block[realIndex][136] = 1;
        block[realIndex][135] = 0; // marked as not dirty
        block[realIndex][133:128] = tag;
        block[realIndex][127:0] = memReadData;
      end
      /* update the output */
      case(wordOffset)
        1'b0: readData = block[realIndex][127:64];
        1'b1: readData = block[realIndex][63:0];
      endcase
    end else begin // write
      isMemRead = 0;
      // readData = 0; // do not clear readData if the mode is switched to write
      if (block[2*index][136]==1 && block[2*index][133:128]==tag) begin // hit
        isHit = 1;
        realIndex = 2*index;
      end else if (block[2*index+1][136]==1 && block[2*index+1][133:128]==tag) begin // hit
        isHit = 1;
        realIndex = 2*index+1;
      end else begin // miss
        isHit = 0;
        /* locate the block with LRU algorithm */
        if(block[2*index][134]==0) begin
          realIndex=2*index;
        end else begin
          realIndex=2*index+1;
        end
        if (block[realIndex][135]==1) begin // dirty
          /* write back to main memory */
          isMemRead = 0;
          memAddress = {block[realIndex][133:128],index,wordOffset,2'b0};
          memWriteData = block[realIndex][127:0];
          isLock = 0;
          #1;
          isLock = 1;
        end
        /* read from main memory */
        isMemRead = 1;
        memAddress = address;
        isLock = 0;
        #1;
        isLock = 1;
        block[realIndex][136] = 1;
        block[realIndex][133:128] = tag;
        block[realIndex][127:0] = memReadData;
      end
      case(wordOffset)
        1'b0: block[realIndex][127:64] = writeData;
        1'b1: block[realIndex][63:0] = writeData;
      endcase
      block[realIndex][135] = 1; // marked as dirty        
    end
    $display("Physical address: 0x%H", address);
    $display("Block0: 0x%H", block[0]);
    $display("Block1: 0x%H", block[1]);
    $display("Block2: 0x%H", block[2]);
    $display("Block3: 0x%H", block[3]);
  end

endmodule
