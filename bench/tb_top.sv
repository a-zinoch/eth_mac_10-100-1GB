`include "incs/timescale.vh"
`include "incs/defines.vh"
`include "incs/incs.vh"
// `include "uvm_macros.svh" //Если не работает -> раском-ть.
`include "bench/uvm_env/eth_pkg.sv"


`ifdef OUTSIDE_ONLY
	`ifdef KMX_MC
		// `ifndef RTL
		// 	`define NetList
		// `endif
		`include "../2kmx_mc/bench/tb_top.v"
	`elsif KMX_KURGAN
		`ifdef NL_WORST
			`include "include/kmx32_define_layout.v"
			`include "include/kmx32_define_worstcase.v"
			`include "include/sim_incs_kurgan_rtc_layout_var2_all_cadense.v"
		`elsif NL_BEST
      `include "include/kmx32_define_layout.v"
      `include "include/kmx32_define_bestcase.v"
      `include "include/sim_incs_kurgan_rtc_layout_var2_all_cadense.v"
    `elsif NL_NORMAL
      `include "include/kmx32_define_layout.v"
      `include "include/kmx32_define_typicalcase.v"
      `include "include/sim_incs_kurgan_rtc_layout_var2_all_cadense.v"
    `elsif NL_SYNT
      `include "include/kmx32_define_netlist.v"
      `include "include/sim_incs_kurgan_rtc_netlist_var2.v"
		`else 
      `ifdef KMX_KURGAN_VAR2
        `include "include/sim_incs_kurgan_rtc_var2.v"
      `else 
        `include "include/sim_incs_kurgan_rtc.v"
      `endif
		`endif
		`include "../kmx32_kurgan/bench/kmx32_kurgan_TB.v"
	`elsif KMX_INTERFACE8
		`ifdef NL_WORST
			`include "../kmx32_Interface8/bench/synopsys_incs_kmx32_layout_worst.v"
		`elsif NL_BEST
			`include "../kmx32_Interface8/bench/synopsys_incs_kmx32_layout_best.v"
		`else 
			`include "../kmx32_Interface8/bench/synopsys_incs_kmx32_ideal_var2.v"
			`include "../kmx32_Interface8/rtl/periph/analog_bloks/rtl/LVDS_TX.v"
			`include "../kmx32_Interface8/rtl/periph/analog_bloks/rtl/LVDS_RX.v"
		`endif
		`include "../kmx32_Interface8/rtl/sborka_ROM_RAM/ROM_32K_X32.v"
		`include "../kmx32_Interface8/bench/kmx32_interface8_TB.v"
	`else
		`include "bench/verilog/tb_top_kmx32_sim.v"
	`endif
`endif

import uvm_pkg::*;

//Import the DDVAPI Enet SV interface and the generic Mem interface
import DenaliSvEnet::*;
import DenaliSvMem::*;
import cdnEnetUvm::*;

import pkg_uvm_top::*;

module eth_tb_top();

logic clk;

if_sysbus sysbus(clk);
if_dma_bus dmabus(clk,sysbus.rst_n);
if_periph_bus periph_if(clk);

initial begin
	clk = 0;
	sysbus.rst_n = 0;
	#32ns sysbus.rst_n = 1;
	forever #`TB_SYSCLK_HPER clk = ~clk;
end

initial begin
	periph_if.rx_clk = 0;
	forever #`TB_PHYRX_HPER periph_if.rx_clk = ~periph_if.rx_clk;
end

initial begin
	periph_if.tx_clk = 0;
	forever #`TB_PHYTX_HPER periph_if.tx_clk = ~periph_if.tx_clk;
end

`ifdef OUTSIDE_ONLY
initial force kmx32_kurgan_tb.kmx32_kurgan_var1.analog_cell.clk_o = periph_if.tx_clk;
`endif


