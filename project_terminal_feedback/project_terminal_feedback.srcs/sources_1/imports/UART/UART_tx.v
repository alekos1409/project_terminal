//στέλνει τα δεδομένα προς τα έξω 
module UART_tx (
    clk,
   /* reset,*/
    data_in,
    tx,
    busy,
    RdW,
    message_ready
);
  input clk,message_ready/*, reset*/;
  input [63:0] data_in;
  input [4:0]RdW;
  output reg tx, busy;
  reg [7:0] shift_reg;//αποθηκεύονται τα data
  reg [2:0] bit_counter;//μετράει πάσα bit περνάνε(8bit)
  reg line_is_sending;
  parameter idle = 2'b0, start = 2'b01, data = 2'b10, stop = 2'b11;
  parameter CLKS_PER_BIT = 10417;// συγχρωνισμός με τη ταχύτητα του fpga
  reg [13:0] cycle_counter;
  reg [1:0] state = idle;
  reg [7:0]sending_byte;
  integer i;
  initial begin
 cycle_counter = 0;
 bit_counter = 0;
 tx = 1;
 busy = 0;
end
  always @(posedge clk) begin
    /*if (reset) begin
      cycle_counter <= 0;
      tx <= 1;
      busy <= 0;
      state <= idle;
      shift_reg <= 0;
      bit_counter <= 0;
    end else begin */
    if( message_ready)begin
    line_is_sending <=1;
    i <= 8;
    end
    if(line_is_sending)begin
   if(i>0)  begin   
    sending_byte = data_in[(8*i-1) -: 8];
      case (state)
        idle: begin
          tx   = 1;
          busy = 0;
          if (!busy ) begin
            state <= start;
            shift_reg = sending_byte;
          end else state = idle;
        end
        start: begin
          tx   = 0;
          busy = 1;
          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
            state <= data;
          end else cycle_counter = cycle_counter + 1;
        end
        data: begin
          tx   = shift_reg[bit_counter];
          busy = 1;
          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter = 0;
            if (bit_counter == 3'h7) state <= stop;
            else bit_counter <= bit_counter + 1;
          end else cycle_counter <= cycle_counter + 1;
        end
        stop: begin
          tx   <= 1;
          busy <= 1;

          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
            state <= idle;
            bit_counter <= 0;
               i <= i - 1;
          end else cycle_counter <= cycle_counter + 1;
        end
      endcase
       end
       else begin
         if(i == 0)begin
          line_is_sending <=0 ;
          busy <= 0;
          end
        end
    end
        else state<=idle;

    end
  /*end*/
endmodule
