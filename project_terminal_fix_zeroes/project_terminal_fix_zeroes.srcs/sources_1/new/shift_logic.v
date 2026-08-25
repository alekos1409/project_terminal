module shift_logic(
    input [31:0] a, b,
    input [31:0]instructions,
    output [31:0]shift_result
);
wire [2:0]func3;
wire [6:0] func7;
wire signed [31:0] a_signed;
assign a_signed = a;
assign func3 = instructions[14:12];
assign func7 = instructions[31:25];
assign shift_result = (func3 ==  3'b001 && func7 == 7'b0000000)? a<<b[4:0] :
                        (func3 == 3'b101 && func7 == 7'b0000000)? a>>b[4:0] :
                        (func3 == 3'b101 && func7 == 7'b0100000)? a_signed>>>b[4:0] :
                        0;
endmodule