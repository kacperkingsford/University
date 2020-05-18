module zad1lista5(input [7:0] i, input [4:0] pick, output [9:0] o);
  assign o = pick[1] ? i : pick[2] ? i << 1 : pick[3] ? (i << 1) + i : i << 2;
endmodule

Założyłem, że wejście jest Onehot.
