module REG
 (

    input  wire WrEN,
    input  wire RdEN,
    input  wire RST,
    input  wire clk,
    input  wire  [3:0] Address,
    input  wire  [7:0] WrData,  
    output reg   [7:0] RdData,
    output   reg   RdData_VLD,
    output   wire   [7:0]  REG0,
    output   wire   [7:0]  REG1,
    output   wire   [7:0]  REG2,
    output   wire   [7:0]  REG3

);

    reg [15:0] memory [7:0];        

    always @(posedge clk or negedge RST) 
	  begin
	    if(!RST)
	      begin
	        RdData_VLD <= 1'b0 ;
	        RdData     <= 1'b0 ;
	        memory [0] <= 8'd0;
	        memory [1] <= 8'd0;
	        memory [2] <= 'b001000_01 ;
	        memory [3] <= 'b0000_1000 ;
	        memory [4] <= 8'd0;
	        memory [5] <= 8'd0;
	        memory [6] <= 8'd0;
	        memory [7] <= 8'd0;
	        end
	        else
	          begin
      if(WrEN && !RdEN) 
		  begin
            memory[Address] <= WrData;
		  end
		else if (RdEN && !WrEN)
          begin
            RdData <= memory[Address]; 
            RdData_VLD <= 1'b1 ;
          end
        else
          RdData_VLD <= 1'b0 ;
        end
       end
assign REG0 = memory[0] ;
assign REG1 = memory[1] ;
assign REG2 = memory[2] ;
assign REG3 = memory[3] ;
endmodule

