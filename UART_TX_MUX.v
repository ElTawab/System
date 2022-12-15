module MUX #(parameter start_bit=0 , stop_bit=1) (
  input wire RST,
  input wire CLK,
  input wire [1:0] SEL,
  input wire PAR,
  input wire S_DATA,
  output reg TX_OUT
  );
always @ (posedge CLK or negedge RST)
begin
  if(!RST)
    TX_OUT<='b1;
  else
    begin
  case (SEL)
    'b00:TX_OUT<=start_bit;
    'b01:TX_OUT<=stop_bit;
    'b10:TX_OUT<=S_DATA;
    'b11:TX_OUT<=PAR;
  endcase
  end
  
end

endmodule