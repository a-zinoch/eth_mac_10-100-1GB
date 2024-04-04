`define PAW                 11

module interface_mac_kmx
  #(
parameter     ADR_WIDTH             = 8,        //input address bus width
parameter     DATA_WIDTH            = 32,       //input/output data bus width

parameter     EMAC_CTRL_ADDR        = 'h80,     
parameter     EMAC_STAT_ADDR        = 'h81,     
parameter     EMAC_MYMACL           = 'h82,
parameter     EMAC_MYMACH           = 'h83,
parameter     EMAC_BUF_ADDR         = 'h84,     

parameter     EMAC_PHYCTRL_ADDR     = 'h85,     
parameter     EMAC_STARTTX_ADDR     = 'h86    

  )(
       
        input  logic                   sysclk_i             // System clock input
      , input  logic                   reset_i           	  // Reset input (assync)

// ========================= KMX =============================================
      
      , input  logic  [`PAW-1:0]       periph_adr_i       	// Addres bus
      , input  logic  [DATA_WIDTH-1:0] src_i          	    // Data bus input
      , input  logic                   sedrd_i           	  // Read strobe input 
      , input  logic                   edwr_h_i            	// Write hight half-word strobe input
      , input  logic                   edwr_l_i             // Write low half-word strobe input
      , output logic  [DATA_WIDTH-1:0] wr_data_o            // 

      , input  logic  [1:0]            grant_dma_i          //
      , input  logic                   dma_req_wr_i         //
      , input  logic                   dma_req_rd_i         //
      , output logic  [1:0]            req_dma_o            // Request to DMA
      , output logic  [1:0]            hold_dma_o           // 


// ========================= MAC =============================================

// ----------------------- Write Enable ---------------------------------------
      // , output logic                   emac_ctrl_wrh_o        // === 
      , output logic                   emac_ctrl_wrl_o       // 

      , output logic                   emac_mymach_wrh_o     //
      , output logic                   emac_mymach_wrl_o     //
      , output logic                   emac_mymacl_wrh_o     // 
      , output logic                   emac_mymacl_wrl_o     //

      , output logic                   emac_buf_wrh_o        // 
      , output logic                   emac_buf_wrl_o        //

      , output logic                   emac_phyctrl_wrh_o    // 
      , output logic                   emac_phyctrl_wrl_o    // 



      , output logic                   emac_starttx_wrl_o    //  

// ----------------------- Read Enable ---------------------------------------
      , output logic                   emac_ctrl_rd_o        // 
      , output logic                   emac_stat_rd_o        // 
      , output logic                   emac_mymach_rd_o      // 
      , output logic                   emac_mymacl_rd_o      // 
      , output logic                   emac_buf_rd_o         //
      , output logic                   emac_phyctrl_rd_o     // 
      , output logic                   emac_starttx_rd_o     //

  );
// Write data to Registers

always_ff @ (posedge sysclk_i)
  wr_data_o <= (!edwr_h_i || !edwr_l_i) ? src_i : wr_data_o; // !!

// DMA

assign req_dma_o            = 2'b00;
assign hold_dma_o           = 2'b00;


// Other

assign emac_ctrl_rd_o        = !sedrd_i && (periph_adr_i == EMAC_CTRL_ADDR);
assign emac_stat_rd_o        = !sedrd_i && (periph_adr_i == EMAC_STAT_ADDR);
assign emac_mymach_rd_o      = !sedrd_i && (periph_adr_i == EMAC_MYMACH);
assign emac_mymacl_rd_o      = !sedrd_i && (periph_adr_i == EMAC_MYMACL);
assign emac_buf_rd_o         = !sedrd_i && (periph_adr_i == EMAC_BUF_ADDR);
assign emac_phyctrl_rd_o     = !sedrd_i && (periph_adr_i == EMAC_PHYCTRL_ADDR);
assign emac_starttx_rd_o     = !sedrd_i && (periph_adr_i == EMAC_STARTTX_ADDR);



always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_ctrl_wrl_o <= 'b0;
  else          emac_ctrl_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_CTRL_ADDR);

// MY MAC Addres -> Device MAC

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_mymach_wrh_o <= 'b0;
  else          emac_mymach_wrh_o <= !edwr_h_i && (periph_adr_i == EMAC_MYMACH);

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_mymach_wrl_o <= 'b0;
  else          emac_mymach_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_MYMACH);

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_mymacl_wrh_o <= 'b0;
  else          emac_mymacl_wrh_o <= !edwr_h_i && (periph_adr_i == EMAC_MYMACL);

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_mymacl_wrl_o <= 'b0;
  else          emac_mymacl_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_MYMACL); 

// Buffer Register

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_buf_wrh_o <= 'b0;
  else          emac_buf_wrh_o <= !edwr_h_i && (periph_adr_i == EMAC_BUF_ADDR);

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_buf_wrl_o <= 'b0;
  else          emac_buf_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_BUF_ADDR);

// PHY Control

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_phyctrl_wrh_o <= 'b0;
  else          emac_phyctrl_wrh_o <= !edwr_h_i && (periph_adr_i == EMAC_PHYCTRL_ADDR);

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_phyctrl_wrl_o <= 'b0;
  else          emac_phyctrl_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_PHYCTRL_ADDR);

// Start Transmit Register

always_ff @ (posedge sysclk_i or negedge reset_i)
  if (!reset_i) emac_starttx_wrl_o <= 'b0;
  else          emac_starttx_wrl_o <= !edwr_l_i && (periph_adr_i == EMAC_STARTTX_ADDR);


endmodule






