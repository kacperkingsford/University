module polsum(input a, b, output o, c);
  assign o = a ^ b;
  assign c = a & b;
endmodule

module pelnysum(input a, b, d, output o, c);
  logic p, c1, c2;
  polsum p1(a, b, p, c1);
  polsum p2(p, d, o, c2);
  assign c = c1 | c2;
endmodule

module ninecomplete(input [3:0]a, input one, output [3:0]o); 
  logic [3:0]a1; logic aa1;
  assign a1 = ~a;
  dodaj_cztery f2(a1, 4'b1010, one, o, aa1);
endmodule

module dodaj_cztery(input [3:0] a, b, input c0, output [3:0] o, output c);
  logic c1,c2,c3;
  pelnysum f1(a[0], b[0], c0, o[0], c1);
  pelnysum f2(a[1], b[1], c1, o[1], c2);
  pelnysum f3(a[2], b[2], c2, o[2], c3);
  pelnysum f4(a[3], b[3], c3, o[3], c);
endmodule

module fixed(input [3:0]x, y, input xx, yy, output [7:0] o);
  logic s1 = ((1'b1 && x[3]) && (x[2] || x[1])) || (1'b1 && xx);
  logic [3:0]newa;
  logic na;
  dodaj_cztery f3(x, 6, 0, newa, na);
  logic [3:0]newa2;
  assign newa2 = ({4{s1}} & newa) | (~{4{s1}} & x);
  logic [3:0]newb1, newb2; logic nb1, nb2;
  dodaj_cztery f4(y, s1, 0, newb1, nb1);
  dodaj_cztery f5(newb1, 6, 0, newb2, nb2);
  logic s2 = ((1'b1 && newb1[3]) && (newb1[2] || newb1[1])) || (1'b1 && yy);
  logic [3:0] newb3;
  assign newb3 = ({4{s2}} & newb2) | (~{4{s2}} & newb1);
  assign o = {newb3, newa2};
endmodule

module bcd(input [7:0]a, b, input sub, output [7:0] o);
  logic [3:0] a1,a2,b1,b2; 
  assign {a2, a1} = a; //konwersja na polbajty
  assign {b2, b1} = b;
  //sprawdzanie czy ninecomplete wymagane
  logic [3:0] fixedb1, fixedb2 , bb1, bb2, bb11;
  ninecomplete g1(b1, 1'b1, bb1);
  ninecomplete g2(b2, 1'b0, bb2); 
  assign fixedb1 = ({4{sub}} & bb1) | (~{4{sub}} & b1);
  assign fixedb2 = ({4{sub}} & bb2) | (~{4{sub}} & b2);
  // dodawanie 
  logic [3:0] x, y;
  logic xx, yy;
  dodaj_cztery f1(a1, fixedb1, 0, x, xx);
  dodaj_cztery f2(a2, fixedb2, 0, y, yy);
  // wykrywanie i naprawa przepełnienia
  fixed f3(x, y, xx, yy, o);
endmodule
