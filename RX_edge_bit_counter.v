module edge_bit_counter # ( parameter PRESCALE_WIDTH = 5 )
(
  input wire CLK,
  input wire RST,
  input wire Enable,
  input wire [PRESCALE_WIDTH-1:0]   prescale,
  input wire parity_enable,
  output reg [3:0] bit_count,
  output reg [3:0] edge_count
  );
  
  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        bit_count <= 'd0;
        edge_count <= 'd0;
      end
    else
      begin
        if(Enable)
          begin
        if(edge_count == prescale)
          begin
            edge_count<='d1;
            bit_count<=bit_count+'d1;
          end
          
        else
        edge_count<=edge_count+'d1;
        
        if(bit_count == 'd10)
          begin
            bit_count<='d0;
            edge_count <='d0;
          end
          
        end
        
        else
          begin
          bit_count<='d0;
          edge_count<='d1;
        end
        
      end
  end
  
endmodule
