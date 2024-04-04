module mac_control_block
 #(
parameter      DEFAULT_MYMAC = 48'h00CA_CCC2_11
  )(
       
        input  logic                   sysclk_i             // System clock input
      , input  logic                   reset_i           	  // Reset input (assync)
       
      , input  logic  [31:0 ] 				 wr_data_i          	// Data bus input
      , output logic  [31:0 ] 				 tri_rd_data_o        // output tri-stable peripheral data bus(hrdata)

      // , input  logic  [1:0]            grant_dma_i          //
      // , input  logic                   dma_req_wr_i         //
      // , input  logic                   dma_req_rd_i         //
      // , output logic  [1:0]            req_dma_o            // Request to DMA
      // , output logic  [1:0]            hold_dma_o           // 

// ========================= RECEIVER  ==========================================

// ----------------------- Write Enable ---------------------------------------
      , input  logic                   emac_rcv_asrch_wrh_i  // === Enable write to register Receive MAC adddres Source
      , input  logic                   emac_rcv_asrch_wrl_i  // ???
      , input  logic                   emac_rcv_asrcl_wrh_i  // ??? NOT NEEDED
      , input  logic                   emac_rcv_asrcl_wrl_i  // ===

      // , input  logic                   emac_rcv_adsth_wrh_i  // === Enable write to register Receive MAC adddres Destination
      // , input  logic                   emac_rcv_adsth_wrl_i  //
      // , input  logic                   emac_rcv_adstl_wrh_i  //
      // , input  logic                   emac_rcv_adstl_wrl_i  // ===

      , input  logic                   emac_rcv_type_wrh_i   // === Enable write to register Receive TYPE 
      , input  logic                   emac_rcv_type_wrl_i   // ===    

// ----------------------- Read Enable ---------------------------------------
      , input  logic                   emac_rcv_asrch_rd_i  // === Enable read register Receive MAC adddres Source
      , input  logic                   emac_rcv_asrcl_rd_i  //

      // , input  logic                   emac_rcv_adsth_rd_i  // ===
      // , input  logic                   emac_rcv_adstl_rd_i  // 

      , input  logic                   emac_rcv_type_rd_i   // ===  

// ---------------------- Signals/Flags -------------------------------------- 
			, input  logic 									 rcv_OK_i
      , output logic                   rcv_OK_ack_o          // Synchronization signal ("Closed-loop") 
			
      , input  logic 									 rcv_data_err_i
			, output logic                   rcv_data_err_ack_o          // Synchronization signal ("Closed-loop") 

      , input  logic 									 rcv_crc_err_i
			, output logic                   rcv_crc_err_ack_o          // Synchronization signal ("Closed-loop") 
      
      , input  logic 									 rcv_col_err_i
			, output logic                   rcv_col_err_ack_o          // Synchronization signal ("Closed-loop") 

      , input  logic 									 rcv_err_i
      , output logic                   rcv_err_ack_o          // Synchronization signal ("Closed-loop") 

			, input  logic 									 rcv_int_i


			, output logic                   rcv_en_o

      , output logic 									 rcv_all_o
			, output logic 									 rcv_en_vld_type_o
			, output logic                   rcv_ie_o
      // , output logic [15:0]	 					 rcv_type_o

// ========================= TRANSMITER ==========================================

// ----------------------- Write Enable ---------------------------------------
      // , input  logic                   emac_tran_asrch_wrh_i  // === Enable write to register Transmit MAC adddres Source
      // , input  logic                   emac_tran_asrch_wrl_i  //
      // , input  logic                   emac_tran_asrcl_wrh_i  //
      // , input  logic                   emac_tran_asrcl_wrl_i  // ===

      , input  logic                   emac_tran_adsth_wrh_i  // === Enable write to register Transmit MAC adddres Destination
      , input  logic                   emac_tran_adsth_wrl_i  //
      , input  logic                   emac_tran_adstl_wrh_i  //
      , input  logic                   emac_tran_adstl_wrl_i  // ===

      , input  logic                   emac_tran_type_wrh_i   // === Enable write to register Transmit TYPE 
      , input  logic                   emac_tran_type_wrl_i   // ===    

      , input  logic                   emac_tran_size_wrh_i   // === Enable write to register Transmit TYPE 
      , input  logic                   emac_tran_size_wrl_i   // ===    

// ----------------------- Read Enable ---------------------------------------
      // , input  logic                   emac_tran_asrch_rd_i  // === Enable read register Transmit MAC adddres Source
      // , input  logic                   emac_tran_asrcl_rd_i  // ===

      , input  logic                   emac_tran_adsth_rd_i  // ===
      , input  logic                   emac_tran_adstl_rd_i  // ===

      , input  logic                   emac_tran_type_rd_i   // ===

      , input  logic                   emac_tran_size_rd_i   // ===   ?????

// ---------------------- Signals/Flags --------------------------------------
			, input  logic 									 tran_col_err_i				 // === Transmit collision error
			, input  logic 									 tran_busy_i 					 // === 
      , output logic [47:0 ]           tran_dst_mac_o
      
      , output logic                   tran_en_o
      , output logic                   tran_ie_o

// ========================= OTHER =============================================

// ----------------------- Write Enable ---------------------------------------
      // , input  logic                   emac_ctrl_wrh_i        // === 
      , input  logic                   emac_ctrl_wrl_i       // === 

      // , input  logic                   emac_stat_wrh_i        // === 
      // , input  logic                   emac_stat_wrl_i        // === 

      , input  logic                   emac_mymach_wrh_i
      , input  logic                   emac_mymach_wrl_i
      , input  logic                   emac_mymacl_wrh_i
      , input  logic                   emac_mymacl_wrl_i


      , input  logic                   emac_buf_wrh_i        // === 
      , input  logic                   emac_buf_wrl_i        // === 

      , input  logic                   emac_phyctrl_wrh_i    // === 
      , input  logic                   emac_phyctrl_wrl_i    // === 


      // , input  logic                   emac_starttx_wrh_i        // === 
      , input  logic                   emac_starttx_wrl_i    // === 

// ----------------------- Read Enable ---------------------------------------
      , input  logic                   emac_ctrl_rd_i        // === 
      , input  logic                   emac_stat_rd_i        // === 
      , input  logic                   emac_buf_rd_i         // ===
      , input  logic                   emac_phyctrl_rd_i     // ===
      , input  logic                   emac_starttx_rd_i     // ===  

// ---------------------- Signals/Flags -------------------------------------- 
      , output logic [47:0 ]           my_mac_o
      , output logic                   speed_o
      , output logic                   duplex_o
      , output logic                   col_distrack_o
      
      , output logic                   phy_ie_o
			
      , output logic 									 mac_soft_reset_o      // ===
  );

