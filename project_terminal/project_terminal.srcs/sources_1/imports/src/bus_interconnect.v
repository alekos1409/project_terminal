module bus_interconnect (
    clk,
    reset,
    address,
    data_in,
    MemWriteM,
    data_data_memory,
    address_data_memory,
    MemWriteM_data_memory,
    ReadDataM,
    data_out
);

input clk;
input reset;
input [31:0] address;
input [31:0] data_in;
input [31:0] data_out;
input MemWriteM;
output reg [31:0] data_data_memory;
output reg [31:0] address_data_memory;
output reg MemWriteM_data_memory;
output reg [31:0] ReadDataM;

always @(*) begin

    address_data_memory = 32'b0;
    data_data_memory = 32'b0;
    MemWriteM_data_memory = 1'b0;
    ReadDataM = 32'b0;

    if(address[31] == 1'b0) begin
        address_data_memory = address;
        data_data_memory = data_in;
        MemWriteM_data_memory = MemWriteM;
        ReadDataM = data_out;
    end

end



endmodule