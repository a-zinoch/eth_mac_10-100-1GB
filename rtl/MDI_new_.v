

module MDI_file  	(reset, sysck, hwdata, hrdata_mdi,
		 MAC_MANCTDAT_wrl_en, MAC_MANCTDAT_wrh_en,
		 MDI, MDC_CLK, MDO, MDIO_EN);

input reset, sysck, MAC_MANCTDAT_wrl_en, MAC_MANCTDAT_wrh_en;
input MDI;
input [31:0] hwdata;
output [27:0] hrdata_mdi;
output  MDO;
output MDIO_EN, MDC_CLK;
reg [15:0] MDATA, MDOSh;

reg MDC1, MDC2, MDC3, MDC4, MDC5, MDC_CLK;
wire  c6, c5, c4, c3, c2, c1, c0;
reg OPER, Err_Reg, RC, WC;
wire ci, rstRC, rstWC;
reg  MDEM, WC_EN, RC_EN, rstRC_shift;
reg [6:0]Cnt;
reg MDC;
wire MDC_en = (!c6 & (RC | WC)) ? !MDC : 1'b0;
wire MDIO_EN;
reg [4:0] MADR, PHYADR;

reg MDI_CLK_en;

// synopsys async_set_reset "reset"  
always @ (negedge reset or posedge sysck) if(!reset)MDC1 <= 1'b0; else MDC1 <= (MDI_CLK_en)? !MDC1 : 1'b0;
always @ (negedge reset or posedge sysck) if(!reset)MDC2 <= 1'b0; else MDC2 <= (!MDI_CLK_en)? 1'b0 : (MDC1)? !MDC2 : MDC2;
always @ (negedge reset or posedge sysck) if(!reset)MDC3 <= 1'b0; else MDC3 <= (!MDI_CLK_en)? 1'b0 : (MDC1 && MDC2)? !MDC3 : MDC3;
always @ (negedge reset or posedge sysck) if(!reset)MDC4 <= 1'b0; else MDC4 <= (!MDI_CLK_en)? 1'b0 : (MDC1 && MDC2 && MDC3)? !MDC4 : MDC4;
always @ (negedge reset or posedge sysck) if(!reset)MDC5 <= 1'b0; else MDC5 <= (!MDI_CLK_en)? 1'b0 : (MDC1 && MDC2 && MDC3 && MDC4)? !MDC5 : MDC5;
always @ (negedge reset or posedge sysck) if(!reset)MDC_CLK <= 1'b0; else MDC_CLK <= (!MDI_CLK_en)? 1'b0 : (MDC1 && MDC2 && MDC3 && MDC4 && MDC5)? !MDC_CLK : MDC_CLK;
always @ (negedge reset or posedge sysck) if(!reset)MDC <= 1'b0; else MDC <= (!MDI_CLK_en)? 1'b0 : (MDC1 && MDC2 && MDC3 && MDC4 && MDC5)? MDC_en : MDC;

//always @ (negedge reset or posedge sysck) if(!reset)MDC1 = 1'b0; else MDC1 = !MDC1;
//always @ (negedge reset or negedge MDC1)  if(!reset)MDC2 = 1'b0; else MDC2 = !MDC2;
//always @ (negedge reset or negedge MDC2)  if(!reset)MDC3 = 1'b0; else MDC3 = !MDC3;
//always @ (negedge reset or negedge MDC3)  if(!reset)MDC4 = 1'b0; else MDC4 = !MDC4;
//always @ (negedge reset or negedge MDC4)  if(!reset)MDC5 = 1'b0; else MDC5 = !MDC5;
//always @ (negedge reset or negedge MDC5)  if(!reset)MDC_CLK = 1'b0; else MDC_CLK = !MDC_CLK;
//always @ (negedge reset or negedge MDC5)  if(!reset)MDC = 1'b0; else MDC = MDC_en;


wire MDI_CLK_en_wire = (MAC_MANCTDAT_wrh_en)? hwdata[28] : MDI_CLK_en;
always @(posedge sysck or negedge reset) 
					 if (!reset) MDI_CLK_en <= 1'b0;
					 else MDI_CLK_en <= MDI_CLK_en_wire;

wire [4:0]MADR_WR = (MAC_MANCTDAT_wrh_en)? hwdata[20:16] : MADR;
always @(posedge sysck or negedge reset) if (!reset) MADR  [4:0] <= 5'b0;
					 else MADR  [4:0] <= MADR_WR;