// ============================= Registers ===========================
/*
EMAC_CTRL        
EMAC_STAT        
EMAC_MYMACL
EMAC_MYMACH        
EMAC_BUF

EMAC_PHYCTRL     

EMAC_RCV_ASRCL   
EMAC_RCV_ASRCH   
EMAC_RCV_ADSTL   
EMAC_RCV_ADSTH   
EMAC_RCV_TYPE    

EMAC_STARTTX     

EMAC_TRAN_ADSTL  
EMAC_TRAN_ADSTH  
EMAC_TRAN_TYPE   
EMAC_TRAN_SIZE   
*/

logic [31:0 ] emac_ctrl;
logic [31:0 ] emac_stat;
logic [31:0 ] emac_mymacl;
logic [31:0 ] emac_mymach;
logic [31:0 ] emac_buf;

logic [31:0 ] emac_phyctrl; 

// ----- Receive -------

logic [31:0 ] emac_rcv_asrcl;
logic [31:0 ] emac_rcv_asrch;
logic [31:0 ] emac_rcv_type;

// ----- Transmit -------

logic [31:0 ] emac_starttx;

logic [31:0 ] emac_tran_adstl;
logic [31:0 ] emac_tran_adsth;
logic [31:0 ] emac_tran_type;
logic [31:0 ] emac_tran_size;

