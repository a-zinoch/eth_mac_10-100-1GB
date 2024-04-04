// pragma cdn_vip_model -class enet
// Module:                      mii_active_phy
// SOMA file:                   mii_active_phy.soma
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
// `timescale 1ns/1ns

module mii_active_phy(
    sig_MII_CRS,
    sig_MII_RX_DV,
    sig_MII_TX_DATA,
    sig_MII_RX_DATA,
    sig_MII_RX_ER,
    sig_MII_TX_ER,
    sig_MII_COL,
    sig_MII_TX_EN,
    sig_MII_TX_CLK,
    sig_MII_RX_CLK,
    sig_MDIO,
    sig_MDCLK
);
    parameter interface_soma = "";
    parameter init_file   = "";
    parameter sim_control = "";
   reg sig_RESET;
    output sig_MII_CRS;
      reg den_sig_MII_CRS;
      assign sig_MII_CRS = den_sig_MII_CRS;
    output sig_MII_RX_DV;
      reg den_sig_MII_RX_DV;
      assign sig_MII_RX_DV = den_sig_MII_RX_DV;
    input [3:0] sig_MII_TX_DATA;
      reg [3:0] den_sig_MII_TX_DATA;
    output [3:0] sig_MII_RX_DATA;
      reg [3:0] den_sig_MII_RX_DATA;
      assign sig_MII_RX_DATA = den_sig_MII_RX_DATA;
    output sig_MII_RX_ER;
      reg den_sig_MII_RX_ER;
      assign sig_MII_RX_ER = den_sig_MII_RX_ER;
    input sig_MII_TX_ER;
      reg den_sig_MII_TX_ER;
    output sig_MII_COL;
      reg den_sig_MII_COL;
      assign sig_MII_COL = den_sig_MII_COL;
    input sig_MII_TX_EN;
      reg den_sig_MII_TX_EN;
    input sig_MII_TX_CLK;
    input sig_MII_RX_CLK;
    inout sig_MDIO;
      reg den_sig_MDIO;
      reg MDIO_Control;
      assign sig_MDIO = (MDIO_Control) ? den_sig_MDIO : 1'bz;
    input sig_MDCLK;

    always@(sig_MII_TX_EN) den_sig_MII_TX_EN = sig_MII_TX_EN;
    always@(sig_MII_TX_DATA) den_sig_MII_TX_DATA = sig_MII_TX_DATA;
    always@(sig_MII_TX_ER) den_sig_MII_TX_ER = sig_MII_TX_ER;
    always@(sig_MDIO) begin
      if (MDIO_Control == 1'b0) 
         den_sig_MDIO <= sig_MDIO;
    end
    
initial
    $enet_access(sig_MII_CRS,den_sig_MII_CRS,sig_MII_RX_DV,den_sig_MII_RX_DV,sig_MII_TX_DATA,den_sig_MII_TX_DATA,sig_MII_RX_DATA,den_sig_MII_RX_DATA,sig_MII_RX_ER,den_sig_MII_RX_ER,sig_MII_TX_ER,den_sig_MII_TX_ER,sig_MII_COL,den_sig_MII_COL,sig_MII_TX_EN,den_sig_MII_TX_EN,sig_MII_TX_CLK,sig_MII_RX_CLK,sig_MDIO,den_sig_MDIO,sig_MDCLK);
endmodule

