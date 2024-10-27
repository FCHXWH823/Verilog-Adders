
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

module MUX2to1_w1(output y, input i0, i1, s);

  wire e0, e1;
  wire sn;
  not (sn, s);
  
  and (e0, i0, sn);
  and (e1, i1, s);
  
  or (y, e0, e1);
  
endmodule

module MUX2to1_w4(output [3:0] y, input [3:0] i0, i1, input s);

  wire [3:0] e0, e1;
  wire sn;
  not (sn, s);
  
  and (e0[0], i0[0], sn);
  and (e0[1], i0[1], sn);
  and (e0[2], i0[2], sn);
  and (e0[3], i0[3], sn);
      
  and (e1[0], i1[0], s);
  and (e1[1], i1[1], s);
  and (e1[2], i1[2], s);
  and (e1[3], i1[3], s);
  
  or (y[0], e0[0], e1[0]);
  or (y[1], e0[1], e1[1]);
  or (y[2], e0[2], e1[2]);
  or (y[3], e0[3], e1[3]);
  
endmodule

// Carry Select Adder - 8 bits
module CSA8(output [7:0] sum, output cout, input [7:0] a, b);

  wire [7:0] sum0, sum1;
  wire c1;
  wire cout0_0, cout0_1;
  wire cout1_0, cout1_1;
  RCA4 rca0_0(sum0[3:0], cout0_0, a[3:0], b[3:0], 1'b0);
  RCA4 rca0_1(sum1[3:0], cout0_1, a[3:0], b[3:0], 1'b1);
  MUX2to1_w4 mux0_sum(sum[3:0], sum0[3:0], sum1[3:0], 1'b0);
  MUX2to1_w1 mux0_cout(c1, cout0_0, cout0_1, 1'b0);

  RCA4 rca1_0(sum0[7:4], cout1_0, a[7:4], b[7:4], 1'b0);
  RCA4 rca1_1(sum1[7:4], cout1_1, a[7:4], b[7:4], 1'b1);
  MUX2to1_w4 mux1_sum(sum[7:4], sum0[7:4], sum1[7:4], c1);
  MUX2to1_w1 mux1_cout(cout, cout1_0, cout1_1, c1);
  
endmodule