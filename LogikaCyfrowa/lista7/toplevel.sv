module tff(output q, nq, input t, clk, nrst); // ttf latch z wykladu 
  logic ns, nr, ns1, nr1, j, k;
  nand n1(ns, clk, j), n2(nr, clk, k),
  n3(q, ns, nq), n4(nq, nr, q, nrst),
  n5(ns1, !clk, t, nq), n6(nr1, !clk, t, q),
  n7(j, ns1, k), n8(k, nr1, j, nrst);
endmodule

module zad1lista7(input clk, nrst, step, down, output [3:0] out);
  logic [3:0] nq, t;
  assign t[0] = !step;
  tff t_1(out[0], nq[0], t[0], clk, nrst);
  assign t[1] = step | (!down & out[0]) | (down & !out[0]);
  tff t_2(out[1], nq[1], t[1], clk, nrst);
  assign t[2] = (!down & out[0] & out[1]) | (down & !out[0] & !out[1]) | (step & !down & out[1]) | (step & down & !out[1]);
  tff t_3(out[2], nq[2], t[2], clk, nrst);
  assign t[3] = (!down & out[2] & out[1] & out[0]) | (down & !out[2] & !out[1] & !out[0]) | (step & !down & out[2] & out[1]) | (step & down & !out[1] & !out[2]);
  tff t_4(out[3], nq[3], t[3], clk, nrst);
  
endmodule
