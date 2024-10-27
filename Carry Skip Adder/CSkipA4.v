/* (c) Krishna Subramanian <https://github.com/mongrelgem>
 * For Issues & Bugs, report to <https://github.com/mongrelgem/Verilog-Adders/issues>
*/


// Full Adder
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor (w0, a, b);
  xor (sum, w0, cin);
  
  and (w1, w0, cin);
  and (w2, a, b);
  or (cout, w1, w2);
endmodule

// Ripple Carry Adder with cin - 2 bits
module RCA2(output [1:0] sum, output cout, input [1:0] a, b, input cin);
  
  wire [1:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], cin);
  FA fa1(sum[1], cout, a[1], b[1], c[1]);
  
endmodule

module SkipLogic(output cin_next,
  input [1:0] a, b, input cin, cout);
  
  wire p0, p1, P, e;
  wire nP, P1Cout, P0Cout;

  xor (p0, a[0], b[0]);
  xor (p1, a[1], b[1]);
  
  and (P, p0, p1);
  not (nP, P);
  and (P1Cout, P, cin);
  and (P0Cout, nP, cout);
  
  or (cin_next, P1Cout, P0Cout);

endmodule

// Carry Skip Adder - 4 bits
module CSkipA4(output [3:0] sum, output cout, input [3:0] a, b);
  
  wire cout0, cout1, e;
  
  RCA2 rca0(sum[1:0], cout0, a[1:0], b[1:0], 0);
  RCA2 rca1(sum[3:2], cout1, a[3:2], b[3:2], e);
  
  SkipLogic skip0(e, a[1:0], b[1:0], 1'b0, cout0);
  SkipLogic skip1(cout, a[3:2], b[3:2], e, cout1);
  
endmodule