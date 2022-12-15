module data_sampling # ( parameter PRESCALE_WIDTH = 5 )(
  input wire CLK,
  input wire RST,
  input wire S_DATA,
  input wire Enable,
  input wire [PRESCALE_WIDTH-1:0] prescale ,
  input wire parity_enable,
  input wire [3:0] edge_count,
  input wire [3:0] bit_count,
  output reg  parity_bit,
  output reg stop_bit,
  output reg [7:0] P_DATA
  );
reg [7:0] temp;
reg [1:0] one_counter;
always @ (posedge CLK or negedge RST)
begin
if(!RST) 
begin
P_DATA <= 'd0;
parity_bit <= 'b0;
stop_bit <= 'b0;
one_counter <= 'b0;
end
else
begin
if(Enable)
  begin
    if (edge_count=='d1)
      one_counter<='d0;
    if(edge_count==((prescale/2)-1) | edge_count==(prescale/2) | edge_count==((prescale/2)+1))
      begin
        if(S_DATA == 'b1)
          one_counter <= one_counter+'b1;
         if(one_counter == 'd2 | one_counter=='d3)
           begin
           if(bit_count<'d9)
         temp[bit_count-1]<='b1;
       end
       else
         if(bit_count<'d9)
       temp[bit_count-1]<='b0;
      end
  end
end 
end

always@ (posedge CLK)
begin
  if(parity_enable)
    begin
      if(bit_count=='d9 & edge_count==(prescale/2))
    parity_bit <= S_DATA;
    if(bit_count == 'd10)
      stop_bit <= S_DATA;
  end
  else
    begin
      if(bit_count=='d9 & edge_count==(prescale/2))
        stop_bit <= S_DATA;
      end
end


always @ (posedge CLK)
begin
  if(bit_count=='d8 && Enable)
    P_DATA <= temp;
end
endmodule