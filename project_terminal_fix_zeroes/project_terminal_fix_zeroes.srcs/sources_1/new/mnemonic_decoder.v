`timescale 1ns / 1ps
module mnemonic_decoder(
    input clk,
    input line_ready,
    input reset,
    input [31:0] mnemonic,
    input [4:0]rs1_in,
    input [4:0]rs2_in,
    input [4:0] rd_in,
    input [31:0] imm_in,
    output [2:0]format_tag,
    output reg [6:0]opcode,
    output reg[6:0]func7,
    output reg [2:0]func3,
    output reg [31:0]imm,
    output reg [4:0]rs1,
    output reg [4:0]rs2,
    output reg [4:0]rd,
    output reg line_ready_d1,
    output reg [31:0] mnemonic_d1,
    output reg [2:0]format_tag_d1,
    output reg line_ready_d2,
    output reg [2:0] format_tag_d2
    );
  

always @(posedge clk) begin
    if (reset) begin
        line_ready_d1 <= 0;
        mnemonic_d1   <= 0;
        format_tag_d1 <=0;
        line_ready_d2 <=0;
        format_tag_d2 <=0;
    end else begin
        line_ready_d1 <= line_ready;
        mnemonic_d1   <= mnemonic;
        format_tag_d1 <= format_tag;
        line_ready_d2 <= line_ready_d1;
        format_tag_d2 <=format_tag_d1;
    end
end
    always @(posedge clk)begin
    if(reset)begin
    opcode <=0;
    func7 <=0;
    func3 <=0;
    imm <=0;
    rs1 <= 0;
    rs2 <= 0;
    rd <= 0;
    end
    else if(line_ready_d1) begin
    case(mnemonic_d1)
    //R-type
    "ADD ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b000; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "SUB ": begin func7 <=7'b0100000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b000; rd <= rd_in; opcode <= 7'b0110011;     imm <= 0;  end
    "XOR ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b100; rd <= rd_in; opcode <= 7'b0110011;   imm <= 0;  end
    "OR  ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b110; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "AND ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b111; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "SLT ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b010; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "SLL ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b001; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "SRL ": begin func7 <=7'b000000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b101; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    "SRA ": begin func7 <=7'b010000; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b101; rd <= rd_in; opcode <= 7'b0110011;    imm <= 0;  end
    //I-type
    "ADDI": begin imm <= imm_in; rs1 <= rs1_in; func3 <= 3'b000; rd <= rd_in; opcode <= 7'b0010011;   rs2 <= 0; func7 <=0; end
    
    "LW  ": begin imm <= imm_in; rs1 <= rs1_in; func3 <= 3'b010; rd <= rd_in; opcode <= 7'b0000011;   rs2 <= 0; func7 <=0; end
    //U-type
    "LUI ": begin imm <= imm_in; rd <= rd_in; opcode <= 7'b0110111; rs1 <=0; rs2 <=0; func7 <=0; func3 <=0; end 
    //B-type
    "BEQ ":begin imm <= imm_in; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b000; opcode <= 7'b1100011;   rd<=0; func7<=0; end
    "BNE ":begin imm <= imm_in; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b001; opcode <= 7'b1100011;   rd<=0; func7<=0; end
    //S-type
    "SW  ":begin  imm <= imm_in; rs1 <= rs1_in; rs2 <= rs2_in; func3 <= 3'b010; opcode <= 7'b0100011;    rd<=0; func7<=0; end
    //J-type
    "JAL ": begin imm <= imm_in; rs1 <= 0; rs2 <= 0; rd <= 0; func3 <= 0; func7 <= 0; rd <= rd_in; opcode <= 7'b1101111; end
    
    default: begin  func7 <=7'b000000; rs1 <= 0; rs2 <= 0; func3 <= 3'b000; rd <= rd_in; opcode <= 7'b0000000;  imm <= 0; end
     endcase 
     end
    end
    assign format_tag = (mnemonic == "ADD ")? 3'b000:
                        (mnemonic == "SUB ")? 3'b000:
                        (mnemonic == "XOR ")? 3'b000:
                        (mnemonic =="OR  ")? 3'b000:
                        (mnemonic =="SLT ")? 3'b000:
                        (mnemonic =="SLL ")? 3'b000:
                        (mnemonic =="SRL ")? 3'b000:
                        (mnemonic =="SRA ")? 3'b000:
                        (mnemonic == "AND ")? 3'b000:
                        (mnemonic == "ADDI")? 3'b001:
                        (mnemonic == "LW  ")? 3'b010:
                        (mnemonic == "LUI ")? 3'b011:
                        (mnemonic == "BEQ ")? 3'b100:
                        (mnemonic == "BNE ")? 3'b100:
                        (mnemonic == "SW  ")? 3'b101: 
                        (mnemonic == "JAL ")? 3'b110: 
                        3'b111;
endmodule
