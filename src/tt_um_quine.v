// Copyright (c) 2025 James Ross
`default_nettype none
module tt_um_quine(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);
  wire _unused = &{ui_in, uio_in, ena, rst_n};
  assign {uio_out, uio_oe} = 0;
  wire hsync, vsync, out;
  quine q(.clk(clk), .hsync(hsync), .vsync(vsync), .out(out));
  assign uo_out = {hsync, {3{out}}, vsync, {3{out}}};
endmodule
