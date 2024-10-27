
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


module KSA8(output [7:0] sum, output cout, input [7:0] a, b);

  wire cin = 1'b0;
  wire [7:0] c;
  wire [7:0] g, p;
  Square sq[7:0](g, p, a, b);

  wire [14:8] g1, p1;
  BigCircle bc1_8(g1[8], p1[8], g[1], p[1], g[0], p[0]);
  BigCircle bc1_9(g1[9], p1[9], g[2], p[2], g[1], p[1]);
  BigCircle bc1_10(g1[10], p1[10], g[3], p[3], g[2], p[2]);
  BigCircle bc1_11(g1[11], p1[11], g[4], p[4], g[3], p[3]);
  BigCircle bc1_12(g1[12], p1[12], g[5], p[5], g[4], p[4]);
  BigCircle bc1_13(g1[13], p1[13], g[6], p[6], g[5], p[5]);
  BigCircle bc1_14(g1[14], p1[14], g[7], p[7], g[6], p[6]);

  wire [20:15] g2, p2;
  BigCircle bc2_15(g2[15], p2[15], g1[9], p1[9], g[0], p[0]);
  BigCircle bc2_16(g2[16], p2[16], g1[10], p1[10], g1[8], p1[8]);
  BigCircle bc2_17(g2[17], p2[17], g1[11], p1[11], g1[9], p1[9]);
  BigCircle bc2_18(g2[18], p2[18], g1[12], p1[12], g1[10], p1[10]);
  BigCircle bc2_19(g2[19], p2[19], g1[13], p1[13], g1[11], p1[11]);
  BigCircle bc2_20(g2[20], p2[20], g1[14], p1[14], g1[12], p1[12]);

  wire [24:21] g3, p3;
  BigCircle bc3_21(g3[21], p3[21], g2[17], p2[17], g[0], p[0]);
  BigCircle bc3_22(g3[22], p3[22], g2[18], p2[18], g1[8], p1[8]);
  BigCircle bc3_23(g3[23], p3[23], g2[19], p2[19], g2[15], p2[15]);
  BigCircle bc3_24(g3[24], p3[24], g2[20], p2[20], g2[16], p2[16]);

  SmallCircle sc0(c[0], g[0]);
  SmallCircle sc1(c[1], g1[8]);
  SmallCircle sc2(c[2], g2[15]);
  SmallCircle sc3(c[3], g2[16]);
  SmallCircle sc4(c[4], g3[21]);
  SmallCircle sc5(c[5], g3[22]);
  SmallCircle sc6(c[6], g3[23]);
  SmallCircle sc7(c[7], g3[24]);
  Triangle tr0(sum[0], p[0], cin);
  Triangle tr1(sum[1], p[1], c[0]);
  Triangle tr2(sum[2], p[2], c[1]);
  Triangle tr3(sum[3], p[3], c[2]);
  Triangle tr4(sum[4], p[4], c[3]);
  Triangle tr5(sum[5], p[5], c[4]);
  Triangle tr6(sum[6], p[6], c[5]);
  Triangle tr7(sum[7], p[7], c[6]);

  buf (cout, c[7]);

endmodule