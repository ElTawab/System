`timescale 1ns/100ps
module UART_Tx_TB ();
  //clock period
  parameter CLK_cyc = 5;
  parameter CLK_per = 2.5;
 reg CLK_TB ;
 reg RST_TB ;
 reg DATA_VALID_TB ;
 reg [7:0] P_DATA_TB ;
 reg parity_type_TB;
 reg parity_enable_TB;
 wire TX_OUT_TB ;
 wire Busy_TB;
 
 task assign_inputs;
    input rst , valid;
    input [7:0]
    P_DATA1;
    begin
      RST_TB = rst;
      DATA_VALID_TB = valid;
      P_DATA_TB = P_DATA1;
    end
  endtask
  
  task func;
        integer I;
    begin
      assign_inputs('b1,'b1,'b11010010);
      parity_enable_TB='b1;
      parity_type_TB='b1;
      #CLK_cyc
      assign_inputs('b1,'b0,'b11010010);
      //#(7*CLK_cyc)
      //#CLK_cyc
      //ssign_inputs('b0,'b1,'b11010010);
      //#CLK_cyc
      //assign_inputs('b1,'b0,'b11010010);
      #(9*CLK_cyc)
      #CLK_cyc
      assign_inputs('b1,'b1,'b01011011);
      parity_enable_TB='b1;
      parity_type_TB='b1;
      #CLK_cyc
      assign_inputs('b1,'b0,'b01011011);
     
    end
  endtask
  
  initial
  begin
    $dumpfile("UART_TX.vcd");
    $dumpvars;
    CLK_TB=1;
    RST_TB=0;
    #CLK_cyc
    func;
    #(8*CLK_cyc);
    
  end
  
  always #CLK_per CLK_TB = ~CLK_TB;
  
  UART_TX DUT(
  .CLK(CLK_TB),
  .RST(RST_TB),
  .Data_Valid(DATA_VALID_TB),
  .P_DATA(P_DATA_TB),
  .TX_OUT(TX_OUT_TB),
  .parity_type(parity_type_TB),
  .parity_enable(parity_enable_TB),
  .busy(Busy_TB)
  );
  
endmodule
 
