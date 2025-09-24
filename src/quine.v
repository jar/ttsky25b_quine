`default_nettype none // copyright (c) 2025 james ross
module quine(input wire clk, output reg hsync, output reg vsync, output wire out);
  wire hmaxxed = hpos == 799;
  wire vmaxxed = vpos == 524;
  reg [9:0] hpos;
  reg [9:0] vpos;
  reg [$clog2(n)-1:0] cpos;
  reg [$clog2(n)-1:0] csave;
  wire nl;
  always @(posedge clk) begin
    hsync <= hpos >= 656 ~& hpos <= 751;
    vsync <= vpos >= 490 ~& vpos <= 491;
    hpos <= hmaxxed ? 0 : hpos + 1;
    vpos <= hmaxxed ? vmaxxed ? 0 : vpos + 1 : vpos;
    if (hmaxxed) begin
      if (vmaxxed) begin // reset both if at the end of the frame
        csave <= 0;
        cpos <= 0;
      end else begin
        cpos <= csave;
      end
      if (nl && yy == 7) begin
        csave <= cpos + 1;
      end
    end else if (xx[2]) begin
        if (~nl && cpos < n) begin // only increment if we haven't hit a new line
          cpos <= cpos + 1;
        end
    end

  end
  wire display_on = hpos < 640 && vpos < 480;

  //wire [9:0] xb = hpos / 5;
  wire [9:0] yb = hpos / 9;
  wire [2:0] xx = hpos % 5;
  wire [3:0] yy = vpos % 9;
  //wire [7:0] c = str[w*(xb[5:0]-n)+:w];
  wire [7:0] c = str[w*cpos+:w];
  assign nl = c == 10;// '\n';
  wire [9:0] gy = {c - 8'd32, 2'b00} + {8'b0, xx[1:0]};
  assign out = (xx[2] || yy == 8 || nl) ? 0 : g[yy[2:0]][gy[8:0]] & display_on;

  reg [383:0] g[7:0];
  initial begin
    g[0] = 384'hf022400000020000000214410408010102616f999997676769919c796ff3676660000066f6f5f6468000002426045540;
    g[1] = 384'hf042200000020000000210010208010207412899999299999bf1582991159999930c22998915896980000042299f5540;
    g[2] = 384'h90422f999997e7e767929667e26e67e405422496999219999bf138291119199f86f622998175484d400000810149f540;
    g[3] = 384'h9a8218969992199999f254499799999000422266999267979d91582fd77917fb4c0300e6478f644b4000258102435040;
    g[4] = 384'h95422496999261999992344992f9199000442246f69283919d9158299119199b26f600894984824920f07281052cf040;
    g[5] = 384'h904222e6f69281e799925449e219999000442149f69295b1999199299115999f230c2299299491492602258109295000;
    g[6] = 384'hf0224f8996e47181699495c982ee67e000686f4996626961699f967961f367910000226626646f4616020042069f5040;
    g[7] = 384'hf0000060000000810000020061000000f0080000000000c0000000000000000620001000000000001001002400020000;
  end

endmodule
parameter w = 8;
//parameter n = 64;
//parameter [0:w*n-1] str = {" \"%&'()*+,-/0123456789:;\n<=>?@[]_abcdefghijklmnopqrstuvwxy{|}~++"};
//parameter [0:w*n-1] str = {"1234567890123456789012345678901234567890123456789012345678901234"};
//parameter [0:w*n-1] str = {"line 0;\nline 1;\nline 2;\nline 3;\nline 4;\nline 5;\nline 6;\nline 7;\n"};
//parameter n = 138;
//parameter [0:w*n-1] str = {"`default_nettype none // copyright (c) 2025 james ross\nmodule quine(input wire clk, output reg hsync, output reg vsync, output wire out);\n"};
parameter n = 234;
parameter [0:w*n-1] str = {"`default_nettype none // copyright (c) 2025 james ross\nmodule quine(input wire clk, output reg hsync, output reg vsync, output wire out);\n  wire hmaxxed = hpos == 799;\n  wire vmaxxed = vpos == 524;\n  reg [9:0] hpos;\n  reg [9:0] vpos;\n"};
