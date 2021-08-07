`timescale 1ns / 1ps

module next_pc(
  input Jump,
  input Branch,
  input Zero,
  input [31:0] old,
  input [63:0] alu_result,
  input [63:0] immediate,
  output reg [31:0] next
);

  reg [31:0] new;
  reg [63:0] origin;
  reg [63:0] jump;

  initial begin
    next = 32'b0;
    origin = 64'b0;
  end

  always @(old) begin
    new = old + 4;
    origin = {32'b0, old[31:0]};
  end

  always @(immediate, origin) begin
    jump = origin + immediate;
  end

  always @(new,Branch,Zero,Jump,jump,alu_result) begin
    // assign next program counter value
    if (Branch == 1 & (Zero == 1 | Jump == 1)) begin
      next = jump[31:0];
    end else begin
      next = new;
    end
    if (Jump == 1 & Branch == 0) begin
      next = alu_result[31:0];
    end
    
    // $display("origin = 0x%H", origin);
    // $display("jump = 0x%H", jump);
    // $display("next = 0x%H", next);
  end

endmodule
