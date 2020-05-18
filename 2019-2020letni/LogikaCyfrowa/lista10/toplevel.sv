module zadlista10(input nrst, step, input [15:0] d, input push, input [1:0] op, output [15:0] out, output [9:0] cnt);
  logic [15:0] mem [0:1023];
  
  always_ff @(posedge step)
    begin
      if(push)
        mem [cnt] <= d;
      else if(op == 1) 
        mem [cnt - 1] <= - mem [cnt - 1];
      else if(op == 2) 
        mem [cnt - 2] <= mem [cnt - 1] + mem [cnt - 2];
      else if(op == 3)
        mem [cnt - 2] <= mem [cnt - 1] * mem [cnt - 2];
    end
  
  always_ff @(posedge step)
    begin
      if(!nrst) 
        out <= 0;
      else if(push)
        out <= d;
      else if(op == 1)
        out <= - mem [cnt - 1];
      else if(op == 2) 
        out <= mem [cnt - 1] + mem [cnt - 2];
      else if(op == 3)
       out <= mem [cnt - 1] * mem [cnt - 2];
      else
        out <= mem [cnt - 1];
    end
  
  always_ff @(posedge step or negedge nrst)
    begin
      if(!nrst) 
        cnt <= 0;
      else if(push)
        cnt <= cnt + 1;
      else if((op == 2 || op == 3) && cnt > 0)
        cnt <= cnt - 1;
    end
endmodule
