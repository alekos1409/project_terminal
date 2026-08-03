module alu(a, b , ALUcontrol ,result, carry,zero,negative,overflow,slt);
input [31:0]a,b;
input [2:0]ALUcontrol;
output [31:0]result,slt;
output zero;
output carry,negative,overflow;
wire [31:0]a_and_b,a_or_b,not_b,wire_b,sum;
wire cout,xnor_gate,xor_gate;
assign a_and_b = a & b;
assign a_or_b = a | b ;
assign not_b = ~b;
assign wire_b = (ALUcontrol[0] == 1'b0) ? b :not_b;
assign {cout,sum} = a + wire_b + ALUcontrol[0];
assign slt = {31'b0000000000000000000000000000000,sum[31]};
assign result = (ALUcontrol[2:0] == 3'b000) ? sum:
                (ALUcontrol[2:0] == 3'b001) ? sum:
                (ALUcontrol[2:0] == 3'b010) ? a_and_b:
                 (ALUcontrol[2:0] == 3'b011) ? a_or_b:
                 (ALUcontrol[2:0] == 3'b101) ? slt: 32'h00000000;
assign carry = ~ALUcontrol[1] & cout;
assign zero = &(~result);
assign negative = result[31];
assign xor_gate = (a[31] ^ sum[31]);
assign xnor_gate = ~(a[31] ^ ALUcontrol[0] ^ b[31]);
assign overflow = xnor_gate & xor_gate & (~ALUcontrol[1]);


endmodule