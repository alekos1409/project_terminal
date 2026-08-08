module top_unit_pipelined (
    input CLK100MHZ,
   input reset_raw,
     input PS2_CLK,
    input PS2_DATA,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output UART_TXD,
    input rx,
    output reg [7:0]LED
);
  wire reset = ~reset_raw;
  wire [1:0] ALUOpE, ForwardAE, ForwardBE;
  wire [2:0] ALUcontrolE;
  wire PCSrcE,RegWriteW,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
MemReadE,MemToRegE,carry,negative,overflow,RegWriteM,
MemWriteM,MemToRegM,MemToRegW,zero,flushE,stallF,flushD,stallD;
  wire [4:0] RdW, RdE, RdM, Rs1E, Rs2E, Rs1D, Rs2D;
  wire [31:0]PCTargetE,InstrD,PCD,PCplus4D,
ResultW,PCE,PCplus4E,RD1E,RD2E,Imm_outE,ALuResultM,WriteDataM,
PCplus4M,slt,PCplus4W,ALuResultW,ReadDataW,SrcAE,SrcBE;
reg CLK50MHZ=0;    
wire [31:0]keycode;
wire [31:0]InstrE;
wire [7:0]scan_key;
wire [7:0]ascii_conv;
wire busy ;
wire  key_valid,byte_valid;
wire [7:0]received_byte ;
reg [7:0]byte_valid_hold;
wire  line_ready;
wire [2:0] format_tag;
wire [95:0] token1, token2, token3;
 wire [4:0] rs1_out,rs2_out,rd_out;
 wire [31:0] imm,imm_out;
 wire  [31:0] mnemonic;
 wire [6:0]opcode,func7;
 wire [2:0]func3;
 wire [4:0]rs1;
 wire [4:0]rs2;
 wire [4:0]rd;
  wire line_ready_d1;
  wire[31:0] mnemonic_d1;
  wire [31:0]instruction_assemblied;
  wire [2:0]format_tag_d1,format_tag_d2;
  wire line_ready_d2, instr_valid;
always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end
  fetch fetch (
      .clk(CLK100MHZ),
      .reset(reset),
      .PCSrcE(PCSrcE),
      .PCTargetE(PCTargetE),
      .InstrD(InstrD),
      .PCD(PCD),
      .PCplus4D(PCplus4D),
      .stallF(stallF),
      .stallD(stallD),
      .flushD(flushD),
      .instruction_assemblied(instruction_assemblied),
      .new_instr_ready(instr_valid)
  );
  decode decode (
      .clk(CLK100MHZ),
      .reset(reset),
      .ALUOpE(ALUOpE),
      .ALUcontrolE(ALUcontrolE),
      .PCE(PCE),
      .RdW(RdW),
      .RdE(RdE),
      .RegWriteW(RegWriteW),
      .RegWriteE(RegWriteE),
      .MemWriteE(MemWriteE),
      .JumpE(JumpE),
      .BranchE(BranchE),
      .ALUSrcE(ALUSrcE),
      .MemReadE(MemReadE),
      .MemToRegE(MemToRegE),
      .PCplus4D(PCplus4D),
      .PCD(PCD),
      .ResultW(ResultW),
      .PCplus4E(PCplus4E),
      .RD1E(RD1E),
      .RD2E(RD2E),
      .Imm_outE(Imm_outE),
      .InstrD(InstrD),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .flushE(flushE),
      .stallD(stallD),
      .InstrE(InstrE)
  );
  execute execute (
      .PCE(PCE),
      .PCplus4E(PCplus4E),
      .RD1E(SrcAE),
      .RD2E(SrcBE),
      .Imm_outE(Imm_outE),
      .RdE(RdE),
      .reset(reset),
      .clk(CLK100MHZ),
      .RegWriteE(RegWriteE),
      .MemWriteE(MemWriteE),
      .JumpE(JumpE),
      .BranchE(BranchE),
      .ALUSrcE(ALUSrcE),
      .MemReadE(MemReadE),
      .MemToRegE(MemToRegE),
      .ALUcontrolE(ALUcontrolE),
      .ALuResultM(ALuResultM),
      .WriteDataM(WriteDataM),
      .PCplus4M(PCplus4M),
      .RdM(RdM),
      .PCTargetE(PCTargetE),
      .zero(zero),
      .slt(slt),
      .PCSrcE(PCSrcE),
      .carry(carry),
      .negative(negative),
      .overflow(overflow),
      .RegWriteM(RegWriteM),
      .MemWriteM(MemWriteM),
      .MemToRegM(MemToRegM),
      .SrcAE(SrcAE),
      .SrcBE(SrcBE),
      .InstrE(InstrE)
  );
  memory_access memory_access (
      .ALuResultM(ALuResultM),
      .WriteDataM(WriteDataM),
      .PCplus4M(PCplus4M),
      .RdM(RdM),
      .clk(CLK100MHZ),
      .reset(reset),
      .MemWriteM(MemWriteM),
      .MemToRegM(MemToRegM),
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW),
      .MemToRegW(MemToRegW),
      .ReadDataW(ReadDataW),
      .PCplus4W(PCplus4W),
      .ALuResultW(ALuResultW),
      .RdW(RdW)
        );
  write_back write_back (
      .MemToRegW(MemToRegW),
      .ResultW(ResultW),
      .ReadDataW(ReadDataW),
      .ALuResultW(ALuResultW)
  );
  hazard_forwarding_unit hazard_unit (
      .RdM(RdM),
      .RdW(RdW),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE),
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW),
      .ALuResultM(ALuResultM),
      .ResultW(ResultW),
      .RD1E(RD1E),
      .RD2E(RD2E),
      .SrcAE(SrcAE),
      .SrcBE(SrcBE)
  );
  hazard_control_unit hazard_control_unit (
      .RdE(RdE),
      .flushD(flushD),
      .flushE(flushE),
      .stallD(stallD),
      .stallF(stallF),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .MemReadE(MemReadE),
      .PCSrcE(PCSrcE)
  );
  
PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0]),
.key_valid(key_valid)
);

seg7decimal sevenSeg (
.x(instruction_assemblied),
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
  tokenizer tokenizer(
  .clk(CLK100MHZ),
  .reset(reset),
  .received_byte(received_byte),
  .byte_valid(byte_valid),
  .mnemonic(mnemonic),
  .token1(token1),
  .token2(token2),
  .token3(token3),
  .line_ready(line_ready)
  );
  mnemonic_decoder mnemonic_decoder(
  .clk(CLK100MHZ),
  .line_ready(line_ready),
  .reset(reset),
  .mnemonic(mnemonic),
  .rs1_in(rs1_out),
  .rs2_in(rs2_out),
  .rd_in(rd_out),
  .imm_in(imm_out),
  .format_tag(format_tag),
  .opcode(opcode),
  .func7(func7),
  .func3(func3),
  .imm(imm),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .line_ready_d1(line_ready_d1),
  .mnemonic_d1(mnemonic_d1),
  .format_tag_d1(format_tag_d1),
  .line_ready_d2(line_ready_d2),
  .format_tag_d2(format_tag_d2)
  );
   operand_interpreter  operand_interpreter(
   .clk(CLK100MHZ),
   .reset(reset),
   .line_ready(line_ready),
   .format_tag(format_tag),
  .token1(token1),
  .token2(token2),
  .token3(token3),
  .rs1_out(rs1_out),
  .rs2_out(rs2_out),
  .rd_out(rd_out),
  .imm(imm_out)
   );
 instruction_assembler    instruction_assembler(
.clk(CLK100MHZ),
.reset(reset),
.opcode(opcode),
.func7(func7),
.func3(func3),
.rs1(rs1),
.rs2(rs2),
.rd(rd),
.imm(imm_out),
.format_tag(format_tag_d2),
.line_ready_d1(line_ready_d2),
.instruction_assemblied(instruction_assemblied),
.instr_valid(instr_valid)
);
  always @(posedge CLK100MHZ)begin
byte_valid_hold <= byte_valid;
  end
    always @(posedge CLK100MHZ) begin 
 if(RegWriteM && RdM != 5'b0)
  LED <= ALuResultM[7:0];
  end
endmodule

