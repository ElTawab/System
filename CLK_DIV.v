module CLK_DIV #( 
 parameter RATIO_WD = 4 
)
  (
  input wire i_ref_clk,
  input wire i_rst_n,
  input wire i_clk_en,
  input wire [RATIO_WD-1:0] i_div_ratio,
  output wire o_div_clk
  );
  
  reg [RATIO_WD-1:0] counter;
  reg even_c ;
  reg div_clk;
  wire [RATIO_WD-1:0] h_count; 
  
  always @(posedge i_ref_clk or negedge i_rst_n)
  begin
    if(!i_rst_n)
      begin
        div_clk <= 1'b0;
        counter <= 1'b0;
      end
    else
     begin
      if(counter== 'd0)
        begin
        div_clk<=1;
        counter <= counter +1'b1;
      end
      else if(counter ==h_count)
        begin
       div_clk <= ~div_clk;
       counter <= counter +'d1;
     end
   else if(counter == i_div_ratio)
     begin
      div_clk <= ~div_clk;
      counter <= 'd1; 
     end
   else
     counter <= counter +1'b1;
     end
     
  end
  
  
  
 assign o_div_clk = i_clk_en ? div_clk : i_ref_clk;
 assign h_count = (i_div_ratio >> 1);
 endmodule
