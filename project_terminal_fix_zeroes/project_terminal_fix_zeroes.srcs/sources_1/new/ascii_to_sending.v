`timescale 1ns / 1ps
module ascii_to_sending(
input clk,
input reset,
input message_ready,
input [63:0] ascii_conv,
output reg [63:0] modified_number,
output reg [3:0]count_number,
output reg message_conv_done
    );
    reg number_started;
    reg [1:0]state;
    reg [63:0]ascii_conv_hold;
    parameter idle = 2'b00, conv = 2'b01 , send = 2'b10 , stop = 2'b11;
    integer i , g;
always @(posedge clk)begin
if(reset)begin
i <= 8;
g <= 8;
count_number <= 0;
modified_number <= 0;
state <= idle;
 message_conv_done <= 0;
end
else begin
case(state)
idle: begin
    if(message_ready)begin
    state <= conv;
     i <= 8;
     g <= 8;
     count_number <= 0;
     ascii_conv_hold<= ascii_conv;
      number_started <= 0;
    end
end

conv:begin
if(ascii_conv_hold[(8*i-1) -: 8] == 8'h30 && !number_started)begin
 i <= i - 1;
 if(i== 0)begin
  modified_number[63:56] <= 8'h30;
  count_number <= 1;
  state <= send;
 end
 end
 else begin
 number_started <= 1;
    if(i == 0)begin
    state <= send;
    end
        if(i > 0)begin
         modified_number[(8*g-1) -: 8] <= ascii_conv_hold[(8*i-1) -: 8];
         i <= i - 1;
         g <= g - 1;
         count_number <= count_number + 1;
         end
    end
    end
send:begin
       message_conv_done <= 1;
         state <= stop;
    end
stop: begin
     message_conv_done <= 0;
    state <= idle;
    end
    endcase
end
end
endmodule

