module Parity_calc (
  input wire DATA_VALID,
  input wire CLK,
  input wire [7:0] DATA,
  input wire PAR_Typ,
  input wire RST,
  output reg OUT
  );
 
  
  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      OUT<='b0;
    else
      begin
       if(DATA_VALID)
      if(!PAR_Typ)
        begin
          OUT <= ^DATA;
        end
      else
        OUT <= ~^DATA;
      end
  end
  
endmodule
