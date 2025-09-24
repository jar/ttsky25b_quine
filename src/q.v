//2345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
`default_nettype none
module q(input wire k, output reg u, output reg v, output wire p);
  wire w = x == 799;
  wire h = y == 524;
  reg [9:0] x;
  reg [9:0] y;
  reg [$clog2(n)-1:0] cpos;
  reg [$clog2(n)-1:0] csave;
  wire nl;
  always @(posedge k) begin
    u <= x >= 656 ~& x <= 751;
    v <= y >= 490 ~& y <= 491;
    x <= w ? 0 : x + 1;
    y <= w ? h ? 0 : y + 1 : y;
    if (w) begin
      if (h) begin // reset both if at the end of the frame
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
  wire display_on = x < 640 && y < 480;

  //wire [9:0] xb = x / 5;
  wire [9:0] yb = x / 9;
  wire [2:0] xx = x % 5;
  wire [3:0] yy = y % 9;
  //wire [7:0] c = str[w*(xb[5:0]-n)+:b];
  wire [7:0] c = str[b*cpos+:b];
  assign nl = c == 88; // XXX using "X" in place of newline character
  wire [9:0] gy = {c - 8'd32, 2'b00} + {8'b0, xx[1:0]};
  assign p = (xx[2] || yy == 8 || nl) ? 0 : g[384*yy[2:0]+gy[8:0]] & display_on;

  reg [3071:0] g;
  initial begin
    g = 3072'hf0000060000000810000020061000000f0080000000000c0000000000000000620001000000000001001001800020000f0224f8996e47181699495c982ee67e000686f4996626961699f967961f367910000226626646f4616020024069f5040904222e6f69281e799925449e219999000442149f69295b1999199299115999f230c229929949149260225420929500095422496999261999992344992f9199000442246f69283919d9158299119199b26f600894984824920f07242052cf0409a8218969992199999f254499799999000422266999267979d91582fd77917fb4c0300e6478f644b400025420243504090422f999997e7e767929667e26e67e405422496999219999bf138291119199f86f622998175484d400000420149f540f042200000020000000210010208010207412899999299999bf1582991159999930c22998915896980000024299f5540f022400000020000000214410408010102616f999997676769919c796ff3676660000066f6f5f6468000001826045540;
  end

parameter b = 8;
parameter n = 161;
parameter [0:b*n-1] str = {"`default_nettype noneXmodule q(input wire k, output reg u, output reg v, output wire p);X  wire w = x == 799;X  wire h = y == 524;X  reg [9:0] x;X  reg [9:0] y;X"};

endmodule
