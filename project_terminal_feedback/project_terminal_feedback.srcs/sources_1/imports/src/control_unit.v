module control_unit(instruction,RegWrite, ALUSrc, MemWrite, MemRead,MemToReg, Branch, Jump, ALUOp);
input [31:0]instruction;
output reg RegWrite, ALUSrc, MemWrite, MemRead;
output reg MemToReg, Branch, Jump;
output reg [1:0] ALUOp;
always @ (*) begin
    RegWrite = 0;
    ALUSrc   = 0;
    MemWrite = 0;
    MemRead  = 0;
    MemToReg = 0;
    Branch   = 0;
    Jump     = 0;
    ALUOp    = 2'b00;
case(instruction[6:0])
7'b0000011:begin MemToReg = 1; MemRead = 1; RegWrite = 1; ALUSrc = 1; ALUOp =2'b00; end//lw
7'b0100011:begin MemWrite =1; ALUSrc = 1; ALUOp =2'b00; end //sw
7'b0110011:begin RegWrite =1; ALUOp =2'b10;end//add
7'b0010011:begin RegWrite = 1; ALUSrc = 1; ALUOp =2'b00; end//addi
7'b1100011:begin ALUOp =2'b01; Branch = 1;end//branch
7'b1101111:begin RegWrite=1; Jump =1;end//jal
7'b0110111:begin RegWrite =1; ALUSrc = 1;ALUOp =2'b11; end //lui


default : begin RegWrite = 0; ALUSrc = 0; MemWrite = 0;
    MemRead  = 0; MemToReg = 0; Branch = 0;
    Jump = 0; ALUOp = 2'b00; 
end


endcase
end
endmodule