initial begin
	uvm_config_db #(virtual if_sysbus)::set(null, "uvm_test_top","sysbus_vi", sysbus);
	uvm_config_db #(virtual if_dma_bus)::set(null, "uvm_test_top","dma_vi", dmabus);
	uvm_config_db #(virtual if_periph_bus)::set(null, "uvm_test_top","periph_vi", periph_if);

	$display("TEST DEF %x", `TEST_DEF);

	uvm_top.finish_on_completion  = 1;
	`ifdef OUTSIDE_ONLY
		run_test("eth_outside_only");
	`else
		run_test("eth_full_test");
	`endif
end

wire	MDIO_bidir;

`ifdef OUTSIDE_ONLY

	`ifdef KMX_MC
		tb_top tb_mc_top();
	`elsif KMX_KURGAN
		kmx32_kurgan_tb kmx32_kurgan_tb();
	`elsif KMX_INTERFACE8
		kmx32_interface8_TB tb_mc_top();
	`else
		tb_top_kmx32_sim tb_mc_top();
	`endif

	initial begin

		`ifdef KMX_MC
			force tb_mc_top.top_kmx32_mc.COL = periph_if.col;
			force tb_mc_top.top_kmx32_mc.CRS = periph_if.crs;

			force tb_mc_top.top_kmx32_mc.RX_CLK = periph_if.rx_clk;
			force tb_mc_top.top_kmx32_mc.TX_CLK = periph_if.tx_clk;

			force periph_if.rx_en =  tb_mc_top.top_kmx32_mc.RX_EN;
			force tb_mc_top.top_kmx32_mc.RX_ER = periph_if.rx_er;
			force tb_mc_top.top_kmx32_mc.RX_DV = periph_if.rx_dv;
			force tb_mc_top.top_kmx32_mc.RXD0 = periph_if.rxd[0];
			force tb_mc_top.top_kmx32_mc.RXD1 = periph_if.rxd[1];
			force tb_mc_top.top_kmx32_mc.RXD2 = periph_if.rxd[2];
			force tb_mc_top.top_kmx32_mc.RXD3 = periph_if.rxd[3];

			force periph_if.tx_en =  tb_mc_top.top_kmx32_mc.TX_EN;
			force periph_if.txd[0] = tb_mc_top.top_kmx32_mc.TXD0;
			force periph_if.txd[1] = tb_mc_top.top_kmx32_mc.TXD1;
			force periph_if.txd[2] = tb_mc_top.top_kmx32_mc.TXD2;
			force periph_if.txd[3] = tb_mc_top.top_kmx32_mc.TXD3;

			force periph_if.phy_reset = tb_mc_top.top_kmx32_mc.ETH_PH_RST;
			force periph_if.mdc_clk = tb_mc_top.top_kmx32_mc.MDC_CLK;
			force MDIO_bidir = tb_mc_top.top_kmx32_mc.MDIO;

		`elsif KMX_INTERFACE8
			force tb_mc_top.kmx32_interface8.mac1_col = periph_if.col;
			force tb_mc_top.kmx32_interface8.mac1_crs = periph_if.crs;

			force tb_mc_top.kmx32_interface8.mac1_rx_clk = periph_if.rx_clk;
			force tb_mc_top.kmx32_interface8.mac1_tx_clk = periph_if.tx_clk;

			force periph_if.rx_en =  tb_mc_top.kmx32_interface8.mac1_rx_en;
			force tb_mc_top.kmx32_interface8.mac1_rx_er = periph_if.rx_er;
			force tb_mc_top.kmx32_interface8.mac1_rx_dv = periph_if.rx_dv;
			force tb_mc_top.kmx32_interface8.mac1_rxd[0] = periph_if.rxd[0];
			force tb_mc_top.kmx32_interface8.mac1_rxd[1] = periph_if.rxd[1];
			force tb_mc_top.kmx32_interface8.mac1_rxd[2] = periph_if.rxd[2];
			force tb_mc_top.kmx32_interface8.mac1_rxd[3] = periph_if.rxd[3];

			force periph_if.tx_en = tb_mc_top.kmx32_interface8.mac1_tx_en;
			// force periph_if.txd = tb_mc_top.kmx32_interface8.mac1_txd;
			force periph_if.txd[0] = tb_mc_top.kmx32_interface8.mac1_txd[0];
			force periph_if.txd[1] = tb_mc_top.kmx32_interface8.mac1_txd[1];
			force periph_if.txd[2] = tb_mc_top.kmx32_interface8.mac1_txd[2];
			force periph_if.txd[3] = tb_mc_top.kmx32_interface8.mac1_txd[3];

			force periph_if.phy_reset = tb_mc_top.kmx32_interface8.mac1_phy_rst;
			force periph_if.mdc_clk = tb_mc_top.kmx32_interface8.mac1_mdc_clk;
			force MDIO_bidir = tb_mc_top.kmx32_interface8.mac1_mdio;
		`elsif KMX_KURGAN_ETH1
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_COL = periph_if.col;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_CRS = periph_if.crs;

			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RX_CLK = periph_if.rx_clk;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TX_CLK = periph_if.tx_clk;

			force periph_if.rx_en =  kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RX_EN;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RX_ER = periph_if.rx_er;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RX_DV = periph_if.rx_dv;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RXD0 = periph_if.rxd[0];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RXD1 = periph_if.rxd[1];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RXD2 = periph_if.rxd[2];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_RXD3 = periph_if.rxd[3];

			force periph_if.tx_en = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TX_EN;
			// force periph_if.txd = kmx32_kurgan_tb.kmx32_kurgan_var1.mac2_txd;
			force periph_if.txd[0] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TXD0;
			force periph_if.txd[1] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TXD1;
			force periph_if.txd[2] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TXD2;
			force periph_if.txd[3] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_TXD3;

			force periph_if.phy_reset = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_PH_RST;
			force periph_if.mdc_clk = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_MDC_CLK;
			force MDIO_bidir = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC2_MDIO;
		`elsif KMX_KURGAN
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_COL = periph_if.col;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_CRS = periph_if.crs;

			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RX_CLK = periph_if.rx_clk;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TX_CLK = periph_if.tx_clk;

			force periph_if.rx_en =  kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RX_EN;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RX_ER = periph_if.rx_er;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RX_DV = periph_if.rx_dv;
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RXD0 = periph_if.rxd[0];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RXD1 = periph_if.rxd[1];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RXD2 = periph_if.rxd[2];
			force kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_RXD3 = periph_if.rxd[3];

			force periph_if.tx_en = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TX_EN;
			// force periph_if.txd = kmx32_kurgan_tb.kmx32_kurgan_var1.mac1_txd;
			force periph_if.txd[0] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TXD0;
			force periph_if.txd[1] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TXD1;
			force periph_if.txd[2] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TXD2;
			force periph_if.txd[3] = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_TXD3;

			force periph_if.phy_reset = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_PH_RST;
			force periph_if.mdc_clk = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_MDC_CLK;
			force MDIO_bidir = kmx32_kurgan_tb.kmx32_kurgan_var1.MAC1_MDIO;
		`else
			force tb_mc_top.top_kmx32_sim.COL = periph_if.col;
			force tb_mc_top.top_kmx32_sim.CRS = periph_if.crs;

			force tb_mc_top.top_kmx32_sim.RX_CLK = periph_if.rx_clk;
			force tb_mc_top.top_kmx32_sim.TX_CLK = periph_if.tx_clk;

			force periph_if.rx_en =  tb_mc_top.top_kmx32_sim.RX_EN;
			force tb_mc_top.top_kmx32_sim.RX_ER = periph_if.rx_er;
			force tb_mc_top.top_kmx32_sim.RX_DV = periph_if.rx_dv;
			force tb_mc_top.top_kmx32_sim.RXD0 = periph_if.rxd[0];
			force tb_mc_top.top_kmx32_sim.RXD1 = periph_if.rxd[1];
			force tb_mc_top.top_kmx32_sim.RXD2 = periph_if.rxd[2];
			force tb_mc_top.top_kmx32_sim.RXD3 = periph_if.rxd[3];

			force periph_if.tx_en = tb_mc_top.top_kmx32_sim.TX_EN;
			force periph_if.txd[0] = tb_mc_top.top_kmx32_sim.TXD0;
			force periph_if.txd[1] = tb_mc_top.top_kmx32_sim.TXD1;
			force periph_if.txd[2] = tb_mc_top.top_kmx32_sim.TXD2;
			force periph_if.txd[3] = tb_mc_top.top_kmx32_sim.TXD3;

			force periph_if.phy_reset = tb_mc_top.top_kmx32_sim.ETH_PH_RST;
			force periph_if.mdc_clk = tb_mc_top.top_kmx32_sim.MDC_CLK;
			force MDIO_bidir = tb_mc_top.top_kmx32_sim.MDIO;
			force tb_mc_top.top_kmx32_sim.MDINT = 1'b1;
		`endif

	end

`else 
	assign  MDIO_bidir = (periph_if.mdio_en)? periph_if.mdo : 1'bz;
	assign periph_if.mdi = MDIO_bidir;
	eth_top mac_eth_kmx32(
			.sysbus_if(sysbus),
			.dmabus_if(dmabus),
			.periph_if(periph_if)
		);
`endif

wire [7:0] rxd_del;
wire rx_dv_del;
wire rx_er_del;
wire crs_del;

assign #3ns periph_if.rx_dv = rx_dv_del;
assign #3ns periph_if.rx_er = rx_er_del;
assign #3ns periph_if.rxd = rxd_del;
assign #3ns periph_if.crs = crs_del;

// mii_active_phy phy(
//  .sig_MII_CRS(crs_del),
//  .sig_MII_RX_DV(rx_dv_del),
//  .sig_MII_TX_DATA(periph_if.txd),
//  .sig_MII_RX_DATA(rxd_del),
//  .sig_MII_RX_ER(rx_er_del),
//  .sig_MII_TX_ER(1'b0),
//  .sig_MII_COL(periph_if.col),
//  .sig_MII_TX_EN(periph_if.tx_en),
//  .sig_MII_TX_CLK(periph_if.tx_clk),
//  .sig_MII_RX_CLK(periph_if.rx_clk),
//  .sig_MDIO(MDIO_bidir),
//  .sig_MDCLK('0)
//  // .sig_MDCLK(periph_if.mdc_clk)
//  );

GMII_active_phy phy(
 .sig_GMII_CRS(crs_del),
 .sig_GMII_RX_DV(rx_dv_del),
 .sig_GMII_TX_DATA(periph_if.txd),
 .sig_GMII_RX_DATA(rxd_del),
 .sig_GMII_RX_ER(rx_er_del),
 .sig_GMII_TX_ER(1'b0),
 .sig_GMII_COL(periph_if.col),
 .sig_GMII_TX_EN(periph_if.tx_en),
 .sig_GMII_TX_CLK(periph_if.tx_clk),
 .sig_GMII_RX_CLK(periph_if.rx_clk),
 .sig_MDIO(MDIO_bidir),
 .sig_MDCLK('0)
 // .sig_MDCLK(periph_if.mdc_clk)
 );


`ifndef FULL_DUPLEX
	defparam phy.interface_soma =
		"../../bench/vip_models/active_phy_hd.soma";
`else
	defparam phy.interface_soma =
		"../../bench/vip_models/active_phy_fd.soma";
`endif

// bit [3:0] txd_bit;

// assign txd_bit = periph_if.txd;

// mii_passive mac_passive (
// 	.sig_MII_CRS    (periph_if.crs     ),
// 	.sig_MII_RX_DV  (periph_if.rx_dv   ),
// 	.sig_MII_TX_DATA(periph_if.txd	   ),
// 	.sig_MII_RX_DATA(periph_if.rxd	   ),
// 	.sig_MII_RX_ER  (periph_if.rx_er   ),
// 	.sig_MII_TX_ER  (1'b0              ),
// 	.sig_MII_COL    (periph_if.col     ),
// 	.sig_MII_TX_EN  (periph_if.tx_en   ),
// 	.sig_MII_TX_CLK (periph_if.tx_clk  ),
// 	.sig_MII_RX_CLK (periph_if.rx_clk  )
// 	//.sig_MDIO       (MDIO_bidir       ),
// 	//.sig_MDCLK      (periph_if.mdc_clk )
// 	);

GMII_passive mac_passive(
	.sig_GMII_CRS    (periph_if.crs     ),
	.sig_GMII_RX_DV  (periph_if.rx_dv   ),
	.sig_GMII_TX_DATA(periph_if.txd	   ),
	.sig_GMII_RX_DATA(periph_if.rxd	   ),
	.sig_GMII_RX_ER  (periph_if.rx_er   ),
	.sig_GMII_TX_ER  (1'b0              ),
	.sig_GMII_COL    (periph_if.col     ),
	.sig_GMII_TX_EN  (periph_if.tx_en   ),
	.sig_GMII_TX_CLK (periph_if.tx_clk  ),
	.sig_GMII_RX_CLK (periph_if.rx_clk  )
	);

`ifndef FULL_DUPLEX
	defparam mac_passive.interface_soma =
		"../../bench/vip_models/macPassiveWrapper_hd.soma";
`else
	defparam mac_passive.interface_soma =
		"../../bench/vip_models/macPassiveWrapper_fd.soma";
`endif

// logic fail;
// assign fail = (tb_mc_top.top_kmx32_mc.digit_kmx32_mc.mac_eth_kmx32.Adr_periph_i[8:0] == 'hAA) & !tb_mc_top.top_kmx32_mc.digit_kmx32_mc.mac_eth_kmx32.EDWRh_i & tb_mc_top.top_kmx32_mc.digit_kmx32_mc.dma_kmx32.dma_capture_o;

initial begin
	
end
endmodule
