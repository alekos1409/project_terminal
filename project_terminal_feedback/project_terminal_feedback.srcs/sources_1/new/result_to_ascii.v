`timescale 1ns / 1ps
module result_to_ascii(
input clk,
input reset,
input [4:0]RdW,
input [31:0]result,
output reg[63:0]ascii_conv,
output reg message_ready
    );
    reg [1:0]state;
    parameter idle = 2'b00 , conv = 2'b01 , stop = 2'b10;
integer i;
reg [3:0]number_select;
reg [31:0]result_hold;
always @(posedge clk)begin
    if(reset)begin
    ascii_conv <= 0;
    i <= 8;
    message_ready <= 0;
    state <= 0;
    result_hold <= 0;
        end 
    else begin
    case(state)
    idle:begin
    if(RdW != 5'b0)begin
    result_hold <= result;
    state <= conv;
    ascii_conv <= 0;
    end
    end
    
    conv:begin
    if(i == 0) message_ready <= 1;
        if(i>0)begin
          
            number_select = result_hold[(4*i-1) -: 4];
            case(number_select)
            4'h0: ascii_conv[(8*i-1) -: 8] <= 8'h30;
            4'h1: ascii_conv[(8*i-1) -: 8] <= 8'h31;
            4'h2: ascii_conv[(8*i-1) -: 8] <= 8'h32;
            4'h3: ascii_conv[(8*i-1) -: 8] <= 8'h33;
            4'h4: ascii_conv[(8*i-1) -: 8] <= 8'h34;
            4'h5: ascii_conv[(8*i-1) -: 8] <= 8'h35;
            4'h6: ascii_conv[(8*i-1) -: 8] <= 8'h36;
            4'h7: ascii_conv[(8*i-1) -: 8] <= 8'h37;
            4'h8: ascii_conv[(8*i-1) -: 8] <= 8'h38;
            4'h9: ascii_conv[(8*i-1) -: 8] <= 8'h39;
            4'hA: ascii_conv[(8*i-1) -: 8] <= 8'h41;
            4'hB: ascii_conv[(8*i-1) -: 8] <= 8'h42;
            4'hC: ascii_conv[(8*i-1) -: 8] <= 8'h43;
            4'hD: ascii_conv[(8*i-1) -: 8] <= 8'h44;
            4'hE: ascii_conv[(8*i-1) -: 8] <= 8'H45;
            4'hF: ascii_conv[(8*i-1) -: 8] <= 8'h46;
            endcase
            i <= i - 1;
            
        end
        else begin i <= 8;
        state <= stop;
        end
        end
    stop: begin
    state <= idle;
    message_ready <= 0;
    result_hold <= 0;
    end
  endcase
  end
end
endmodule
