//χρησιμοποιήται για να αποφεύγεται η συμφώριση, δηλαδή να μην γίνεται overwrite το byte που μόλις έφτασε από το UART μέχρι να διαβαστεί από τον επεξεργαστή.
module UART_rx_mmio (
    reset,
    clk,
    byte_valid,
    rx_data_read,
    rx_full,
    UART_rx_byte,//η πληροφορία που έφτασε από το UART
    received_byte
    );
  input reset, clk;
  input byte_valid, rx_data_read;
  input [7:0] received_byte;
  output reg rx_full;
  reg [31:0] rx_data_latched;//παγώνει τα δεδομένα που έφτασαν από το UART
  output [31:0] UART_rx_byte; 
  parameter Empty = 1'b0, Full = 1'b1;
  reg state;
  always @(posedge clk) begin
    if (reset) begin
      rx_full <= 0;
      rx_data_latched <= 0;
      state <= Empty;
    end else begin
      case (state)
        Empty: begin
          if (byte_valid == 1) begin
            state <= Full;
            rx_data_latched <= {24'b0, received_byte};
             rx_full <= 1;
          end
        end
        Full: begin
         
          if (rx_data_read) begin
            rx_full <= 0;
            state <= Empty;
            rx_data_latched <= 0;
          end
        end
      endcase
    end
  end
  assign UART_rx_byte = rx_data_latched; 
endmodule
