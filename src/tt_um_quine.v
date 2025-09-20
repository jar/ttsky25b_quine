// Copyright (c) 2024 James Ross
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
  assign uo_out = {hsync, out, out, out, vsync, out, out, out};
  wire _unused = &{ena, ui_in, uio_in};
  assign {uio_out, uio_oe}  = 0;
  wire hsync, vsync, out;
  quine quine_gen(
    .clk(clk),
    .rst_n(rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .out(out)
  );
endmodule
