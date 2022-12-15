module BIT_SYNC #(parameter NUM_STAGES=2 , BUS_WIDTH=1) (
  input wire RST,
  input wire CLK,
  input wire [BUS_WIDTH-1:0] ASYNC ,
  output reg [BUS_WIDTH-1:0] SYNC 
  );
  integer I;
  reg [BUS_WIDTH-1:0] stages [NUM_STAGES-1:0];
  always@(posedge CLK or RST)
  begin
  if(!RST)
    begin
       for(I=1;I<NUM_STAGES+1;I=I+1)
    begin
      stages[0]<=0;
      stages[I]<=0;
    end
    SYNC<=0;
  end
  else
  begin
    for(I=0;I<NUM_STAGES;I=I+1)
    begin
      if(I==0)
        stages[0]<=ASYNC;
      else
      stages[I]<=stages[I-1];
    SYNC<=stages[NUM_STAGES-1];
  end
end 
end
endmodule
  
