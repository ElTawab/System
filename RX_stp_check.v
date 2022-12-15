module stp_chk(
  input wire CLK,
  input wire RST,
  input wire Enable,
  input wire stop_bit,
  output reg stp_err
  );

always @(posedge CLK or negedge RST)
begin
  if(!RST)
    stp_err=0;
  else
    begin
      if(Enable)
        begin
          if(stop_bit)
            stp_err='b0;
            else
              stp_err='b1;
          end
      end
end
endmodule