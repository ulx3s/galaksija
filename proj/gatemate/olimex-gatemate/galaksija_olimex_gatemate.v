//--------------------------
// Top level for Galaksija on Olimex Gatemate
// By: Goran Mahovlić
//--------------------------
// vendor specific library for clock
// no timescale needed

module galaksija_olimex_gatemate(
input wire clk_i,
input wire rstn_i,
// I/O interface to computer
input  i_uart_rx,         // asynchronous serial data input from computer
output o_uart_tx,         // asynchronous serial data output to computer

// I/O interface to keyboard
input ps2clk,          // PS/2 keyboard serial clock input
input ps2data,          // PS/2 keyboard serial data input

// Outputs to VGA display
output o_hsync,      // hozizontal VGA sync pulse
output o_vsync,      // vertical VGA sync pulse

output [3:0] o_r,     // red VGA signal
output [3:0] o_g,     // green VGA signal
output [3:0] o_b,     // blue VGA signal
output wire o_led
);

reg reset_n;
wire clk_pixel, clk_pixel_shift, clk_pixel_shift1, clk_pixel_shift2, locked;
wire [7:0] S_LCD_DAT;
wire [2:0] S_vga_r; wire [2:0] S_vga_g; wire [2:0] S_vga_b;
wire S_vga_vsync; wire S_vga_hsync;
wire S_vga_vblank; wire S_vga_blank;

assign o_led = reset_n;
// visual indication of btn press
// btn(0) has inverted logic

/* 10 MHz to 25MHz */
pll pll_inst (
    .clock_in(clk_i), // 10 MHz
    .rst_in(~rstn_i),
    .clock_out(clk_pixel), // 25 MHz
    .locked(locked)
);

    // debounce reset button
    wire reset_n;

  always @(posedge clk_pixel) begin
    reset_n <= rstn_i;
  end
  

  galaksija
  galaksija_inst
  (
    .clk(clk_pixel),
    .pixclk(clk_pixel),
    .reset_n(reset_n),
    .ser_rx(i_uart_rx),
    .LCD_DAT(S_LCD_DAT),
    .LCD_HS(S_vga_hsync),
    .LCD_VS(S_vga_vsync),
    .LCD_DEN(S_vga_blank)
  );

  // register stage to offload routing
  reg R_vga_hsync, R_vga_vsync, R_vga_blank;
  reg [2:0] R_vga_r, R_vga_g, R_vga_b;
  always @(posedge clk_pixel)
  begin
    o_hsync <= S_vga_hsync;
    o_vsync <= S_vga_vsync;
    R_vga_blank <= S_vga_blank;
    o_r[3:2] <= S_LCD_DAT[7:6];
    o_r[1]   <= S_LCD_DAT[6];
    o_g[3:1] <= S_LCD_DAT[5:3];
    o_b[3:1] <= S_LCD_DAT[2:0];
  end
endmodule
