//στέλνει τα δεδομένα προς τα έξω 
module UART_tx (
    clk,
    send,
   /* reset,*/
    data_in,
    tx,
    busy
);
  input clk,send/*, reset*/;
  input [7:0] data_in;
  output reg tx, busy;
  reg [7:0] shift_reg;//αποθηκεύονται τα data
  reg [2:0] bit_counter;//μετράει πάσα bit περνάνε(8bit)
  parameter idle = 2'b0, start = 2'b01, data = 2'b10, stop = 2'b11;
  parameter CLKS_PER_BIT = 10417;// συγχρωνισμός με τη ταχύτητα του fpga
  reg [13:0] cycle_counter;
  reg [1:0] state = idle;
  reg send_in;
  initial begin
 cycle_counter = 0;
 bit_counter = 0;
 tx = 1;
 busy = 0;
end
always @(posedge clk)begin
send_in <=send;
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
      case (state)
        idle: begin
          tx   <= 1;
          busy <= 0;
          if (send && !send_in && !busy) begin
            state <= start;
            shift_reg <= data_in;
          end else state <= idle;
        end
        start: begin
          tx   <= 0;
          busy <= 1;
          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
            state <= data;
          end else cycle_counter <= cycle_counter + 1;
        end
        data: begin
          tx   <= shift_reg[bit_counter];
          busy <= 1;
          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
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
          end else cycle_counter <= cycle_counter + 1;
        end
      endcase
    end
  /*end*/
endmodule
