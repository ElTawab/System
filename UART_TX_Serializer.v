module Serializer (
  input wire [7:0] IN_serializer,
  input wire CLK,
  input wire RST,
  input wire EN,
  output reg OUT_serializer,
  output reg ser_done
  );
  
  reg [3:0] counter;
  
  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
       OUT_serializer='b1;
       ser_done='b0;
       counter='d0;
      end
    else
      begin
       if(EN)
      begin
    if(counter!=8)
      begin
        ser_done <= 'b0;
        case (counter)
        'd0:OUT_serializer<=IN_serializer[0];
        'd1:OUT_serializer<=IN_serializer[1];
        'd2:OUT_serializer<=IN_serializer[2];
        'd3:OUT_serializer<=IN_serializer[3];
        'd4:OUT_serializer<=IN_serializer[4];
        'd5:OUT_serializer<=IN_serializer[5];
        'd6:OUT_serializer<=IN_serializer[6];
        'd7:OUT_serializer<=IN_serializer[7];
      endcase
      counter<=counter+1;
      end
    else
      begin
        counter<='d0;
        ser_done<='b1;
        OUT_serializer<='b1;
      end
    end
  else
    begin
    ser_done <='b0;
    OUT_serializer<= 1;
  end
end
  end
  
  
   
endmodule
