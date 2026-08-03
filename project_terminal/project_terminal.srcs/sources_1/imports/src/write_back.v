module write_back(MemToRegW,ReadDataW,ALuResultW,ResultW);
input MemToRegW;
input [31:0]ReadDataW,ALuResultW;
output [31:0]ResultW;
assign ResultW = MemToRegW ? ReadDataW : ALuResultW;
endmodule


