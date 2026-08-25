module execute(RegWriteE,MemReadE,MemWriteE,MemToRegE,
ALUSrcE,ALUcontrolE,PCE,PCplus4E,Imm_outE,RdE,JumpE,BranchE,
ALuResultM,WriteDataM,PCTargetE,slt,carry,negative,overflow,
RdM,RegWriteM,MemWriteM,MemToRegM,PCplus4M,clk,PCSrcE,reset,zero,SrcAE,SrcBE,InstrE);
input [31:0]PCE,PCplus4E,Imm_outE,SrcAE,SrcBE;
input [4:0]RdE;
input [31:0]InstrE;
input reset,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,MemReadE,MemToRegE;
input clk;
input [2:0]ALUcontrolE;
output reg [31:0]ALuResultM,WriteDataM,PCplus4M ;
output reg [4:0]RdM;
output [31:0]PCTargetE,slt;
output PCSrcE,carry,negative,overflow,zero;
output reg RegWriteM,MemWriteM,MemToRegM;
wire [31:0]WriteDataE,Src1E,Src2E,ALuResultE,ALuResultE_out,shift_result;
wire branch_taken;
assign branch_taken = (InstrE[14:12] == 3'b000) ? zero :       
               (InstrE[14:12] == 3'b001) ? ~zero :        
               1'b0;                                      
assign PCTargetE = PCE + Imm_outE;
assign Src2E = ALUSrcE ? Imm_outE : SrcBE;
assign WriteDataE = SrcBE;
assign PCSrcE =  (branch_taken & BranchE)| JumpE; 
assign ALuResultE_out = ((InstrE[14:12] == 3'b001 && InstrE[31:25] == 7'b0000000 && InstrE[6:0]== 7'b0110011) ||
 (InstrE[14:12] == 3'b101 && InstrE[31:25] == 7'b0000000 && InstrE[6:0]== 7'b0110011) || (InstrE[14:12] == 3'b101 && InstrE[31:25] == 7'b0100000 && InstrE[6:0]== 7'b0110011))?shift_result : ALuResultE;
alu alu(
.a(SrcAE),
.b(Src2E),
.ALUcontrol(ALUcontrolE),
.result(ALuResultE),
.zero(zero),
.slt(slt),
.negative(negative),
.carry(carry),
.overflow(overflow)
);
shift_logic shift_logic(
.a(SrcAE),
.b(Src2E),
.instructions(InstrE),
.shift_result(shift_result)
);
always @ (posedge clk)
begin
    if (reset)begin
ALuResultM <= 0;
WriteDataM <= 0;
RdM <= 0;
PCplus4M <= 0;
RegWriteM <= 0;
MemWriteM <= 0;
MemToRegM <= 0;
    end
    else begin
ALuResultM <= ALuResultE_out;
WriteDataM <= WriteDataE;
RdM <= RdE;
PCplus4M <= PCplus4E;
RegWriteM <= RegWriteE;
MemWriteM <= MemWriteE;
MemToRegM <= MemToRegE;
    end
end

endmodule
