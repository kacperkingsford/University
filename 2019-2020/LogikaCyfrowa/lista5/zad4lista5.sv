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

module zad4lista5(input [2:0] a, output [7:0] o);
  logic [3:0] p1,p2;
  logic [1:0] pom1,pom2;
  assign pom1 = {a[1],a[0]};
  assign pom2 = {a[2],a[1]};
  dec2to4 d1(pom1, p1);
  dec2to4 d2(pom2, p2);
  assign o[7] = p1[3] & p2[3];
  assign o[6] = p1[2] & p2[3];
  assign o[5] = p1[1] & p2[2];
  assign o[4] = p1[0] & p2[2];
  assign o[3] = p1[3] & p2[1];
  assign o[2] = p1[2] & p2[1];
  assign o[1] = p1[1] & p2[0];
  assign o[0] = p1[0] & p2[0];
endmodule

