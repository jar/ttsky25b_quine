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
  assign uo_out = {hsync, RGB[0], RGB[2], RGB[4], vsync, RGB[1], RGB[3], RGB[5]};
  wire _unused = &{ena, ui_in, uio_in, pix_y};
  assign uio_out = 0;
  assign uio_oe  = 0;
  wire hsync;
  wire vsync;
  wire [5:0] RGB;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );

  wire [9:0] xb = pix_x / 5;
  wire [9:0] yb = pix_y / 9;
  wire [9:0] xx = (pix_x - 5 * xb);
  wire [9:0] yy = (pix_y - 9 * yb);
`ifdef FOO
  wire [9:0] gi = (xb > 79) ? xb - 80 : xb;
`else
  //wire [7:0] c = {4'b0000, xb[3:0]} << 3;
  //wire [9:0] gi = {1'b0,1'b0,str[c+7],str[c+6],str[c+5],str[c+4],str[c+3],str[c+2],str[c+1],str[c+0]};
  //wire [9:0] gi = {1'b0,1'b0,str[c+0],str[c+1],str[c+2],str[c+3],str[c+4],str[c+5],str[c+6],str[c+7]} - 32;
  //wire [9:0] gi = {1'b0,1'b0,str[15],str[14],str[13],str[12],str[11],str[10],str[9],str[8]} - 32;
/*
  always @(posedge vsync)
  begin
  $display("%d", str[31:0]);
  end
*/
  //wire [7:0] c = str[{1'b0, xb[4:0]}]-33;
  wire [7:0] c = str[8*(31-xb[4:0])+:8]-32;
  //wire [7:0] i = {3'b000, xb[4:0]};
  //wire [7:0] c = {str[i+7], str[i+6], str[i+5], str[i+4], str[i+3], str[i+2], str[i+1], str[i+0] };
/*  always @(posedge vsync) begin
    $display("%d", str[0]);
    $display("%d", str[1]);
    $display("%d", str[2]);
    $display("%d", str[3]);
    $display("%d", str[4]);
  end
*/
  //wire [9:0] gi = {2'b00, c};
`endif
  //wire [9:0] gy = (gi << 2) + {8'b0, xx[1:0]};
  wire [9:0] gy = {c, 2'b00} + {8'b0, xx[1:0]};
  wire hl = (xx[2] || yy == 8)? 0 : g[yy[2:0]][gy[8:0]];

  assign RGB = (video_active & hl) ? 6'b111111 : 6'b000000;

  // glyphs
  reg [383:0] g[7:0];
  initial begin
    g[0] = 384'h0022400000020000000214410408010102616f999997676769919c796ff3636670000066f6f6f6464000002426045540;
    g[1] = 384'h0042200000020000000210010208010205412899999299999bf1582991159599820422998916896940000042299e5540;
    g[2] = 384'h00422f999997e7e767929667e26e67e400422496999219999bf138291119159f44f222998175484d200000810145f540;
    g[3] = 384'h0a8218969992199999f254499799999000422266999267979d91582fd77917fb280100e64795644b2000158102455040;
    g[4] = 384'h05422496999261999992344992f9199000422246f69283919d9158299119199b24f20089498f824920703281052af040;
    g[5] = 384'h004222e6f69281e799925449e219999000442149f69295b1999199299115999f020422992994914910021581092a5000;
    g[6] = 384'h00224f8996e47181699495c982ee67e000646f4996626961699f967961f367992000226626646f461202004206975040;
    g[7] = 384'h00000060000000810000020061000000f0000000000000c0000000000000000600001000000000000001002400020000;
  end

  // This is a test!
//  reg [8*16:0] str;
  parameter N = 32;
  //reg [7:0] str[0:N] = "01234567890123456789012345678901";
  parameter [8*N-1:0] str = {"01234567890123456789012345678901"};
  //reg [8*32-1:0] str = 256'h3031323334353637383930313233343536373839303132333435363738393031;
/*
  reg [7:0] str[0:N];
  //reg [16:0][7:0] str;
  initial begin
	integer fd;
	fd = $fopen("../src/tt_um_quine.v", "r");
	$fread(str, fd, 0, N);
    $fclose(fd);
  end
*/

endmodule
