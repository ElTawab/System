module par_chk(
  input wire CLK,
  input wire RST,
  input wire parity_type,
  input wire S_DATA,
  input wire Enable,
  input wire parity_bit,
  input wire Enable_par,
  output reg par_err
  );
  reg par;
  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
      par_err<='b0;
      par<='b0;
    end
    else
      begin
        if(Enable)
          begin
      if(parity_type=='b0)
        par <= par ^ S_DATA;
      else
        par <= par ~^ S_DATA;
       end
       if(Enable_par)
        begin
          if(parity_bit == par)
            par_err='b0;
          else
            par_err='b1;
        end
      end
    end
endmodule
  
