module zadlista9 (input clk, nrst, door, start, finish, output heat, light, bell);
  
  logic [4:0] s; // 00001 = stan closed, 00010 = stan cook, 00100 = stan pause, 01000 = stan bell , 10000 = stan open
  
  always_ff @(posedge clk or negedge nrst) begin
    if(!nrst)
      s <= 5'b00001; //stan początkowy (closed)
    else begin
      if(s[0]) begin //stan closed
        if(door)
          s <= 5'b10000;
        if(start && !door)
          s <= 5'b00010;
      end
      if(s[1]) begin //stan cook
        if(door)
          s <= 5'b00100;
        if(finish && !door)
          s <= 5'b01000;
      end
      if(s[2]) begin //stan pause
        if(!door)
          s <= 5'b00010;
      end
      if(s[3]) begin //stan bell
        if(door)
          s <= 5'b10000;
      end
      if(s[4]) begin //stan open
        if(!door)
          s <= 5'b00001;
      end
    end
  end
  
  assign light = s[1] || s[2] || s[4];
  assign bell = s[3];
  assign heat = s[1];
         
endmodule
