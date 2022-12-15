module UART_TX 
#(parameter
start_bit = 0 ,
stop_bit = 1
)
(input wire CLK ,
input wire RST ,
input wire Data_Valid ,
input wire [7:0] P_DATA ,
input wire parity_enable,
input wire parity_type,
output wire TX_OUT ,
output wire busy
);

//internal connections
wire S_DATA;
wire [1:0] mux_sel;
wire par_bit;
wire ser_done;
wire ser_en;

Serializer U0_serializer (
.IN_serializer(P_DATA),
.CLK(CLK),
.RST(RST),
.EN(ser_en),
.OUT_serializer(S_DATA),
.ser_done(ser_done)
);

Parity_calc  U0_Parity(
.CLK(CLK),
.DATA(P_DATA),
.PAR_Typ(parity_type),
.RST(RST),
.DATA_VALID(Data_Valid),
.OUT(par_bit)
);

MUX #( .start_bit(start_bit) , .stop_bit(stop_bit)) U0_MUX(
.SEL(mux_sel),
.CLK(CLK),
.RST(RST),
.PAR(par_bit),
.S_DATA(S_DATA),
.TX_OUT(TX_OUT)
);


FSM  U0_FSM(
.CLK(CLK),
.RST(RST),
.PAR_EN(parity_enable),
.ser_done(ser_done),
.DATA_VALID(Data_Valid),
.ser_en(ser_en),
.busy(busy),
.mux_sel(mux_sel)
);

endmodule