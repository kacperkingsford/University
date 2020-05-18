module zad2lista5(input [31:0] i, output [31:0] o);
  //konwersje wykonuje według algorytmu który znalazłem na wikipedii:
  //1.przyjmij pierwszą (najbardziej znaczącą) cyfrę kodu naturalnego równą pierwszej cyfrze kodu Graya
  //2.każdą kolejną cyfrę oblicz jako różnicę symetryczną (XOR) odpowiedniej cyfry kodu Graya i poprzednio wyznaczonej cyfry kodu naturalnego.
  logic pom;
  integer iter;
  always_comb begin
    o[31] = i[31];
    pom = o[31];
    for(iter = 30; iter > -1; iter = iter - 1) begin
      o[iter] = pom ^ i[iter];
      pom = o[iter];
    end
  end
endmodule


