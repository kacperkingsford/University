module funnelShifter(input [7:0] a, b, input [3:0] n, output [7:0] o); 
  logic [15:0] con;
  assign con = {a, b};
  assign o = con >> n;
endmodule

module zad2lista4(input [7:0] i, input [3:0] n, input ar, lr, rot, output [7:0] o);
  logic [7:0]a, b, poma;
  logic [3:0] newn;
  assign newn = lr ? (4'b1000 - n) : n;
  assign b = lr && !rot ? 8'b0 : i;
  assign poma = i[7] ? 8'b11111111 : 8'b0;
  assign a = rot || lr ? i : ( ar ? poma : 8'b0 );

  funnelShifter f1(a, b, newn, o);
endmodule
