`timescale 1ns / 1ps
module instruction_assembler(
input clk,
input reset,
input [6:0]opcode,
input [6:0] func7,
input [2:0] func3,
input [4:0]rs1,
input [4:0]rs2,
input [4:0]rd,
input [31:0]imm,
input [2:0]format_tag,
input line_ready_d1,
output reg [31:0]instruction_assemblied,
output reg instr_valid
    );
    always @(posedge clk)begin
    if(reset)begin
    instruction_assemblied <=0;
          instr_valid <= 0;
    end
    else if(line_ready_d1)begin
     instr_valid <= line_ready_d1;
    case(format_tag)
    3'b000: instruction_assemblied <= {func7,rs2,rs1,func3,rd,opcode};
    3'b001: instruction_assemblied <= {imm[11:0],rs1,func3,rd,opcode};
    3'b010: instruction_assemblied <= {imm[11:0],rs1,func3,rd,opcode};
    3'b011: instruction_assemblied <= {imm[31:12],rd,opcode};
    3'b100: instruction_assemblied <= {imm[12],imm[10:5],rs2,rs1,func3,imm[4:1],imm[11],opcode};
    3'b101: instruction_assemblied <= {imm[11:5],rs2,rs1,func3,imm[4:0],opcode};
    default: instruction_assemblied <= 32'h00000013; 
    endcase
    end
    end
endmodule
