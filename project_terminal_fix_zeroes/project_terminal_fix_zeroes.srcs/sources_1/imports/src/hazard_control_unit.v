module hazard_control_unit(PCSrcE,RdE,Rs1D,Rs2D,MemReadE,flushD,flushE,stallD,stallF);
input PCSrcE,MemReadE;
input [4:0] Rs1D,Rs2D,RdE;
output flushD,flushE,stallD,stallF;
reg LoadUseHazard;
always @(*)begin
if (MemReadE) begin
if ((RdE == Rs1D | RdE == Rs2D) & RdE != 0 ) begin
 LoadUseHazard = 1'b1;
end
else
 LoadUseHazard = 1'b0;
end
else
LoadUseHazard = 1'b0;
end
assign flushD = PCSrcE;
assign flushE = PCSrcE | LoadUseHazard;
assign stallD = LoadUseHazard;
assign stallF= LoadUseHazard;
endmodule 