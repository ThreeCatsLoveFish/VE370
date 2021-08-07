`timescale 1ns / 1ps

`include "alu_control.v"
`include "alu.v"
`include "control.v"
`include "data_memory.v"
`include "immediate_generator.v"
`include "instru_memory.v"
`include "next_pc.v"
`include "program_counter.v"
`include "register.v"

module main(input clk);

  wire [31:0] pc_in, pc_out;

  wire [6:0] im_funct7;
  wire [2:0] im_funct3;
  wire [6:0] im_opcode;
  wire [31:0] im_instru;

  wire [63:0] r_wbdata,
              r_read1,
              r_read2;

  wire c_Branch,
       c_MemRead,
       c_MemtoReg,
       c_MemWrite,
       c_ALUSrc,
       c_RegWrite,
       c_Jump;

  wire [1:0] c_ALUOp;

  wire [3:0] c_ALUcontrol;

  wire c_zero;

  wire [63:0] alu_result;

  wire [63:0] imme;

program_counter asset_pc(clk, pc_in, pc_out);

instru_memory asset_im(pc_out, im_funct7, im_funct3, im_opcode, im_instru);

register asset_reg(clk, c_RegWrite, c_Branch, c_Jump, pc_out, im_instru, r_wbdata, r_read1, r_read2);

alu_control asset_aluct(c_ALUOp, im_funct7, im_funct3, c_ALUcontrol);

alu asset_alu(c_ALUSrc, c_ALUcontrol, r_read1, r_read2, imme, c_zero, alu_result);

control asset_control(im_opcode, c_Branch, c_MemRead, c_MemtoReg, c_ALUOp, c_MemWrite, c_ALUSrc, c_RegWrite, c_Jump);

data_memory asset_dm(clk, c_MemWrite, c_MemRead, c_MemtoReg, alu_result, alu_result, r_read2, r_wbdata);

next_pc asset_next_pc(c_Jump, c_Branch, c_zero, pc_out, alu_result, imme, pc_in);

immediate_generator asset_ig(im_instru, im_opcode, imme);

endmodule