// ============================= Syncronization Status Signals ===========================

logic         rcv_OK_flg;
logic         rcv_OK_get_1;       // (Syncronized with sys Clock by "Closed-loop")
logic         rcv_OK_get_2;

logic         rcv_data_err_flg;
logic         rcv_data_err_get_1;       // (Syncronized with sys Clock by "Closed-loop")
logic         rcv_data_err_get_2;

logic         rcv_crc_err_flg;
logic         rcv_crc_err_get_1;       // (Syncronized with sys Clock by "Closed-loop")
logic         rcv_crc_err_get_2;

logic         rcv_col_err_flg;
logic         rcv_col_err_get_1;       // (Syncronized with sys Clock by "Closed-loop")
logic         rcv_col_err_get_2;

logic         rcv_err_flg;
logic         rcv_err_get_1;       // (Syncronized with sys Clock by "Closed-loop")
logic         rcv_err_get_2;

logic         rcv_int_flg;
// logic         rcv_int_1;       // (Syncronized with sys Clock by "Closed-loop")
// logic         rcv_int_2;

assign rcv_OK_flg         = rcv_OK_get_2;
assign rcv_OK_ack_o       = rcv_OK_get_2;

assign rcv_data_err_flg   = rcv_data_err_get_2;
assign rcv_data_err_ack_o = rcv_data_err_get_2;

assign rcv_crc_err_flg    = rcv_crc_err_get_2;
assign rcv_crc_err_ack_o = rcv_crc_err_get_2;

assign rcv_col_err_flg    = rcv_col_err_get_2;
assign rcv_col_err_ack_o  = rcv_col_err_get_2;

assign rcv_err_flg        = rcv_err_get_2;
assign rcv_err_ack_o      = rcv_err_get_2;

// assign rcv_int_flg        = rcv_int_get_2;

always_ff @(posedge sysclk_i or negedge reset_i)
begin
  if (!reset_i) begin
    rcv_OK_get_1 <= 0;
    rcv_OK_get_2 <= 0;
  end
  else begin
    rcv_OK_get_1 <= rcv_OK_i;
    rcv_OK_get_2 <= rcv_OK_get_1;
  end   
end 

always_ff @(posedge sysclk_i or negedge reset_i)
begin
  if (!reset_i) begin
    rcv_data_err_get_1 <= 0;
    rcv_data_err_get_2 <= 0;
  end
  else begin
    rcv_data_err_get_1 <= rcv_data_err_i;
    rcv_data_err_get_2 <= rcv_data_err_get_1;
  end   
end 

always_ff @(posedge sysclk_i or negedge reset_i)
begin
  if (!reset_i) begin
    rcv_crc_err_get_1 <= 0;
    rcv_crc_err_get_2 <= 0;
  end
  else begin
    rcv_crc_err_get_1 <= rcv_crc_err_i;
    rcv_crc_err_get_2 <= rcv_crc_err_get_1;
  end   
end 

always_ff @(posedge sysclk_i or negedge reset_i)
begin
  if (!reset_i) begin
    rcv_col_err_get_1 <= 0;
    rcv_col_err_get_2 <= 0;
  end
  else begin
    rcv_col_err_get_1 <= rcv_col_err_i;
    rcv_col_err_get_2 <= rcv_col_err_get_1;
  end   
end 

always_ff @(posedge sysclk_i or negedge reset_i)
begin
  if (!reset_i) begin
    rcv_err_get_1 <= 0;
    rcv_err_get_2 <= 0;
  end
  else begin
    rcv_err_get_1 <= rcv_err_i;
    rcv_err_get_2 <= rcv_err_get_1;
  end   
end 

// =========== EMAC_CTRL WRITE ===========================================================

