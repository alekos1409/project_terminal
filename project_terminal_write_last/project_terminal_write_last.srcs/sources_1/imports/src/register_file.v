module register_file(
    input we,
    input clk,
    input reset,
    input [4:0] rs1_addr, rs2_addr, rd_addr,
    input [31:0] rd_data,
    output reg [31:0] rs1_data, rs2_data 
);
reg [31:0] regs [0:31];
integer i;

initial begin
    for(i = 0; i < 32; i = i + 1)
        regs[i] = 32'b0;
end

always @(posedge clk) begin
    if(reset) begin
        for(i = 0; i < 32; i = i + 1)
            regs[i] <= 32'b0;
    end
    else if (we && rd_addr != 5'd0)
        regs[rd_addr] <= rd_data;
end

always @(*) begin
    if (we && rd_addr != 5'd0) begin
        rs1_data = regs[rs1_addr];
        rs2_data = regs[rs2_addr];
    end
end



endmodule