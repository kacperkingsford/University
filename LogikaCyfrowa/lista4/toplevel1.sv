module not_or(input a, b, output c);
  assign c = ! (a || b);
endmodule

module zad1lista4(input [3:0] i, input l,r, output [3:0] o);
  logic pom;
  not_or n1(l, r, pom);
  assign o[0] = (l && 1'b0) || (r && i[1]) || (pom && i[0]);
  assign o[1] = (l && i[0]) || (r && i[2]) || (pom && i[1]);
  assign o[2] = (l && i[1]) || (r && i[3]) || (pom && i[2]);
  assign o[3] = (l && i[2]) || (r && 1'b0) || (pom && i[3]);
endmodule
