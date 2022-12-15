module uart_rx_fsm 
  (
  input wire CLK,
  input wire RST,
  input wire S_DATA,
  input wire parity_enable,
  input wire [5:0] prescale,
  input wire [3:0] edge_count,
  input wire [3:0] bit_count,
  input wire par_err,
  input wire stp_err,
  output reg edge_bit_en,
  output reg data_samp_en,
  output reg stp_chk_en,
  output reg par_chk_en,
  output reg Enable_par,
  output reg data_valid
  );
localparam Idle='d0,
data='d1,
par='d2,
stp='d3; 

reg [1:0] current_state;
reg[1:0] next_state;
reg edge_bit_en_c;
reg data_sample_en_c;
reg stp_chk_en_c;
reg par_chk_en_c;
reg data_valid_c;


always@(posedge CLK or negedge RST)
begin
  if(!RST)
    begin
      current_state<=Idle;
      edge_bit_en <= 0;
      data_samp_en <= 0;
      stp_chk_en <= 0;
      par_chk_en <= 0;
      data_valid <= 0;
    end
    
  else 
    begin
      
      current_state<=next_state;
      data_samp_en <= data_sample_en_c;
      edge_bit_en<= edge_bit_en_c;
      //stp_chk_en <= stp_chk_en_c;
      //par_chk_en <= par_chk_en_c;
      data_valid <= data_valid_c;
    
    end
  end
  
  always @(*)
  begin
  case (current_state)
  Idle:begin
  if(S_DATA==0 & !stp_err & !par_err)
    next_state=data;
  else
    next_state=Idle;
end  
data:begin
  if(bit_count=='d10)
    begin
      if(parity_enable)
        next_state=par;
      else
       next_state=stp; 
    end
end
par:begin
  next_state=stp;
end
stp:begin
  next_state=Idle;
end
endcase
  end
  
  
  always @(*)
  begin
  case (current_state)
  Idle:begin
    edge_bit_en_c='b0;
    data_sample_en_c='b0;
    stp_chk_en='b0;
    par_chk_en='b0;
    data_valid_c='b0;
  if(S_DATA==0)
    begin
  edge_bit_en_c='b1;
  data_sample_en_c='b1;
  par_chk_en='b0;
end    
end  
data:begin
  edge_bit_en_c='b1;
    data_sample_en_c='b1;
    stp_chk_en='b0;
    par_chk_en='b0;
    data_valid_c='b0;
      if(parity_enable)
        begin
        stp_chk_en='b0;
        if(bit_count>'d0 & bit_count < 'd9 & edge_count == 'd1)
        par_chk_en='b1;
      else
        par_chk_en='b0;
      end
      else
        begin
        if(bit_count=='d10)
       stp_chk_en='b1; 
     else
       stp_chk_en='b0;
       end 
end
par:begin
  edge_bit_en_c='b1;
    data_sample_en_c='b1;
    stp_chk_en='b1;
    par_chk_en='b0;
    data_valid_c='b0;
end
stp:begin
  edge_bit_en='b0;
    data_sample_en_c='b0;
    stp_chk_en='b1;
    par_chk_en='b0;
    if (parity_enable)
      begin
    if(!par_err & !stp_err)
    data_valid_c='b1;
  end
  else
    begin
    if(!stp_err)
    data_valid_c='b1;
  end
    
end
endcase
  end
  
  always @(posedge CLK)
  begin
    if(bit_count=='d10)
      Enable_par='b1;
    else
      Enable_par='b0;
  end
  

  
endmodule