
module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or (G, e, Gi);
  and (P, Pi, PiPrev);
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


module KSA4(output [3:0] sum, output cout, input [3:0] a, b);

  wire cin = 1'b0;
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

  SmallCircle sc0(c[0], g[0]);
  SmallCircle sc1(c[1], g1[4]);
  SmallCircle sc2(c[2], g2[7]);
  SmallCircle sc3(c[3], g2[8]);
  Triangle tr0(sum[0], p[0], cin);
  Triangle tr1(sum[1], p[1], c[0]);
  Triangle tr2(sum[2], p[2], c[1]);
  Triangle tr3(sum[3], p[3], c[2]);

  buf (cout, c[3]);

endmodule