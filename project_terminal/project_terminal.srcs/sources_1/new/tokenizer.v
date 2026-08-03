`timescale 1ns / 1ps
module tokenizer(
    input clk,reset,
    input [7:0]received_byte,
    input byte_valid,
    output reg [31:0]mnemonic,
    output reg [95:0] token1, token2, token3,
    output line_ready
    );
    reg [1:0]token_num;
    reg [31:0] char_ptr;
    parameter skip_delim = 0 , read_token = 1;
      reg state;
    always@(posedge clk)begin
    if(reset)begin
        state <= skip_delim;
       mnemonic <= {4{8'h20}};
        token1<={12{8'h20}}; 
        token2<={12{8'h20}};
        token3<={12{8'h20}};
        token_num<=0;
        char_ptr<=24;
        end
         else if(byte_valid && received_byte == 8'h0A) begin
             state <= state;
       mnemonic <= mnemonic;
        token1<=token1; 
        token2<=token2;
        token3<=token3;
        token_num<=token_num;
        char_ptr<=char_ptr;
         end
     else  if (byte_valid) begin
     if(received_byte == 8'h0D)begin
      state <= skip_delim;
       mnemonic <= {4{8'h20}};
        token1<={12{8'h20}}; 
        token2<={12{8'h20}};
        token3<={12{8'h20}};
        token_num<=0;
        char_ptr<=24;
     end
     else begin
    case(state)
    skip_delim: begin 
    if(received_byte == 8'h20 | received_byte == 8'h2C)
        state <= skip_delim;
        else begin 
    state <= read_token;
    case(token_num)
    2'b00: begin mnemonic[char_ptr +: 8] <= received_byte; char_ptr <= char_ptr - 8; end
     2'b01: begin token1[char_ptr +: 8] <= received_byte; char_ptr <= char_ptr - 8; end
      2'b10: begin token2[char_ptr +: 8] <= received_byte; char_ptr <= char_ptr - 8; end
       2'b11: begin token3[char_ptr +: 8] <= received_byte; char_ptr <= char_ptr - 8; end
        endcase
        end
       end
     read_token: begin
     case(token_num)
     2'b00:begin
     if(received_byte != 8'h20 && received_byte != 8'h2C)begin
      mnemonic[char_ptr +: 8] <= received_byte;
      char_ptr <= char_ptr - 8;
      end
      else  begin
      token_num <= token_num + 1;
      char_ptr <= 88;
      state <= skip_delim;
      end
     end
     2'b01:begin
      if(received_byte != 8'h20 && received_byte != 8'h2C)begin
      token1[char_ptr +: 8] <= received_byte;
      char_ptr <= char_ptr - 8;
      end
      else  begin
      token_num <= token_num + 1;
      char_ptr <= 88;
      state <= skip_delim;
      end
     end
   2'b10:begin
      if(received_byte != 8'h20 && received_byte != 8'h2C &&received_byte != 8'h28 )begin
      token2[char_ptr +: 8] <= received_byte;
      char_ptr <= char_ptr - 8;
      end
      else  begin
      token_num <= token_num + 1;
      char_ptr <= 88;
      state <= skip_delim;
      end
     end
    2'b11:begin
      if(received_byte != 8'h20 && received_byte != 8'h2C &&received_byte != 8'h29)begin
      token3[char_ptr +: 8] <= received_byte;
      char_ptr <= char_ptr - 8;
      end
      else  begin
      token_num <= token_num + 1;
      char_ptr <= 24;
      state <= skip_delim;
      end
     end
     endcase
     end  
    endcase
    end
    end
    end
    assign line_ready = (received_byte == 8'h0D && byte_valid) ? 1 : 0;
endmodule

