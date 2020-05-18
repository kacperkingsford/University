module zad2lista5(input [15:0] i, output [15:0] o);
  integer a,b;
  logic [3:0] pom; // sortowanie bąbelkowe
  always_comb begin
    o = i;
    for (a = 3; a > -1; a = a - 1) begin
      for (b = 0; b < a; b = b + 1) begin
        if (o[4*(b+1) + 3 : 4*(b+1)] < o[4*b + 3: 4*b]) begin
              pom = o[4*b + 3: 4*b];
              o[4*b + 3: 4*b] = o[4*(b+1) + 3 : 4*(b+1)];
          o[4*(b+1) + 3 : 4*(b+1)] = pom;
            end
      end
    end
  end
endmodule

