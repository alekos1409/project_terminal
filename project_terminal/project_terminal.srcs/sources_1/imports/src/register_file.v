module register_file(
    input we,
    input clk,
    input [4:0] rs1_addr, rs2_addr, rd_addr,
    input [31:0] rd_data,
    output [31:0] rs1_data, rs2_data
);

reg [31:0] regs [0:31];
integer i;

initial begin
    for(i = 0; i < 32; i = i + 1)
        regs[i] = 32'b0;
end

always @(posedge clk) begin
    if (we && rd_addr != 5'd0)
        regs[rd_addr] <= rd_data;
end

assign rs1_data = (we && (rd_addr == rs1_addr) && (rd_addr != 5'd0))
                ? rd_data : regs[rs1_addr];

assign rs2_data = (we && (rd_addr == rs2_addr) && (rd_addr != 5'd0))
                ? rd_data : regs[rs2_addr];

endmodule