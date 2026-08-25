
module decode(reset,Imm_outE,PCD,PCplus4D,InstrD,PCE,RD1E,RD2E,PCplus4E,RegWriteW,clk,ResultW, RegWriteE,MemWriteE,JumpE,BranchE,
ALUSrcE,MemReadE,MemToRegE,RdE,ALUOpE,RdW,ALUcontrolE,Rs1E,Rs2E,Rs1D,Rs2D,flushE,stallD,InstrE);
input [31:0]PCD,PCplus4D,InstrD,ResultW;
input RegWriteW,clk,reset,flushE;
input stallD;
input [4:0] RdW;
output reg [31:0]PCE,PCplus4E,RD1E,RD2E,Imm_outE;
output reg [4:0]RdE;
output reg [4:0]Rs1E,Rs2E;
output reg RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,MemReadE,MemToRegE;
output reg [1:0]ALUOpE;
output reg [2:0]ALUcontrolE;
wire [31:0]Imm_outD,RD1D,RD2D;
wire [4:0] RdD;
output [4:0]Rs1D,Rs2D;
output reg [31:0]InstrE;
wire [6:0]op;
wire [2:0]func3,ALUcontrolD;
wire [1:0]ALUOpD;
wire func7_5,MemReadD,RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,MemToRegD;
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];
assign op = InstrD[6:0];
assign func3 = InstrD[14:12];
assign func7_5 = InstrD[30];

register_file register_file(
    .clk(clk),
    .we(RegWriteW),
    .rs1_addr(Rs1D),
    .rs2_addr(Rs2D),
    .rs1_data(RD1D),
    .rs2_data(RD2D),
    .rd_addr(RdW),
    .rd_data(ResultW)
);

imm_gen imm_gen(
    .instruction(InstrD),
    .imm_out(Imm_outD)
);

control_unit control_unit(
    .RegWrite(RegWriteD),
    .MemWrite(MemWriteD),
    .Jump(JumpD),
    .Branch(BranchD),
    .ALUSrc(ALUSrcD),
    .MemToReg(MemToRegD),
    .MemRead(MemReadD),
    .ALUOp(ALUOpD),
    .instruction(InstrD)
);
alu_control alu_control(
.instruction(InstrD),
.ALUOp(ALUOpD),
.ALUcontrol(ALUcontrolD)
);
always @(posedge clk)begin
    if(reset)begin
        RegWriteE   <= 0;
    MemWriteE   <= 0;
    MemReadE    <= 0;
    JumpE       <= 0;
    BranchE     <= 0;
    ALUcontrolE <= 0;
    ALUOpE      <= 0;
    ALUSrcE     <= 0;
    MemToRegE   <= 0;

    RdE         <= 0;
    Imm_outE    <= 0;
    PCE         <= 0;
    PCplus4E    <= 0;
    RD1E        <= 0;
    RD2E        <= 0;
    Rs1E        <= 0;
    Rs2E        <= 0;
    InstrE <= 0;
    end
    else begin
        if(stallD) begin
    end
    if(flushE) begin
        RegWriteE  <= 0;
        MemWriteE  <= 0;
        MemReadE   <= 0;
        JumpE      <= 0;
        BranchE    <= 0;
        ALUcontrolE<= 0;
        ALUOpE     <= 0;
        ALUSrcE    <= 0;
        MemToRegE  <= 0;
        RdE        <= 0;
        RD1E       <= 0;
        RD2E       <= 0;
        Imm_outE   <= 0;
        InstrE <= 0;
end
    else begin
RegWriteE<=RegWriteD;
MemWriteE<=MemWriteD;
MemReadE<=MemReadD;
JumpE<=JumpD;
BranchE<=BranchD;
ALUcontrolE<=ALUcontrolD;
ALUOpE<=ALUOpD;
ALUSrcE<=ALUSrcD;
MemToRegE<=MemToRegD;
RdE<=RdD;
Imm_outE <= Imm_outD;
PCE <= PCD;
PCplus4E <= PCplus4D;
RD1E <= RD1D;
RD2E <= RD2D;
Rs1E <= Rs1D;
Rs2E <= Rs2D;
InstrE <= InstrD;
end
end
end
endmodule