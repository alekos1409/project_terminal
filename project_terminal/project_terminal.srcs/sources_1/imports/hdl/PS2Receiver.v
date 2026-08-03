`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:33:36 PM
// Design Name: 
// Module Name: PS2Receiver
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: PS2 Receiver module used to shift in keycodes from a keyboard plugged into the PS2 port
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PS2Receiver(
    input clk,
    input kclk,
    input kdata,
    output [31:0] keycodeout,
    output reg key_valid
    );
    
    
    wire kclkf, kdataf;
    reg [7:0]datacur;
    reg [7:0]dataprev;
    reg [3:0]cnt;
    reg [31:0]keycode;
    reg flag;
    reg released;
    
    initial begin
        keycode[31:0]<=32'b00000000;
        cnt<=4'b0000;
        flag<=1'b0;
         key_valid <=0;
          dataprev <= 8'b0;
    datacur <= 8'b0;
    released <= 1'b0;
    end
    
debouncer debounce(
    .clk(clk),
    .I0(kclk),
    .I1(kdata),
    .O0(kclkf),
    .O1(kdataf)
);
    
always@(negedge(kclkf))begin
    case(cnt)
    0:;//Start bit
    1:datacur[0]<=kdataf;
    2:datacur[1]<=kdataf;
    3:datacur[2]<=kdataf;
    4:datacur[3]<=kdataf;
    5:datacur[4]<=kdataf;
    6:datacur[5]<=kdataf;
    7:datacur[6]<=kdataf;
    8:datacur[7]<=kdataf;
    9:flag<=1'b1;
    10:flag<=1'b0;
    
    endcase
        if(cnt<=9) cnt<=cnt+1;
        else if(cnt==10) cnt<=0;
        
end

always @(posedge flag) begin
    key_valid <= 1'b0;
        if(datacur == 8'hF0) begin
            released <= 1'b1;
        end
        else if(released) begin
            released <= 1'b0;
        end
        else begin
            key_valid <= 1'b1;
        end
        keycode[31:24] <= keycode[23:16];
        keycode[23:16] <= keycode[15:8];
        keycode[15:8]  <= dataprev;
        keycode[7:0]   <= datacur;

        dataprev <= datacur;

    end

   
assign keycodeout=keycode;
    
endmodule
