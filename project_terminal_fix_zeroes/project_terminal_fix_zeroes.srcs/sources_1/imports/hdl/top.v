`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:06:31 PM
// Design Name: 
// Module Name: top
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: This project takes keyboard input from the PS2 port,
//  and outputs the keyboard scan code to the 7 segment display on the board.
//  The scan code is shifted left 2 characters each time a new code is
//  read.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output UART_TXD,
    input rx,
    output reg [7:0]LED
    );
    
reg CLK50MHZ=0;    
wire [31:0]keycode;
wire [7:0]scan_key;
wire [7:0]ascii_conv;
wire busy ;
wire  key_valid,byte_valid;
wire [7:0]received_byte ;
reg [7:0]byte_valid_hold;
always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0]),
  .key_valid(key_valid)
);

seg7decimal sevenSeg (
.x(ascii_conv),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(DP) 
);
ascii ascii(
.scan_key(keycode[7:0]),
.asciii(ascii_conv)
);
 UART_tx UART_tx(
 .clk(CLK100MHZ),
.data_in(ascii_conv),
.tx(UART_TXD),
.busy(busy),
.send(key_valid)
 );
 UART_rx UART_rx(
 .clk(CLK100MHZ),
 .rx(rx),
 .received_byte(received_byte),
 .byte_valid(byte_valid)
  );
  
  always @(posedge CLK100MHZ)begin
byte_valid_hold <= byte_valid;
  end
    always @(posedge CLK100MHZ) begin 
  if(byte_valid )begin
  LED <= received_byte;
  end
  end
endmodule
