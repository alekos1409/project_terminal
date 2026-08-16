module write_back(MemToRegW,ReadDataW,ALuResultW,ResultW,RdW,RdW_wb);
input MemToRegW;
input [4:0] RdW;
input [31:0]ReadDataW,ALuResultW;
output [31:0]ResultW;
output [4:0]RdW_wb;
assign RdW_wb = RdW;
assign ResultW = MemToRegW ? ReadDataW : ALuResultW;
endmodule


