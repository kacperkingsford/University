module zadlista7(input clk, input [15:0] d, input [1:0] sel, output [15:0] cnt, cmp, top, output out);

  always_ff @(posedge clk)
    if((cnt >= cmp - 1'b1) | (cmp == 0)) out <= 1'b0;
    else if (((cnt <= cmp) || (cnt == top)) && (cmp != 0)) out <= 1'b1;
  
  always_ff @(posedge clk)
    if(sel == 2'b11) cnt <= d;
    else if(cnt >= top) cnt <= 1'b0;
  	else cnt <= cnt + 1'b1;
  
  always_ff @(posedge clk)
    if(sel == 2'b10) top <= d;
    else if(sel == 2'b01) cmp <= d;
 
endmodule

