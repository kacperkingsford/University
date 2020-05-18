module dff(output q, nq, input clk, d); // implementacja d latch z wykladu
	logic r, s, nr, ns;
	nand gq(q, nr, nq), gnq(nq, ns, q),
  	gr(nr, clk, r), gs(ns, nr, clk, s),
	gr1(r, nr, s), gs1(s, ns, d);
endmodule

module m4to1(input i0, i1, i2, i3, l, r, output o);
  assign o = (l & r) ? i3 : (r ? i1 : (l ? i2 : i0)); //multiplekser4do1
endmodule

module zad1lista6(input [7:0] d, input i, c, l, r, output [7:0] q);
  
  logic pom1;
  m4to1 m1(q[0], i, q[1], d[0], l, r, pom1);
  logic nq1;
  dff d1(q[0], nq1, c, pom1);
  
  logic pom2;
  m4to1 m2(q[1], q[0], q[2], d[1], l, r, pom2);
  logic nq2;
  dff d2(q[1], nq2, c, pom2);
  
  logic pom3;
  m4to1 m3(q[2], q[1], q[3], d[2], l, r, pom3);
  logic nq3;
  dff d3(q[2], nq3, c, pom3);
  
  logic pom4;
  m4to1 m4(q[3], q[2], q[4], d[3], l, r, pom4);
  logic nq4;
  dff d4(q[3], nq4, c, pom4);
  
  logic pom5;
  m4to1 m5(q[4], q[3], q[5], d[4], l, r, pom5);
  logic nq5;
  dff d5(q[4], nq5, c, pom5);
  
  logic pom6;
  m4to1 m6(q[5], q[4], q[6], d[5], l, r, pom6);
  logic nq6;
  dff d6(q[5], nq6, c, pom6);
  
  logic pom7;
  m4to1 m7(q[6], q[5], q[7], d[6], l, r, pom7);
  logic nq7;
  dff d7(q[6], nq7, c, pom7);
  
  logic pom8;
  m4to1 m8(q[7], q[6], i, d[7], l, r, pom8);
  logic nq8;
  dff d8(q[7], nq8, c, pom8);
  
endmodule