wire [4:0]PHYADR_WR = (MAC_MANCTDAT_wrh_en)? hwdata[25:21] : PHYADR;
always @(posedge sysck or negedge reset) if (!reset) PHYADR[4:0] <= 5'b0;
					 else PHYADR[4:0] <= PHYADR_WR;

/*  Give up DATA for internal register of processor  */  
wire WC_EN_WR = (MAC_MANCTDAT_wrh_en)? hwdata[30] | WC_EN : WC_EN;
always @(negedge rstRC or posedge sysck) if (!rstRC) WC_EN  <= 0; else WC_EN  <= WC_EN_WR;
wire RC_EN_WR = (MAC_MANCTDAT_wrh_en)? hwdata[31] | RC_EN : RC_EN;
always @(negedge rstRC or posedge sysck) if (!rstRC) RC_EN  <= 0; else RC_EN  <= RC_EN_WR;
wire [15:0]MDATA_WR = (MAC_MANCTDAT_wrl_en)? hwdata [15:0] : MDATA;
always @(posedge sysck or negedge reset) if (!reset) MDATA [15:0] <= 16'b0; else MDATA [15:0] <= MDATA_WR;

assign hrdata_mdi = {RC_EN,WC_EN,PHYADR[4:0],MADR[4:0],MDOSh[15:0]};
//assign hrdata = (rd_MDATA)?   : 32'bz;


/* Block for transmit or receive DATA into internal register of transceiver*/
always @ (negedge reset or negedge sysck) if (!reset) Err_Reg = 1'b0; else Err_Reg = RC & WC;

//assign Cnt = {c5,c4,c3,c2,c1,c0};
assign c0 = Cnt[0];
assign c1 = Cnt[1];
assign c2 = Cnt[2];
assign c3 = Cnt[3];
assign c4 = Cnt[4];
assign c5 = Cnt[5];
assign c6 = Cnt[6];
assign ci = (!c6 & (RC | WC))? MDC: 0;
wire rstCnt = RC | WC;
wire rstRC_en = (!Err_Reg && reset && !c6)? 1'b0 : 1'b1;
//assign rstWC = (!Err_Reg && !reset && !c6)? 1'b1 : 1'b0;
reg rstRC_reg, reset_need_del, reset_need_reg;
wire  reset_need = reset_need_reg | !reset;
always @ (negedge reset or posedge MDC_CLK) if(!reset) rstRC_reg <= 1'b0; else rstRC_reg <= rstRC_en;

always @ (posedge reset_need or posedge rstRC_reg) if(reset_need) rstRC_shift <= 1'b0; else rstRC_shift <= 1'b1;
always @ (negedge reset or posedge sysck) if(!reset) reset_need_del <= 1'b0; else reset_need_del <= rstRC_shift;
always @ (negedge reset or posedge sysck) if(!reset) reset_need_reg <= 1'b0; else reset_need_reg <= reset_need_del;
assign rstWC = (!reset | rstRC_shift)? 0 : 1;
assign rstRC = (!reset | rstRC_shift)? 0 : 1;

//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c0 <= 0; else c0 <= ~c0;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c1 <= 0; else c1 <= (c0)? ~c1 : c1;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c2 <= 0; else c2 <= (c0 && c1)? ~c2 : c2;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c3 <= 0; else c3 <= (c0 && c1 && c2)? ~c3 : c3;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c4 <= 0; else c4 <= (c0 && c1 && c2 && c3)? ~c4 : c4;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c5 <= 0; else c5 <= (c0 && c1 && c2 && c3 && c4)? ~c5 : c5;
//always @(negedge rstCnt or negedge MDC) if (!rstCnt) c6 <= 0; else c6 <= (c0 && c1 && c2 && c3 && c4 && c5)? ~c6 : c6;
wire [7:0] cnt_sum = Cnt +1'b1;
always @(negedge rstCnt or negedge MDC) if (!rstCnt) Cnt <= 7'h00; else Cnt <= cnt_sum[6:0];

