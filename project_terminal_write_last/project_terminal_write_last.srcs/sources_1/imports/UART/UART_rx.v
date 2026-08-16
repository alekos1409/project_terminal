//διαβάζει τα δεδομένα που έρχονται από το  οθόονη μέσω του UART και τα στέλνει στον επεξεργαστή
module UART_rx (
    clk,
    //reset,
    rx,
    received_byte,
    byte_valid
);
  input clk/*, reset*/, rx;
  parameter idle = 2'b00, start = 2'b01, rx_data_read = 2'b10, stop = 2'b11;
  parameter CLKS_PER_BIT = 10417;
  reg [13:0] cycle_counter;
  reg [1:0] state;
  output reg [7:0] received_byte;//βγάζει τα δεδομένα
  reg [2:0] bit_counter;
  output reg byte_valid;//επιβεβαιώνει ότι έφτασαν τα δεδομένα
reg rx_sync1, rx_sync2;
    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end
  initial begin
   received_byte <= 0;
      byte_valid <= 0;
      state <= idle;
      cycle_counter <= 0;
      bit_counter <= 0;
  end
  always @(posedge clk) begin
    /*if (reset) begin
      received_byte <= 0;
      byte_valid <= 0;
      state <= idle;
      cycle_counter <= 0;
      bit_counter <= 0;
    end else begin*/
      byte_valid <= 0;
      case (state)
        idle: begin
          if ( rx_sync2 == 0) state <= start;
          else state <= idle;
        end
        start: begin
          if (cycle_counter == CLKS_PER_BIT / 2 - 1) begin
            cycle_counter <= 0;
            state <= rx_data_read;
          end else cycle_counter <= cycle_counter + 1;
        end

        rx_data_read: begin
          received_byte[bit_counter] <=  rx_sync2;
          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
            if (bit_counter == 3'h7) state <= stop;
            else bit_counter <= bit_counter + 1;
          end else cycle_counter <= cycle_counter + 1;
        end
        stop: begin

          if (cycle_counter == CLKS_PER_BIT - 1) begin
            cycle_counter <= 0;
            state <= idle;
            bit_counter <= 0;
            byte_valid <= 1;

          end else cycle_counter <= cycle_counter + 1;
        end
      endcase
    end
 /*end*/
endmodule