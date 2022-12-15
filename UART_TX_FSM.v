module FSM #(parameter Idle=2'b00 ,transm=2'b01 , par=2'b10, stop=2'b11) (
  input wire RST,
  input wire DATA_VALID,
  input wire ser_done,
  input wire CLK,
  input wire PAR_EN,
  output reg ser_en,
  output reg busy,
  output reg [1:0] mux_sel
  );
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg busy_c;
always @ (posedge CLK or negedge  RST)
begin
  if (!RST)
    begin
      current_state <= Idle;
      busy <='b0;
      mux_sel <='d1;
      ser_en<='d1;
    end
    else
      begin
        current_state <= next_state;
     end
   end
   always @ (*)
   begin
    case (current_state)
          Idle:begin
            if(DATA_VALID )
              next_state=transm;
              else
                next_state=Idle;
            end
            
          transm:begin
            if(ser_done)
              if(PAR_EN)
              next_state=par;
              else
                next_state=stop;
                else
                next_state=transm;
            end
            
            par: begin
              next_state=stop;
              end
              
              stop: begin
                      if(DATA_VALID)
                        begin
                          next_state = transm;
                        end
                      else
                        begin
                         next_state = Idle ;
                        end
                  end 
              
            endcase
   end
   
   
always @ (*)
begin
        case (current_state)
          Idle:begin
            if(DATA_VALID)
              begin
              busy_c='b1;

              mux_sel='d0;
              ser_en='b1;
            end
              else
                begin
              busy_c='b0;
              mux_sel='d1;
              ser_en='b0;
            end
            end
            
          transm:begin
            if(ser_done)
              begin
              if(PAR_EN)
                begin
              busy_c='b1;
              mux_sel='d3;
              ser_en='b0;
            end
              else
                begin
                busy_c='b1;
              mux_sel='d1;
              ser_en='b0;
            end
          end
                else
                  begin
                busy_c='b1;
              mux_sel='d2;
              ser_en='b1;
            end
            end
            
            par: begin
              busy_c='b1;
              mux_sel='d1;
              ser_en='b0;
              end
              
              stop:  begin
                     if(DATA_VALID)
                       begin
                     mux_sel = 2'b00 ;
                     busy_c = 1'b1 ;
                     ser_en = 1'b1 ;
                       end
                     else
                       begin
                     mux_sel = 2'b01 ;
                     busy_c = 1'b0 ;
                     ser_en = 1'b0 ;
                       end
                    end 
            endcase
            
        end
        
            
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_c ;
   end
 end
endmodule

