Błąd polega na nie dopisaniu wartości else dla o, tzn. powinno być :
module dec2to4(input [1:0] i, output [3:0] o);
  integer k;
  always_comb begin
    for (k = 0; k <= 3; k = k + 1) begin
        if (i == k)
          o[k] = 1'b1;
  		else
    	  o[k] = 1'b0;
  end
 end
endmodule