always_ff @(posedge sysclk_i or negedge reset_i) 
begin
  if (!reset_i)                 emac_ctrl <= 'b0;
  else if(emac_ctrl_wrl_i)      emac_ctrl <= wr_data_i;
  else                          emac_ctrl <= emac_ctrl;
end

// ----------- EMAC_CTRL Signals ---------------------------

assign        duplex_o          =   emac_ctrl[10];
assign        speed_o           =   emac_ctrl[9];
assign        col_distrack_o    =   emac_ctrl[8];
                                // =   emac_ctrl[7];
assign        phy_ie_o          =   emac_ctrl[6];
assign        tran_ie_o         =   emac_ctrl[5];
assign        rcv_ie_o          =   emac_ctrl[4];
assign        mac_soft_reset_o  =   emac_ctrl[3];
assign        rcv_all_o         =   emac_ctrl[2];
assign        rcv_en_o          =   emac_ctrl[1];
assign        rcv_en_vld_type_o =   emac_ctrl[0];


// =========== EMAC_STAT WRITE ==========================================================

always_ff @(posedge sysclk_i or negedge reset_i) begin
	if (!reset_i) 		emac_stat <= 'b0;
	else              emac_stat <= 
    { 
       16'b0,                                                                               // 32 - 16
       6'b0000, tran_busy_i, tran_col_err_i,                                                // 15 - 8
       3'b000,rcv_err_flg, rcv_col_err_flg, rcv_crc_err_flg, rcv_data_err_flg, rcv_OK_flg   // 7  - 0
    };
end

// =========== EMAC_MYMAC WRITE ============================= 

wire [15:0 ] emac_mymac_mux_150  = (emac_mymacl_wrl_i) ? wr_data_i [15:0 ] : emac_mymacl [15:0 ]; 
wire [ 7:0 ] emac_mymac_mux_2316 = (emac_mymacl_wrh_i) ? wr_data_i [23:16] : emac_mymacl [23:16];
wire [15:0 ] emac_mymac_mux_3924 = (emac_mymach_wrl_i) ? wr_data_i [15:0 ] : emac_mymach [15:0 ];
wire [ 7:0 ] emac_mymac_mux_4740 = (emac_mymach_wrh_i) ? wr_data_i [23:16] : emac_mymach [23:16];

