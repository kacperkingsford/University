module zad2(output o, input [3:0] i);
  logic a,b,c,d,e;
    assign a = i[0] | i[2] | i[3];
      assign b = i[0] | i[1] | i[3];
        assign c = i[1] | i[2] | i[3];
	  assign d = i[0] | i[1] | i[2];
	    assign e = !i[0] | !i[1] | !i[2] | !i[3];
	      assign o = a & b & c & d & e;
	        endmodule
