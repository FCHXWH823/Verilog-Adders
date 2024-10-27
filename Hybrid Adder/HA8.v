
module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or (G, e, Gi);
  and (P, Pi, PiPrev);
endmodule

module GrayCircle(output G, input Gi, Pi, GiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or (G, e, Gi);
endmodule

module SmallCircle(output Ci, input Gi);
  buf (Ci, Gi);
endmodule

module Square(output G, P, input Ai, Bi);
  and (G, Ai, Bi);
  xor (P, Ai, Bi);
endmodule

module Triangle(output Si, input Pi, CiPrev);
  xor (Si, Pi, CiPrev);
endmodule


module KSA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);

  wire [3:0] c;
  wire [3:0] g, p;
  Square sq[3:0](g, p, a, b);

  wire [6:4] g1, p1;
  BigCircle bc1_4(g1[4], p1[4], g[1], p[1], g[0], p[0]);
  BigCircle bc1_5(g1[5], p1[5], g[2], p[2], g[1], p[1]);
  BigCircle bc1_6(g1[6], p1[6], g[3], p[3], g[2], p[2]);

  wire [8:7] g2, p2;
  BigCircle bc2_7(g2[7], p2[7], g1[5], p1[5], g[0], p[0]);
  BigCircle bc2_8(g2[8], p2[8], g1[6], p1[6], g1[4], p1[4]);
  
  GrayCircle bc3_0(c[0], g[0], p[0], cin);
  GrayCircle bc3_1(c[1], g1[4], p1[4], cin);
  GrayCircle bc3_2(c[2], g2[7], p2[7], cin);
  GrayCircle bc3_3(c[3], g2[8], p2[8], cin);

  Triangle tr0(sum[0], p[0], cin);
  Triangle tr1(sum[1], p[1], c[0]);
  Triangle tr2(sum[2], p[2], c[1]);
  Triangle tr3(sum[3], p[3], c[2]);

  buf (cout, c[3]);

endmodule

module CLA4(output [3:0] sum, output cout, input [3:0] a, b);
wire [3:0] g, p, c;
wire [9:0] e;
wire cin;

buf (cin, 0);
Square sq[3:0](g[3:0],p[3:0],a[3:0],b[3:0]);

//c[0]
and (e[0], cin, p[0]);
or (c[0], e[0], g[0]);

//c[1]
and (e[1], cin, p[0], p[1]);
and (e[2], g[0], p[1]);
or (c[1], e[1], e[2], g[1]);

//c[2]
and (e[3], cin, p[0], p[1], p[2]);
and (e[4], g[0], p[1], p[2]);
and (e[5], g[1], p[2]);
or (c[2], e[3], e[4], e[5], g[2]);

//c[3]
and (e[6], cin, p[0], p[1], p[2], p[3]);
and (e[7], g[0], p[1], p[2], p[3]);
and (e[8], g[1], p[2], p[3]);
and (e[9], g[2], p[3]);
or (c[3], e[6], e[7], e[8], e[9], g[3]);

xor (sum[0],p[0],cin);
xor x[3:1](sum[3:1],p[3:1],c[2:0]);
buf (cout, c[3]);

endmodule

module HA8(output [7:0] sum, output cout, input [7:0] a, b);

	CLA4 cla4(sum[3:0], cout_1, a[3:0], b[3:0]);
	KSA4 ksa4(sum[7:4], cout, a[7:4], b[7:4], cout_1);

endmodule