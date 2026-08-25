module fetch(clk,PCSrcE,PCplus4D,PCTargetE,InstrD,PCD,reset,stallF,flushD,stallD,instruction_assemblied,new_instr_ready);
input clk,PCSrcE,reset,stallF,stallD,flushD,new_instr_ready;
input [31:0]PCTargetE;
output reg [31:0]InstrD,PCD,PCplus4D;
input [31:0]instruction_assemblied;
wire [31:0]PCF_next,PCPlus4F,instruction;
reg [31:0]PCF;
assign PCF_next = PCSrcE ? PCTargetE : PCPlus4F;
assign PCPlus4F = PCF +4;
/*instr_mem instr_mem(
.addr(PCF),
.instruction(instruction)
);*/
always @(posedge clk) begin

    if(reset) begin
        PCF <= 0;
        InstrD <= 0;
        PCD <= 0;
        PCplus4D <= 0;
    end

    else begin

        if(flushD) begin
            InstrD <= 0;
            PCD <= 0;
            PCplus4D <= 0;
        end
        else begin
         if(!stallD) begin
        if(new_instr_ready)
                InstrD <= instruction_assemblied;
            else
                InstrD <= 32'h00000013;   // NOP στους ενδιάμεσους κύκλους
            PCD <= PCF;
            PCplus4D <= PCPlus4F;
        end
        end
       if(!stallF) begin
            PCF <= PCF_next;
        end

    end
end
endmodule