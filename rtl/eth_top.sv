`include "incs/defines.vh"
interface if_periph_bus(input clk);
	logic phy_reset;
	logic mdi;
	logic mdo;
	logic mdc_clk;
	logic mdint;
	logic mdio_en;
	logic col;
	logic crs;
	logic rx_clk;
	logic rx_dv;
	logic rx_er;
	logic rx_en;
	logic tx_clk;
	logic tx_en;
	// logic [3:0] rxd;
	// logic [3:0] txd;
	logic [7:0] rxd;
	logic [7:0] txd;
	logic eth_int;

	modport master(
		output phy_reset,
		input mdi,
		output mdo,
		output mdc_clk,
		input mdint,
		output mdio_en,
		input col,
		input crs,
		input rx_clk,
		input rx_dv,
		input rx_er,
		output rx_en,
		input tx_clk,
		output tx_en,
		input rxd,
		output txd,
		output eth_int
	);

	modport slave(
		input phy_reset,
		output mdi,
		input mdo,
		input mdc_clk,
		output mdint,
		input mdio_en,
		output col,
		output crs,
		output rx_clk,
		output rx_dv,
		output rx_er,
		input rx_en,
		output tx_clk,
		input tx_en,
		output rxd,
		input txd,
		input eth_int
	);

endinterface

module eth_top (
	if_sysbus.slave sysbus_if,
	if_dma_bus.slave dmabus_if,
	if_periph_bus.master periph_if
);

	// logic read_data_mac_eth;
	// logic adr_mem_rec_mac_eth;
	// logic rec_data_w_mac_eth;
	// logic ce_mem_rec_w_mac_eth;
	// logic receive_we_w_mac_eth;


	//    ********** RAM interface for MAC_ETH receiver ***********
	wire	[31:0]  read_data_mac_eth;
	wire	[8:0]  	adr_mem_rec_mac_eth;
	wire	[31:0] 	rec_data_w_mac_eth;
	wire	clk_mem_rec_w_mac_eth;
	wire	ce_mem_rec_w_mac_eth;
	wire	receive_we_w_mac_eth;

	//    ********** RAM interface for MAC_ETH tranceiver ***********
	wire	[31:0]  tran_mem_data_mac_eth;
	wire	[8:0]  	adr_mem_tran_mac_eth;
	wire	[31:0] 	wr_data_mac_eth;
	wire	clk_mem_tran_w_mac_eth;
	wire	ce_mem_tran_w_mac_eth;
	wire	mac_ram_wr_en_w_mac_eth;

// ======================================= NEW =====================================================

	mac_top
	#
	(
		
	  .ADR_WIDTH             (`PERIPH_ADDR_WIDTH)        //	input address bus width
    ,.DATA_WIDTH            (`DMA_DAT_WIDTH)       //	input/output data bus width

    ,.EMAC_CTRL_ADDR        (`MAC_MCOM_ADDR)
    // ,.EMAC_STAT_ADDR        ()
    ,.EMAC_MYMACL           (`MAC_CARD_L_ADDR)
    ,.EMAC_MYMACH           (`MAC_CARD_H_ADDR)
    // ,.EMAC_BUF_ADDR         ()

    // ,.EMAC_PHYCTRL_ADDR     ()
    // ,.EMAC_STARTTX_ADDR     ()

    // ,.EMAC_RCV_ASRCL_ADDR   ()
    // ,.EMAC_RCV_ASRCH_ADDR   ()
    // ,.EMAC_RCV_TYPE_ADDR    ()

    // ,.EMAC_TRAN_ADSTL_ADDR  ()
    // ,.EMAC_TRAN_ADSTH_ADDR  ()
    // ,.EMAC_TRAN_TYPE_ADDR   ()
    // ,.EMAC_TRAN_SIZE_ADDR   () 

    ,.speed_PARAM 					('b1)
	) 
		mac_top
	(
// ============= System interface signals ================
     .clk_i 						(sysbus_if.clk)		
    ,.reset_i 					(sysbus_if.rst_n)

    ,.edwr_l_i 					(sysbus_if.edwrl_n)
    ,.edwr_h_i 					(sysbus_if.edwrh_n)
    ,.sedrd_i 					(sysbus_if.sedrd_n)
    ,.pr_adr_i 					(sysbus_if.pr_adr)
    ,.src_i 						(sysbus_if.src)
    ,.pr_src_o 					(sysbus_if.pr_src)

// ====================== DMA ============================

      // ,.grant_dma_i          ()
      // ,.dma_req_wr_i         ()
      // ,.dma_req_rd_i         ()
      // ,.req_dma_o            ()
      // ,.hold_dma_o           ()

// ================== MII/GMII signals ========================

// ---------------------- Tx -----------------------------
    ,.tx_clk_i 					(periph_if.tx_clk)
    ,.tx_en_o 					(periph_if.tx_en)
    ,.tx_d_o  					(periph_if.txd)

// ---------------------- Rx -----------------------------
    ,.rx_clk_i 					(periph_if.rx_clk)
    ,.rx_en_o  					(periph_if.rx_en)
    ,.rx_er_i 					(periph_if.rx_er)
    ,.rx_dv_i 					(periph_if.rx_dv)
    ,.rx_d_i 						(periph_if.rxd)

// ---------------------- Oth ----------------------------
    ,.crs_i 						(periph_if.crs)
    ,.col_i 						(periph_if.col)

// ====================== MDI ============================
    ,.mdint_i 				  (periph_if.mdint)
    ,.mdio_i 						(periph_if.mdi)
    ,.mdc_o 						(periph_if.mdc_clk)
    ,.phy_rst_o 				(periph_if.mdio_en)
        
  );

//-------------------------MAC_ETH RAM-----------------------------//
  TS1GE512X32M4 ETH_RAM_512X32_rec(
						.A      ( adr_mem_rec_mac_eth ),
						.D      ( rec_data_w_mac_eth ),
						.BWEB   ( 32'b0 ),
						.Q      ( read_data_mac_eth ),
						.TSEL   ( 2'b01               ),
						.CLK    ( sysbus_if.clk  ),
						.CEB    ( ce_mem_rec_w_mac_eth ),
						.WEB    ( receive_we_w_mac_eth )
						);

  TS1GE512X32M4 ETH_RAM_512X32_tran(
						.A      ( adr_mem_tran_mac_eth ),
						.D      (wr_data_mac_eth),
						.BWEB   ( 32'b0 ),
						.Q      ( tran_mem_data_mac_eth ),
						.TSEL   ( 2'b01               ),
						.CLK    ( sysbus_if.clk  ),
						.CEB    ( ce_mem_tran_w_mac_eth ),
						.WEB    (mac_ram_wr_en_w_mac_eth)
						);
//-------------------------------------------------------------------------------//

endmodule