always_ff @(posedge sysclk_i or negedge reset_i) 
  if (!reset_i)   emac_mymacl <= {8'h00,DEFAULT_MYMAC};
  else if (emac_mymacl_wrl_i || emac_mymacl_wrh_i)           
                  emac_mymacl <= {8'b0, emac_mymac_mux_2316, emac_mymac_mux_150}; 
  else            emac_mymacl <= emac_mymacl;

always_ff @(posedge sysclk_i or negedge reset_i) 
  if (!reset_i)   emac_mymach <= {8'h00,DEFAULT_MYMAC};
  else if (emac_mymach_wrl_i || emac_mymach_wrh_i)           
                  emac_mymach <= {8'b0, emac_mymac_mux_4740, emac_mymac_mux_3924};
  else            emac_mymach <= emac_mymach;

// ----------- EMAC_MYMAC Signals -----------------------

assign my_mac_o = {emac_mymach[23:0],emac_mymacl[23:0]};

// =========== EMAC_SATRTTX WRITE =============================

always_ff @(posedge sysclk_i or negedge reset_i) 
  if (!reset_i)                   emac_starttx <= 'b0;
  else if (emac_starttx_wrl_i)    emac_starttx <= wr_data_i [0];
  else                            emac_starttx <= emac_starttx;

// ----------- EMAC_SATRTTX Signals -----------------------

assign tran_en_o = emac_starttx[0];


// =========== EAMC_TRAN_ADST WRITE ============================= 

wire [15:0 ] emac_tran_adst_mux_150  = (emac_tran_adstl_wrl_i) ? wr_data_i [15:0 ] : emac_tran_adstl [15:0 ]; 
wire [ 7:0 ] emac_tran_adst_mux_2316 = (emac_tran_adstl_wrh_i) ? wr_data_i [23:16] : emac_tran_adstl [23:16];
wire [15:0 ] emac_tran_adst_mux_3924 = (emac_tran_adsth_wrl_i) ? wr_data_i [15:0 ] : emac_tran_adsth [15:0 ];
wire [ 7:0 ] emac_tran_adst_mux_4740 = (emac_tran_adsth_wrh_i) ? wr_data_i [23:16] : emac_tran_adsth [23:16];

always_ff @(posedge sysclk_i or negedge reset_i) 
  if (!reset_i)   emac_tran_adstl <= 32'h0011_FA11;
  else if (emac_tran_adstl_wrl_i || emac_tran_adstl_wrh_i)           
                  emac_tran_adstl <= {8'b0, emac_tran_adst_mux_2316, emac_tran_adst_mux_150}; 
  else            emac_tran_adstl <= emac_tran_adstl;

always_ff @(posedge sysclk_i or negedge reset_i) 
  if (!reset_i)   emac_tran_adsth <= 32'h00FA_11FA;
  else if (emac_tran_adsth_wrl_i || emac_tran_adsth_wrh_i)           
                  emac_tran_adsth <= {8'b0, emac_tran_adst_mux_4740, emac_tran_adst_mux_3924};
  else            emac_tran_adsth <= emac_tran_adsth;

// ----------- EMAC_MYMAC Signals -----------------------

assign tran_dst_mac_o = {emac_tran_adsth[23:0], emac_tran_adstl[23:0]};

// =========== EMAC_SATRTTX WRITE =============================



// =========== Tri-stable multiplexer READ ================

always_comb
	unique case ({emac_rcv_asrch_rd_i, 	emac_rcv_asrcl_rd_i, 	emac_rcv_type_rd_i												                                            // 11-9
							, emac_tran_adsth_rd_i, emac_tran_adstl_rd_i, emac_tran_type_rd_i,  emac_tran_size_rd_i                                             // 8-5 
							,	emac_starttx_rd_i, 		emac_phyctrl_rd_i, 		emac_buf_rd_i, 				emac_stat_rd_i, 			emac_ctrl_rd_i})													// 4-0

/* EMAC_CTRL        */	{12'h001} : tri_rd_data_o <= emac_ctrl;
/* EMAC_STAT        */	{12'h002} : tri_rd_data_o <= emac_stat;
// /* EMAC_MYMACL      */ 	{15'h0004} : tri_rd_data_o <= emac_mymacl;
// /* EMAC_MYMACH      */ 	{15'h0008} : tri_rd_data_o <= emac_mymach;
/* EMAC_BUF         */	{12'h004} : tri_rd_data_o <= emac_buf;
/* EMAC_PHYCTRL     */	{12'h008} : tri_rd_data_o <= emac_phyctrl;
/* EMAC_STARTTX     */  {12'h010} : tri_rd_data_o <= emac_starttx;
/* EMAC_TRAN_SIZE   */	{12'h020} : tri_rd_data_o <= emac_tran_size;
/* EMAC_TRAN_TYPE   */	{12'h040} : tri_rd_data_o <= emac_tran_type;
/* EMAC_TRAN_ADSTL  */ 	{12'h080} : tri_rd_data_o <= emac_tran_adstl;
/* EMAC_TRAN_ADSTH  */ 	{12'h100} : tri_rd_data_o <= emac_tran_adsth;
/* EMAC_RCV_TYPE    */	{12'h200} : tri_rd_data_o <= emac_rcv_type;
/* EMAC_RCV_ASRCL   */ 	{12'h400} : tri_rd_data_o <= emac_rcv_asrcl;
/* EMAC_RCV_ASRCH   */ 	{12'h800} : tri_rd_data_o <= emac_rcv_asrch;
/* Default */						default		: tri_rd_data_o <= 'bz;
	endcase

endmodule

