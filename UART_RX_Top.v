
module UART_RX # ( parameter DATA_WIDTH = 8 , PRESCALE_WIDTH = 5 )

(
 input   wire                          CLK,
 input   wire                          RST,
 input   wire                          RX_IN,
 input   wire   [PRESCALE_WIDTH-1:0]   Prescale,
 input   wire                          parity_enable,
 input   wire                          parity_type,
 output  wire   [DATA_WIDTH-1:0]       P_DATA, 
 output  wire                          data_valid,
 output wire                   par_err,
output wire                   stp_err
);


wire   [3:0]           bit_count ;
wire   [3:0]           edge_count ;

wire                    Enable_par;
wire                   edge_bit_en;  
wire                   par_chk_en; 
wire                   stp_chk_en; 
wire                   parity_bit;
wire                   stop_bit;
wire                   dat_samp_en;

 
uart_rx_fsm U0_uart_fsm (
.CLK(CLK),
.RST(RST),
.S_DATA(RX_IN),
.bit_count(bit_count),
.edge_count(edge_count),
.prescale(Prescale),
.parity_enable(parity_enable),
.Enable_par(Enable_par), 
.par_err(par_err),
.stp_err(stp_err), 
.edge_bit_en(edge_bit_en), 
.par_chk_en(par_chk_en), 
.stp_chk_en(stp_chk_en),
.data_samp_en(dat_samp_en),
.data_valid(data_valid)
);
 
 
edge_bit_counter U0_edge_bit_counter (
.CLK(CLK),
.RST(RST),
.Enable(edge_bit_en),
.prescale(Prescale),
.bit_count(bit_count),
.parity_enable(parity_enable),
.edge_count(edge_count) 
); 

data_sampling U0_data_sampling (
.CLK(CLK),
.RST(RST),
.S_DATA(RX_IN),
.parity_enable(parity_enable),
.prescale(Prescale),
.Enable(dat_samp_en),
.bit_count(bit_count),
.edge_count(edge_count),
.parity_bit(parity_bit),
.stop_bit(stop_bit),
.P_DATA(P_DATA)
);




par_chk U0_par_chk (
.CLK(CLK),
.RST(RST),
.parity_type(parity_type),
.S_DATA(RX_IN),
.Enable(par_chk_en), 
.parity_bit(parity_bit),
.Enable_par(Enable_par), 
.par_err(par_err)
);

stp_chk U0_stp_chk (
.CLK(CLK),
.RST(RST),
.Enable(stp_chk_en),
.stop_bit(stop_bit), 
.stp_err(stp_err)
);


endmodule
 