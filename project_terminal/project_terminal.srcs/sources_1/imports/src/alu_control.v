module alu_control(instruction,ALUOp,ALUcontrol);
input [31:0]instruction;
input [1:0]ALUOp;
wire [2:0]func3;
output  reg [2:0]ALUcontrol;
wire funct7_5;
assign funct7_5 = instruction[30];
assign func3 = instruction[14:12];
always @(*)begin
    ALUcontrol = 3'b000;
  case(ALUOp)
2'b00:begin ALUcontrol = 3'b000;end
2'b01:begin ALUcontrol = 3'b001;end
2'b10: begin
    if(func3 == 3'b000) begin
        if(funct7_5 == 1'b0)
            ALUcontrol = 3'b000;  
        else
            ALUcontrol = 3'b001;  
    end
    else if(func3 == 3'b110) ALUcontrol = 3'b011; 
    else if(func3 == 3'b111) ALUcontrol = 3'b010; 
    else if(func3 == 3'b010) ALUcontrol = 3'b101; 
end
  endcase
end
endmodule
