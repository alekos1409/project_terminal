
module memory_access (
    ALuResultM,
    WriteDataM,
    PCplus4M,
    RdM,
    MemWriteM,
    MemToRegM,
    clk,
    ReadDataW,
    PCplus4W,
    ALuResultW,
    RdW,
    reset,
    RegWriteM,
    MemToRegW,
    RegWriteW
);

input [31:0] ALuResultM;
input [31:0] WriteDataM;
input [31:0] PCplus4M;

input [4:0] RdM;

input clk;
input reset;
input MemWriteM;
input MemToRegM;
input RegWriteM;
output reg RegWriteW;
output reg MemToRegW;
output reg [31:0] ReadDataW;
output reg [31:0] PCplus4W;
output reg [31:0] ALuResultW;
output reg [4:0] RdW;
wire [31:0] ReadDataMem_in;
wire [31:0] ReadDataMem_out;
wire [31:0] address_data_memory;
wire [31:0] data_data_memory;
wire MemWriteM_data_memory;

data_memory data_memory (

    .clk(clk),
    .we(MemWriteM_data_memory),
    .address(address_data_memory),
    .data_in(data_data_memory),
    .data_out(ReadDataMem_in)

);



bus_interconnect bus_interconnect (

    .clk(clk),
    .reset(reset),

    .address(ALuResultM),
    .data_in(WriteDataM),
    .MemWriteM(MemWriteM),

    .data_data_memory(data_data_memory),
    .address_data_memory(address_data_memory),
    .MemWriteM_data_memory(MemWriteM_data_memory),

    .ReadDataM(ReadDataMem_out),
    .data_out(ReadDataMem_in)
);



always @(posedge clk) begin

    if(reset) begin

        ReadDataW <= 0;
        RdW <= 0;
        PCplus4W <= 0;
        ALuResultW <= 0;

        RegWriteW <= 0;
        MemToRegW <= 0;

    end

    else begin

        ReadDataW <= ReadDataMem_out;

        RdW <= RdM;

        PCplus4W <= PCplus4M;

        ALuResultW <= ALuResultM;

        RegWriteW <= RegWriteM;

        MemToRegW <= MemToRegM;

    end

end


endmodule