`timescale 1ns / 1ps

`include "PageTable.v"

module TLB (
    input [7:0] virtualAddr,
    output reg [7:0] physicalAddr
);

    parameter Size = 16;

    reg isLock;
    wire [7:0] addressFromPageTable;
    
    PageTable PageTableAsset (
        isLock,
        virtualAddr,
        addressFromPageTable
    );

    reg TLBhit;
    reg [3:0] LRU [15:0];
    reg [16:0] TLBTable [15:0];

    integer i;
    initial begin
        isLock = 1;
        for (i=0; i<Size; i=i+1) begin
            TLBTable[i] = 0;
            LRU[i] = 15 - i;
        end
    end

    always @(virtualAddr) begin
        TLBhit = 0;
        $display("TLB Data");
        for (i=0; i<Size; i=i+1) begin
            $display("TLB[%H]: 0x%H", i, TLBTable[i]);
            if (TLBTable[i][16] == 1'b1 && TLBTable[i][15:8] == virtualAddr) begin
                physicalAddr = TLBTable[i][7:0];
                TLBhit = 1;
            end
        end
        if (TLBhit == 0) begin
            isLock = 0;
            #1;
            isLock = 1;
            physicalAddr = addressFromPageTable;
            for (i=0; i<Size; i=i+1) begin
                if (LRU[i] == 15) begin
                    LRU[i] = 0;
                    TLBTable[i][16] = 1'b1;
                    TLBTable[i][15:8] = virtualAddr;
                    TLBTable[i][7:0] = addressFromPageTable;
                end else begin
                    LRU[i] = LRU[i] + 1;
                end
            end
        end else begin
            for (i = 0; i<Size; i=i+1) begin
                if (TLBTable[i][15:8] == virtualAddr) begin
                    LRU[i] = 0;
                end else begin
                    LRU[i] = LRU[i] + 1;
                end
            end
        end
        $display("Virtual address: 0x%H", virtualAddr);
    end

endmodule
