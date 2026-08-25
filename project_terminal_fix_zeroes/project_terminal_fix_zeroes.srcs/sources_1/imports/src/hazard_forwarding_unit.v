module hazard_forwarding_unit(Rs1E,Rs2E,RdM,RdW,ForwardAE,ForwardBE,
RegWriteM,RegWriteW,ALuResultM,ResultW,RD1E,RD2E,SrcAE,SrcBE);
input [4:0]Rs1E,Rs2E,RdM,RdW;
output [1:0]ForwardAE,ForwardBE;
output [31:0] SrcAE,SrcBE;
input RegWriteM,RegWriteW;
input [31:0]ALuResultM,ResultW,RD1E,RD2E;
assign ForwardAE =  ((RegWriteM == 1'b1) & (RdM != 5'b0) & (RdM == Rs1E)) ? 2'b10:
                    ((RegWriteW == 1'b1) & (RdW != 5'b0) & (RdW == Rs1E)) ? 2'b01 : 2'b00;
assign ForwardBE = ((RegWriteM == 1'b1) & (RdM != 5'b0) & (RdM == Rs2E)) ? 2'b10:
                   ((RegWriteW == 1'b1) & (RdW != 5'b0) & (RdW == Rs2E)) ? 2'b01 :2'b00;
assign SrcAE = (ForwardAE == 2'b00 ) ? RD1E : 
               (ForwardAE == 2'b01) ?  ResultW :
               (ForwardAE == 2'b10) ? ALuResultM :0;
assign SrcBE = (ForwardBE == 2'b00 ) ? RD2E :  
               (ForwardBE == 2'b01) ?  ResultW :
               (ForwardBE == 2'b10) ? ALuResultM :0;
endmodule
