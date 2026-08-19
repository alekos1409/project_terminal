`timescale 1ns / 1ps
module operand_interpreter(
    input clk,
    input reset,
    input line_ready,
    input [2:0] format_tag,
    input [95:0] token1, token2, token3,
    output reg [4:0] rs1_out,rs2_out,rd_out,
    output reg [31:0] imm
    );
    integer i;
    always @(posedge clk)begin
    if(reset)begin
    rs1_out <=0;
    rs2_out <=0;
    rd_out <=0;
    imm <=0;
    end
    else  if(line_ready) begin
    case(format_tag)
       //R-type
    3'b000:begin
    if(token1[79:72] == 8'h20) 
   rd_out <= token1[87:80]-8'h30;
    else 
     rd_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
     if(token2[79:72] == 8'h20) 
   rs1_out <= token2[87:80]-8'h30;
    else 
     rs1_out <= (token2[87:80]-8'h30)*10 + (token2[79:72]-8'h30);
      if(token3[79:72] == 8'h20) 
   rs2_out <= token3[87:80]-8'h30;
    else 
     rs2_out <= (token3[87:80]-8'h30)*10 + (token3[79:72]-8'h30);
    end
       //I-type
    3'b001:begin
    imm = 0;
     if(token1[79:72] == 8'h20) 
   rd_out <= token1[87:80]-8'h30;
    else 
     rd_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
     if(token2[79:72] == 8'h20) 
   rs1_out <= token2[87:80]-8'h30;
    else 
     rs1_out <= (token2[87:80]-8'h30)*10 + (token2[79:72]-8'h30);
      if(token3[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token3[i +: 8] != 8'h20 && token3[i +: 8] != 8'h2C)
    imm = imm*10 + (token3[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
     else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token3[i +: 8] != 8'h20 && token3[i +: 8] != 8'h2C)
   imm = imm*10 + (token3[i +: 8]-8'h30);
   end
   end
    end
      //LW
    3'b010:begin
    imm = 0;
     if(token1[79:72] == 8'h20) 
   rd_out <= token1[87:80]-8'h30;
    else 
     rd_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
   if(token2[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
    imm = imm*10 + (token2[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
         else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
   imm = imm*10 + (token2[i +: 8]-8'h30);
   end
   end
     if(token3[79:72] == 8'h20) 
   rs1_out <= token3[87:80]-8'h30;
    else 
     rs1_out <= (token3[87:80]-8'h30)*10 + (token3[79:72]-8'h30);
     end
       //U-type
     3'b011:begin
     imm = 0;
      if(token1[79:72] == 8'h20) 
   rd_out <= token1[87:80]-8'h30;
    else 
     rd_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
     if(token2[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
    imm = imm*10 + (token2[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
         else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
   imm = imm*10 + (token2[i +: 8]-8'h30);
   end
   end
   end
       //B-type
   3'b100:begin
    imm = 0;
     if(token1[79:72] == 8'h20) 
   rs1_out <= token1[87:80]-8'h30;
    else 
     rs1_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
    if(token2[79:72] == 8'h20) 
   rs2_out <= token2[87:80]-8'h30;
    else 
     rs2_out <= (token2[87:80]-8'h30)*10 + (token2[79:72]-8'h30);
     if(token3[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token3[i +: 8] != 8'h20 && token3[i +: 8] != 8'h2C)
    imm = imm*10 + (token3[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
         else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token3[i +: 8] != 8'h20 && token3[i +: 8] != 8'h2C)
   imm = imm*10 + (token3[i +: 8]-8'h30);
   end
   end
     end
      //S-type
     3'b101:begin
     imm = 0;
      if(token1[79:72] == 8'h20) 
   rs2_out <= token1[87:80]-8'h30;
    else 
     rs2_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
     
      if(token2[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
    imm = imm*10 + (token2[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
         else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
   imm = imm*10 + (token2[i +: 8]-8'h30);
   end
   end
   if(token3[79:72] == 8'h20) 
   rs1_out <= token3[87:80]-8'h30;
    else 
     rs1_out <= (token3[87:80]-8'h30)*10 + (token3[79:72]-8'h30);
   end
      //J-type
    3'b110: begin
    imm = 0;
      if(token1[79:72] == 8'h20) 
   rd_out <= token1[87:80]-8'h30;
    else 
     rd_out <= (token1[87:80]-8'h30)*10 + (token1[79:72]-8'h30);
     if(token2[95:88] == 8'h2D )begin
    for(i=80; i >= 0;i = i- 8)begin
    if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
    imm = imm*10 + (token2[i +: 8]-8'h30);
    end
    imm = ~imm + 1;
    end
         else begin
      for(i=88; i >= 0;i = i- 8)begin
       if(token2[i +: 8] != 8'h20 && token2[i +: 8] != 8'h2C)
   imm = imm*10 + (token2[i +: 8]-8'h30);
   end
   end
    end

    endcase 
    end
    end
endmodule
