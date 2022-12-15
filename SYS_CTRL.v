module SYS_CTRL #(parameter Addr = 4 , ALU_FUNw = 4 , ALU_D =8 , Idle='d0 ,RX_RF_A2='d6,RX_RF_R='d7, RX_RF_W='d1 ,RX_RF_A = 'd2  ,OP_A='d3, OP_B='d4, ALU_F='d5 ,ALU_h='d7,ALU_h2='d8, TX_Reg='d1, TX_ALU='d2 , TX_ALU2= 'd3, TX_ALU_h='d4 )
(
input wire RST,
input wire CLK,
input wire OUT_Valid,
input wire [ (2*ALU_D)-1:0] ALU_OUT,
input wire [ ALU_D-1:0] RdData,
input wire [ ALU_D-1:0] RX_P_DATA,
input wire RX_D_VLD,
input wire Busy,
input wire RdData_Valid,

output reg [ ALU_D-1:0] TX_P_DATA,
output reg [ ALU_D-1:0] WrData,
output reg [ Addr-1:0] Address,
output reg [ ALU_FUNw-1:0] ALU_FUN,
output reg  EN,
output reg  Gate_EN,
output reg  WrEN,
output reg  RdEN,
output reg  TX_D_VLD,
output wire  clk_div_en
  );
  
  reg [3:0] current_state_T;
  reg [3:0] next_state_T;
  reg [3:0] current_state_R;
  reg [3:0] next_state_R;
  reg [3:0] addr_reg;
  reg func;

    always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        TX_P_DATA <= 'd0;
        WrData <= 'd0;
        EN <= 'd0;
        Address <= 'd0;
        ALU_FUN <= 'd0;
        Gate_EN <= 'd0;
        WrEN <= 'd0;
        RdEN <= 'd0;
        TX_D_VLD <= 'd0;
        current_state_R<=Idle;
        current_state_T<=Idle;
      end
    else
      begin
          current_state_R <= next_state_R;
		  current_state_T <= next_state_T;
      end
  end
  
  always @(*)
  begin
    
        case (current_state_R)
          Idle:begin
            if(RX_D_VLD == 'b1)
              begin
              case (RX_P_DATA)
              'b10101010 : begin 
			 next_state_R = RX_RF_A;
			  
			  end
              'b10111011 : begin 
			  next_state_R = RX_RF_A2;
			  end
              'b11001100 : next_state_R = OP_A;
              'b11011101 : next_state_R =ALU_F;
              default : next_state_R =Idle;
              endcase
			  end
			  else
			  next_state_R =Idle;
            end
			RX_RF_A :begin
			 if(RX_D_VLD == 'b1)
			  begin
			  next_state_R = RX_RF_W;
			  end
			else
			next_state_R = RX_RF_A;
			end
			RX_RF_W :begin
			 if(RX_D_VLD == 'b1)
			next_state_R = Idle;
			else
			next_state_R = RX_RF_W;
			end
			RX_RF_A2 : begin
			  if(RX_D_VLD == 'b1)
			  begin
			  next_state_R = RX_RF_R;
			  end
			else
			next_state_R = RX_RF_A2;
			  end
			  RX_RF_R :begin
			 if(RdData_Valid == 'b1)
			next_state_R = Idle;
			else
			next_state_R = RX_RF_R;
			end
		    OP_A : begin
			if(RX_D_VLD == 'b1)
			next_state_R = OP_B;
			else
			next_state_R = OP_A;
			end
			OP_B : begin
			if(RX_D_VLD == 'b1)
			next_state_R = ALU_F;
			else
			next_state_R = OP_B;
			end
			ALU_F: begin
			if(RX_D_VLD == 'b1)
			next_state_R = ALU_h;
			else
			next_state_R = ALU_F;
			end
			ALU_h:begin
			  if(OUT_Valid)
			  next_state_R=Idle;
			  else
			    next_state_R=ALU_h;
			  end
          endcase
         
  end
  
  always @(*)
  begin
    WrEN = 'b0;
		  RdEN = 'b0;
		  EN = 'b0;
		  Address='d0;
		  ALU_FUN = 'd0;
		  Gate_EN = 'b0;
		  func=0;
  case (current_state_R)
          Idle:begin
		  WrEN = 'b0;
		  RdEN = 'b0;
		  EN = 'b0;
		  ALU_FUN = 'd0;
		  Gate_EN = 'b0;
            end
			RX_RF_A :begin
			  if(RX_D_VLD)
			  addr_reg=RX_P_DATA;
			  else
			    addr_reg=0;
			end
			RX_RF_W :begin
			 Address=addr_reg;
			 if(RX_D_VLD)
			 WrEN = 'b1;
			 WrData=RX_P_DATA;
			 Gate_EN = 'b0;
			end
			RX_RF_A2 :begin
			  if(RX_D_VLD)
			  addr_reg=RX_P_DATA;
			  else
			    addr_reg=0;
			  end
			  RX_RF_R:begin
			    RdEN='b1;
			    Address=addr_reg;
			    end
		    OP_A : begin
			WrEN = 'b1;
			 WrData = RX_P_DATA;
			 Address = 'd0;
			 Gate_EN = 'b0;
			end
			OP_B : begin
			WrEN = 'b1;
			 WrData = RX_P_DATA;
			 Address = 'd1;
			 Gate_EN = 'b0;
			end
			ALU_F : begin
			  Gate_EN = 'b1;
			  if(RX_D_VLD)
			    begin
    ALU_FUN=RX_P_DATA;
    EN='b1;
  end
  else
    begin
    ALU_FUN =0;
    EN=1'b0;
  end
			end
			ALU_h: begin
			  Gate_EN = 'b1;
			  end
			
          endcase
  end
  
  

  
  always @(*)
  begin
  case (current_state_T)
  Idle : begin 
  if(RdData_Valid == 'b1 && OUT_Valid== 'b0)
next_state_T = TX_Reg;
else if (RdData_Valid == 'b0 && OUT_Valid == 'b1)
next_state_T = TX_ALU; 
else 
next_state_T = Idle;
  end
  TX_Reg : begin
  if(!Busy)
    next_state_T = TX_Reg;
  else
   next_state_T = Idle; 
end
  TX_ALU :begin
     if(!Busy)
   next_state_T = TX_ALU;
 else
   next_state_T=TX_ALU_h;
 end
  TX_ALU2 :begin
     if(!Busy)
       next_state_T=TX_ALU2;
    else
     next_state_T = Idle; 
 end
 TX_ALU_h :begin
     if(!Busy)
      next_state_T = TX_ALU2;
    else
      next_state_T=TX_ALU_h;
 end
 
  endcase
end


  always @(*)
  begin
  
  case (current_state_T)
  Idle : begin 
  TX_P_DATA = 'd0;
  TX_D_VLD='b0;
  end
  TX_Reg : begin
  TX_P_DATA = RdData;
  TX_D_VLD =1'b1;
end
  TX_ALU : begin
  TX_P_DATA = ALU_OUT[7:0];
  TX_D_VLD =1'b1;
end
  TX_ALU2 : begin
  TX_P_DATA = ALU_OUT[15:8];
  TX_D_VLD =1'b1;
end
TX_ALU_h : TX_D_VLD=1'b0;
  endcase

end

assign clk_div_en='b1;
endmodule