//always @(negedge rstCnt or negedge ci) if (!rstCnt) c0 <= 0; else c0 <= ~c0;
//always @(negedge rstCnt or negedge c0) if (!rstCnt) c1 <= 0; else c1 <= ~c1;
//always @(negedge rstCnt or negedge c1) if (!rstCnt) c2 <= 0; else c2 <= ~c2;
//always @(negedge rstCnt or negedge c2) if (!rstCnt) c3 <= 0; else c3 <= ~c3;
//always @(negedge rstCnt or negedge c3) if (!rstCnt) c4 <= 0; else c4 <= ~c4;
//always @(negedge rstCnt or negedge c4) if (!rstCnt) c5 <= 0; else c5 <= ~c5;
//always @(negedge rstCnt or negedge c5) if (!rstCnt) c6 <= 0; else c6 <= ~c6;
always @ (c0 or c1 or c2 or c3 or c4 or c5 or c6 or RC or WC or PHYADR or MADR or MDATA) if(!c6 & !c5) MDEM = 1'b1;
		else if(c6)MDEM = MDATA[ 0];
                 else   case({c4,c3,c2,c1,c0})
                            5'h0  : MDEM = 1'b0;
                            5'h1  : MDEM = 1'b1;
                            5'h2  : MDEM = RC;
                            5'h3  : MDEM = WC;
                            5'h4  : MDEM = PHYADR[4];
                            5'h5  : MDEM = PHYADR[3];
                            5'h6  : MDEM = PHYADR[2];
                            5'h7  : MDEM = PHYADR[1];
                            5'h8  : MDEM = PHYADR[0];
                            5'h9  : MDEM = MADR[4];
                            5'hA  : MDEM = MADR[3];
                            5'hB  : MDEM = MADR[2];
                            5'hC  : MDEM = MADR[1];
                            5'hD  : MDEM = MADR[0];
                            5'hE  : MDEM = 1'b1;
                            5'hF  : MDEM = 1'b0;
                            5'h10 : MDEM = MDATA[15];
                            5'h11 : MDEM = MDATA[14];
                            5'h12 : MDEM = MDATA[13];
                            5'h13 : MDEM = MDATA[12];
                            5'h14 : MDEM = MDATA[11];
                            5'h15 : MDEM = MDATA[10];
                            5'h16 : MDEM = MDATA[ 9];
                            5'h17 : MDEM = MDATA[ 8];
                            5'h18 : MDEM = MDATA[ 7];
                            5'h19 : MDEM = MDATA[ 6];
                            5'h1A : MDEM = MDATA[ 5];
                            5'h1B : MDEM = MDATA[ 4];
                            5'h1C : MDEM = MDATA[ 3];
                            5'h1D : MDEM = MDATA[ 2];
                            5'h1E : MDEM = MDATA[ 1];
                            5'h1F : MDEM = MDATA[ 0];
                            endcase


/*  Transmit DATA*/
assign MDO  = (WC | (((!c4 & !c3) | (!c4 & c3 & !c2) | (!c4 & c3 & c2 &!c1)/*!c4 |(!c4 & !c3 & !c2 & !c1)*/| !c5) & RC & !c6))? MDEM/*[0]*/ : 1'bz;
/*   Receive DATA from transceiver Register  */
//reg MDIn;
//always @ (posedge MDC) MDIn = MDI;
wire [15:0]Sh_In;

reg MDOSh_en;
assign Sh_In = (MDOSh_en)? {MDOSh[14],MDOSh[13],MDOSh[12],MDOSh[11],
                MDOSh[10],MDOSh[ 9],MDOSh[ 8],MDOSh[ 7],
                MDOSh[ 6],MDOSh[ 5],MDOSh[ 4],MDOSh[ 3],
                MDOSh[ 2],MDOSh[ 1],MDOSh[ 0],MDI
               } : MDOSh;
always@ (negedge reset or posedge MDC_CLK) if(!reset) MDOSh_en <=0; else MDOSh_en <= RC & ((c3 & c2 & c1 & c0 & !c4 & c5) | (!(c3 & c2 & c1 & c0) & c4 & c5));

always @ (negedge reset or posedge MDC) if(!reset)    MDOSh = 16'b0;
                        else MDOSh = Sh_In;
/* End block for transmit or receive DATA into internal register of transceiver*/
reg WC_filt, RC_filt;
always @(negedge rstWC or negedge MDC_CLK) if (!rstWC) WC_filt  <= 0; else WC_filt  <= WC_EN;

always @(negedge rstWC or negedge MDC_CLK) if (!rstWC) RC_filt  <= 0; else RC_filt  <= RC_EN;

always @(negedge rstWC or negedge MDC_CLK) if (!rstWC) WC  <= 0; else WC  <= WC_filt;

always @(negedge rstWC or negedge MDC_CLK) if (!rstWC) RC  <= 0; else RC  <= RC_filt;

assign MDIO_EN = ((WC & !c6) | (((!c4 & !c3) | (!c4 & c3 & !c2) | (!c4 & c3 & c2 &!c1)| !c5) & RC & !c6))? 1'b1 : 1'b0;
endmodule