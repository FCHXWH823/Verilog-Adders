
// Full Adder
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor  (w0, a, b);
  xor  (sum, w0, cin);
  
  and  (w1, w0, cin);
  and  (w2, a, b);
  or  (cout, w1, w2);
endmodule


// Ripple Carry Adder with cin - 2 bits
module RCA2(output [1:0] sum, output cout, input [1:0] a, b, input cin);
  
  wire [1:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], cin);
  FA fa1(sum[1], cout, a[1], b[1], c[1]);
  
endmodule

module MUX2to1_w1(output y, input i0, i1, s);

  wire e0, e1;
  wire sn;
  not (sn, s);
  
  and (e0, i0, sn);
  and (e1, i1, s);
  
  or (y, e0, e1);
  
endmodule

module MUX2to1_w2(output [1:0] y, input [1:0] i0, i1, input s);

  wire [1:0] e0, e1;
  wire sn;
  not (sn, s);
  
  and (e0[0], i0[0], sn);
  and (e0[1], i0[1], sn);
      
  and (e1[0], i1[0], s);
  and (e1[1], i1[1], s);
  
  or (y[0], e0[0], e1[0]);
  or (y[1], e0[1], e1[1]);
  
endmodule

// Carry Select Adder - 8 bits
module CSA4(output [3:0] sum, output cout, input [3:0] a, b);

  wire [3:0] sum0, sum1;
  wire c1;
  wire cout0_0, cout0_1;
  wire cout1_0, cout1_1;
  RCA2 rca0_0(sum0[1:0], cout0_0, a[1:0], b[1:0], 1'b0);
  RCA2 rca0_1(sum1[1:0], cout0_1, a[1:0], b[1:0], 1'b1);
  MUX2to1_w2 mux0_sum(sum[1:0], sum0[1:0], sum1[1:0], 1'b0);
  MUX2to1_w1 mux0_cout(c1, cout0_0, cout0_1, 1'b0);

  RCA2 rca1_0(sum0[3:2], cout1_0, a[3:2], b[3:2], 1'b0);
  RCA2 rca1_1(sum1[3:2], cout1_1, a[3:2], b[3:2], 1'b1);
  MUX2to1_w2 mux1_sum(sum[3:2], sum0[3:2], sum1[3:2], c1);
  MUX2to1_w1 mux1_cout(cout, cout1_0, cout1_1, c1);
  
endmodule