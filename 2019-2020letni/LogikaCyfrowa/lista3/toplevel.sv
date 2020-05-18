module c_1(input g0, input p0, input c0, output c1);
   assign c1 = g0 | (p0 & c0);
endmodule
module c_2(input g0, input g1, input p0, input p1, input c0, output c2);
   assign c2 = g1 | (g0 & p1) | (p0 & p1 & c0);
endmodule
module c_3(input g0, g1, g2, p0, p1, p2, c0, output c3);
  assign c3 = g2 | (g1 & p2) | (g0 & p1 & p2) | (c0 & p0 & p1 & p2);
endmodule
module sumator(input a, input b, input c, output g, output p, output s);
  assign s = a ^ b ^ c;
  assign p = a | b;
  assign g = a & b;
endmodule
module czworka(input c0, input [3:0] a, b, output G, P, output [3:0] s);
  logic p0,p1,p2,p3,g0,g1,g2,g3,c1,c2,c3;
  sumator gp0(a[0],b[0],c0,g0,p0,s[0]);
  c_1 cc1(g0, p0, c0, c1);
  sumator gp1(a[1],b[1],c1,g1,p1,s[1]);
  c_2 cc2(g0, g1, p0, p1, c0, c2);
  sumator gp2(a[2],b[2],c2,g2,p2,s[2]);
  c_3 cc3(g0, g1, g2, p0, p1, p2, c0, c3);
  sumator gp3(a[3],b[3],c3,g3,p3,s[3]);
  assign G = (g2 & p3) | (g1 & p2 & p3) | g3 | (g0 & p1 & p2 & p3);
  assign P = (p0 & p1 &p2 & p3);
endmodule
module zad2lista3(input [15:0] a, b, output [15:0] o);
  logic [3:0] a0,a1,a2,a3,b0,b1,b2,b3;
  logic P0,P1,P2,P3,G0,G1,G2,G3,c0,X,Y,Z;
  assign {a3,a2,a1,a0} = a;
  assign {b3,b2,b1,b0} = b;
  logic [3:0] s0,s1,s2,s3;
  assign c0 = 0;
  czworka B0(c0,a0,b0,G0,P0,s0);
  c_1 c4(G0, P0, c0, X);
  czworka B1(X,a1,b1,G1,P1,s1);
  c_2 c8(G0, G1, P0, P1, c0, Y);
  czworka B2(Y,a2,b2,G2,P2,s2);
  c_3 c12(G0, G1, G2, P0, P1, P2, c0, Z);
  czworka B3(Z,a3,b3,G3,P3,s3);
  assign o = {s3,s2,s1,s0};
endmodule
