// pragma cdn_vip_model -class enet
// Module:                      GMII_active_phy
// SOMA file:                   GMII_active_phy.soma
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
`timescale 1ns/1ns

module GMII_active_phy(
    sig_GMII_CRS,
    sig_GMII_RX_DV,
    sig_GMII_TX_DATA,
    sig_GMII_RX_DATA,
    sig_GMII_RX_ER,
    sig_GMII_TX_ER,
    sig_GMII_COL,
    sig_GMII_TX_EN,
    sig_GMII_TX_CLK,
    sig_GMII_RX_CLK,
    sig_MDIO,
    sig_MDCLK
);
    parameter interface_soma = "";
    parameter init_file   = "";
    parameter sim_control = "";
   reg sig_RESET;
    output sig_GMII_CRS;
      reg den_sig_GMII_CRS;
      assign sig_GMII_CRS = den_sig_GMII_CRS;
    output sig_GMII_RX_DV;
      reg den_sig_GMII_RX_DV;
      assign sig_GMII_RX_DV = den_sig_GMII_RX_DV;
    input [7:0] sig_GMII_TX_DATA;
      reg [7:0] den_sig_GMII_TX_DATA;
    output [7:0] sig_GMII_RX_DATA;
      reg [7:0] den_sig_GMII_RX_DATA;
      assign sig_GMII_RX_DATA = den_sig_GMII_RX_DATA;
    output sig_GMII_RX_ER;
      reg den_sig_GMII_RX_ER;
      assign sig_GMII_RX_ER = den_sig_GMII_RX_ER;
    input sig_GMII_TX_ER;
      reg den_sig_GMII_TX_ER;
    output sig_GMII_COL;
      reg den_sig_GMII_COL;
      assign sig_GMII_COL = den_sig_GMII_COL;
    input sig_GMII_TX_EN;
      reg den_sig_GMII_TX_EN;
    input sig_GMII_TX_CLK;
    input sig_GMII_RX_CLK;
    inout sig_MDIO;
      reg den_sig_MDIO;
      reg MDIO_Control;
      assign sig_MDIO = (MDIO_Control) ? den_sig_MDIO : 1'bz;
    input sig_MDCLK;

    always@(sig_GMII_TX_EN) den_sig_GMII_TX_EN = sig_GMII_TX_EN;
    always@(sig_GMII_TX_DATA) den_sig_GMII_TX_DATA = sig_GMII_TX_DATA;
    always@(sig_GMII_TX_ER) den_sig_GMII_TX_ER = sig_GMII_TX_ER;
    always@(sig_MDIO) begin
      if (MDIO_Control == 1'b0) 
         den_sig_MDIO <= sig_MDIO;
    end
    
initial
    $enet_access(sig_GMII_CRS,den_sig_GMII_CRS,sig_GMII_RX_DV,den_sig_GMII_RX_DV,sig_GMII_TX_DATA,den_sig_GMII_TX_DATA,sig_GMII_RX_DATA,den_sig_GMII_RX_DATA,sig_GMII_RX_ER,den_sig_GMII_RX_ER,sig_GMII_TX_ER,den_sig_GMII_TX_ER,sig_GMII_COL,den_sig_GMII_COL,sig_GMII_TX_EN,den_sig_GMII_TX_EN,sig_GMII_TX_CLK,sig_GMII_RX_CLK,sig_MDIO,den_sig_MDIO,sig_MDCLK);
endmodule

