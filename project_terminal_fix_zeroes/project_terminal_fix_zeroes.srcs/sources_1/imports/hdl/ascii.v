module ascii(scan_key,asciii);

input [7:0] scan_key;
output reg [7:0] asciii;

always @(*) begin

case(scan_key)

    // Letters A-Z
    8'h1C: asciii = 8'h41; // A
    8'h32: asciii = 8'h42; // B
    8'h21: asciii = 8'h43; // C
    8'h23: asciii = 8'h44; // D
    8'h24: asciii = 8'h45; // E
    8'h2B: asciii = 8'h46; // F
    8'h34: asciii = 8'h47; // G
    8'h33: asciii = 8'h48; // H
    8'h43: asciii = 8'h49; // I
    8'h3B: asciii = 8'h4A; // J
    8'h42: asciii = 8'h4B; // K
    8'h4B: asciii = 8'h4C; // L
    8'h3A: asciii = 8'h4D; // M
    8'h31: asciii = 8'h4E; // N
    8'h44: asciii = 8'h4F; // O
    8'h4D: asciii = 8'h50; // P
    8'h15: asciii = 8'h51; // Q
    8'h2D: asciii = 8'h52; // R
    8'h1B: asciii = 8'h53; // S
    8'h2C: asciii = 8'h54; // T
    8'h3C: asciii = 8'h55; // U
    8'h2A: asciii = 8'h56; // V
    8'h1D: asciii = 8'h57; // W
    8'h22: asciii = 8'h58; // X
    8'h35: asciii = 8'h59; // Y
    8'h1A: asciii = 8'h5A; // Z
    // Numbers 0-9
    8'h45: asciii = 8'h30; // 0
    8'h16: asciii = 8'h31; // 1
    8'h1E: asciii = 8'h32; // 2
    8'h26: asciii = 8'h33; // 3
    8'h25: asciii = 8'h34; // 4
    8'h2E: asciii = 8'h35; // 5
    8'h36: asciii = 8'h36; // 6
    8'h3D: asciii = 8'h37; // 7
    8'h3E: asciii = 8'h38; // 8
    8'h46: asciii = 8'h39; // 9
    // Space
    8'h29: asciii = 8'h20;
    // Enter
    8'h5A: asciii = 8'h0D;
    // Backspace
    8'h66: asciii = 8'h08;
    //comma
    8'h41: asciii = 8'h2C;
 
    default:
        asciii = 8'h00;
endcase
end
endmodule