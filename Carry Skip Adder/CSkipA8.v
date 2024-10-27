// Full Adder
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor  (w0, a, b);
  xor  (sum, w0, cin);
  
  and  (w1, w0, cin);
  and  (w2, a, b);
  or  (cout, w1, w2);
endmodule


// Ripple Carry Adder with cin - 4 bits
module RCA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);
  
  wire [3:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], cin);
  FA fa[2:1](sum[2:1], c[3:2], a[2:1], b[2:1], c[2:1]);
  FA fa3(sum[3], cout, a[3], b[3], c[3]);
  
endmodule

module SkipLogic(output cin_next,
  input [3:0] a, b, input cin, cout);
  
  wire p0, p1, p2, p3, P, e;
  wire nP, P1Cout, P0Cout;

  xor (p0, a[0], b[0]);
  xor (p1, a[1], b[1]);
  xor (p2, a[2], b[2]);
  xor (p3, a[3], b[3]);
  
  and (P, p0, p1, p2, p3);
  not (nP, P);
  and (P1Cout, P, cin);
  and (P0Cout, nP, cout);
  
  or (cin_next, P1Cout, P0Cout);

endmodule

// Carry Skip Adder - 8 bits
module CSkipA8(output [7:0] sum, output cout, input [7:0] a, b);
  
  wire cout0, cout1, e;
  
  RCA4 rca0(sum[3:0], cout0, a[3:0], b[3:0], 1'b0);
  RCA4 rca1(sum[7:4], cout1, a[7:4], b[7:4], e);
  
  SkipLogic skip0(e, a[3:0], b[3:0], 1'b0, cout0);
  SkipLogic skip1(cout, a[7:4], b[7:4], e, cout1);
  
endmodule