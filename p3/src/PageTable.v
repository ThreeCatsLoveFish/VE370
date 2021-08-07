`timescale 1ns / 1ps

module PageTable (
    input isLock,
    input [7:0] tag,
    output reg [7:0] physicalPage
);

    parameter size = 64;
    reg [7:0] pageTable [size - 1:0];

    integer i;
    initial begin
        for (i = 0; i < size; i = i+1) begin
            pageTable[i] = i * i;
        end
        // TODO: Add page table here
        pageTable[0] = 8'b00000000;
        pageTable[1] = 8'b00000001;
        pageTable[2] = 8'b10000000;
        pageTable[3] = 8'b10000001;
        pageTable[4] = 8'b11000000;
    end

    always @(negedge isLock) begin
        physicalPage = pageTable[tag];
    end

endmodule
