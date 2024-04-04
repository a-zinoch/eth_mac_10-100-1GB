`define PAW                 11

module mac_top 
  #(
    parameter     ADR_WIDTH             = 8,        //input address bus width
    parameter     DATA_WIDTH            = 32,       //input/output data bus width

    parameter     EMAC_CTRL_ADDR        = 'h80,     
    parameter     EMAC_STAT_ADDR        = 'h81,     
    parameter     EMAC_MYMACL           = 'h82,
    parameter     EMAC_MYMACH           = 'h83,
    parameter     EMAC_BUF_ADDR         = 'h84,     

    parameter     EMAC_PHYCTRL_ADDR     = 'h85,     
    parameter     EMAC_STARTTX_ADDR     = 'h86,     

    parameter     EMAC_RCV_ASRCL_ADDR   = 'h87,     
    parameter     EMAC_RCV_ASRCH_ADDR   = 'h88,     
    parameter     EMAC_RCV_TYPE_ADDR    = 'h89,     

    parameter     EMAC_TRAN_ADSTL_ADDR  = 'h8A,     
    parameter     EMAC_TRAN_ADSTH_ADDR  = 'h8B,     
    parameter     EMAC_TRAN_TYPE_ADDR   = 'h8C,     
    parameter     EMAC_TRAN_SIZE_ADDR   = 'h8D,  
    parameter     speed_PARAM           = 'b0    
  )(
// ============= System interface signals =====================
        input               clk_i
      , input               reset_i 

      , input               edwr_l_i
      , input               edwr_h_i
      , input               sedrd_i
      , input   [`PAW-1:0]  pr_adr_i
      , input   [31:0]      src_i
      , output  [31:0]      pr_src_o

// ====================== DMA =================================

      // , input  logic  [1:0]            grant_dma_i          //
      // , input  logic                   dma_req_wr_i         //
      // , input  logic                   dma_req_rd_i         //
      // , output logic  [1:0]            req_dma_o            // Request to DMA
      // , output logic  [1:0]            hold_dma_o           // 

// ================== MII/GMII signals ========================

// ---------------------- Tx ----------------------------------
      , input               tx_clk_i
      , output              tx_en_o
      , output  [7:0]       tx_d_o 

// ---------------------- Rx ----------------------------------
      , input               rx_clk_i
      , output              rx_en_o 
      , input               rx_er_i
      , input               rx_dv_i
      , input   [7:0]       rx_d_i

      , input               crs_i
      , input               col_i

// ====================== MDI =================================
      , input               mdint_i
      // , inout               mdio_i
      , input               mdio_i
      , output              mdc_o
      , output              phy_rst_o

  );

// ========================== Interface to KMX Inputs/Outputs And Control Block =========================================

logic [31:0 ] wr_data;        // Write data ro regs

// ---------------------- Signals/Flags --------------------------------------

logic [47:0 ] tran_dst_mac;

logic         tran_en;
logic         tran_busy;       
                 
// ========================= MAC =============================================

// ----------------------- Write Enable ---------------------------------------
  //logic         emac_ctrl_wrh;            
logic         emac_ctrl_wrl;                     

logic         emac_buf_wrh;              
logic         emac_buf_wrl;              

logic         emac_phyctrl_wrh;          
logic         emac_phyctrl_wrl;          
        
logic         emac_starttx_wrl;          

// ----------------------- Read Enable ---------------------------------------
logic         emac_ctrl_rd;              
logic         emac_stat_rd;              
logic         emac_buf_rd;               
logic         emac_phyctrl_rd;           
logic         emac_starttx_rd;

// ---------------------- Signals/Flags -------------------------------------- 
logic [47:0 ] my_mac;

logic         speed;
logic         duplex;
logic         col_distrack;
      
logic         phy_ie;
      
logic         soft_reset;

// ============================== MII GMII Input Cascade =================================================
logic         rx_en;
logic         rx_dv;
logic [7:0]   rx_d;
logic         rx_crs;
logic         rx_col;
logic         rx_err;

logic         tx_col;
logic         tx_crs;

logic         crs;

// ============================= Temp Memory Inputs/Outputs ==============================================

logic         fifo_push;
logic         fifo_pop;
logic         fifo_empty;
logic         fifo_full;

logic [31:0 ] data_to_tran;
logic [ 1:0 ] temp;


// ============================= Receiver Inputs/Outputs =================================================

logic         rcv_int_en;

logic         rcv_data_avlb;
logic [31:0 ] rcv_data;
logic [13:0 ] rcv_byte_cnt;

logic [47:0 ] rcv_dst_mac_addr;
logic [47:0 ] rcv_src_mac_addr;
logic [15:0 ] rcv_type_packet;

logic         rcv_OK;
logic         rcv_data_err;
logic         rcv_crc_err;
logic         rcv_col_err;
logic         rcv_err;

logic         rcv_OK_ack;
logic         rcv_data_err_ack;
logic         rcv_crc_err_ack;
logic         rcv_col_err_ack;
logic         rcv_err_ack;


// ============================= Transmitter Inputs/Outputs ==============================================

logic         tran_int_en;
logic         int_tran;

logic         tran_sedrd;
logic         tran_byte_cnt;
logic         tran_col_err;
logic         rst_transmit;

// ============================= CRC Receiver Inputs/Outputs  ============================================

logic [ 7:0 ] rcv_crc_data;
logic         rcv_crc_reset;
logic         rcv_crc_enable;
logic [31:0 ] rcv_crc; 
logic [ 7:0 ] rcv_data_for_crc;

// ============================= CRC Transmitter Inputs/Outputs  ============================================

logic [ 7:0 ] tran_crc_data;
logic         tran_crc_reset;
logic         tran_crc_enable;
logic [31:0 ] tran_crc; 
logic         tran_crc_err;
logic [ 7:0 ] tran_data_for_crc;

assign rcv_data_for_crc = rcv_crc_data;




// ================================= TEMP TEMP TEMP TEMP ======================================================

assign fifo_push = (fifo_empty && rcv_data_avlb);

// assign fifo_pop  = tran_sedrd;



// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
always_ff @(posedge tx_clk_i or negedge reset_i)
  if(~reset_i)     temp <= 0;
  else            temp <= (tran_sedrd) ? temp + 1 : temp;

always_comb
  case (temp)
    'b00: data_to_tran = tran_sedrd ? 'hFACEDEAD : 'h00000000;
    'b01: data_to_tran = tran_sedrd ? 'h11FFCCDD : 'h00000000;
    'b10: data_to_tran = tran_sedrd ? 'h24356798 : 'h00000000;
    'b11: data_to_tran = tran_sedrd ? 'hCA1010FA : 'h00000000;
  endcase
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

              ff_fifo 
              # (
                  .width(32)
                , .depth(1504)
                ) Temporary_MEM
                (
                  .clk_i    (rx_clk_i)
                , .reset_i  (reset_i)
                , .push_i   (fifo_push)
                , .pop_i    (fifo_pop)
                , .wrd_i    (rcv_data)
                , .rdd_o    (buf_data)
                , .empty_o  (fifo_empty)
                , .full_o   (fifo_full)

                );

// ================================= !!!!!!!!!!!!!!!!!!!!! ======================================================

mii_gmii_input_cascade
# (
  ) mii_gmii_input_cascade_inst
  (
    .reset_i      (reset_i)

  , .rx_clk_i     (rx_clk_i)
  , .rx_dv_i      (rx_dv_i)
  , .rx_en_i      (rcv_en)
  , .rxd_i        (rx_d_i)
  , .rx_er_i      (rx_er_i)

  , .tx_clk_i     (tx_clk_i)

  , .col_i        (col_i)
  , .crs_i        (crs_i)

  , .rx_dv_o      (rx_dv)
  , .rx_en_o      (rx_en_o)
  , .rxd_o        (rx_d)
  , .rx_er_o      (rx_err)
  , .col_rx_o     (rx_col)

  , .col_tx_o     (tx_col)

  , .crs_o        (crs)

  );

interface_mac_kmx
# (
    .ADR_WIDTH             (ADR_WIDTH)
  , .DATA_WIDTH            (DATA_WIDTH)

  , .EMAC_CTRL_ADDR        (EMAC_CTRL_ADDR)
  , .EMAC_STAT_ADDR        (EMAC_STAT_ADDR)
  , .EMAC_MYMACL           (EMAC_MYMACL)
  , .EMAC_MYMACH           (EMAC_MYMACH)
  , .EMAC_BUF_ADDR         (EMAC_BUF_ADDR)

  , .EMAC_PHYCTRL_ADDR     (EMAC_PHYCTRL_ADDR)
  , .EMAC_STARTTX_ADDR     (EMAC_STARTTX_ADDR)

  ) interface_mac_kmx_inst
  (
    .sysclk_i               (clk_i)
  , .reset_i                (reset_i)

// ======================= KMX ==============================
  
  , .periph_adr_i           (pr_adr_i)
  , .src_i                  (src_i)
  , .sedrd_i                (sedrd_i)
  , .edwr_h_i               (edwr_h_i)
  , .edwr_l_i               (edwr_l_i)
  , .wr_data_o              (wr_data)

  // , .grant_dma_i            ()
  // , .dma_req_wr_i           ()
  // , .dma_req_rd_i           ()
  // , .req_dma_o              ()
  // , .hold_dma_o             ()

// ========================= MAC =============================================

// ----------------------- Write Enable ---------------------------------------
  // , .emac_ctrl_wrh_o       (emac_ctrl_wrh)
  , .emac_ctrl_wrl_o        (emac_ctrl_wrl)

  , .emac_mymach_wrh_o      (emac_mymach_wrh)
  , .emac_mymach_wrl_o      (emac_mymach_wrl)
  , .emac_mymacl_wrh_o      (emac_mymacl_wrh)
  , .emac_mymacl_wrl_o      (emac_mymacl_wrl)

  , .emac_buf_wrh_o         (emac_buf_wrh)
  , .emac_buf_wrl_o         (emac_buf_wrl)

  , .emac_phyctrl_wrh_o     (emac_phyctrl_wrh)
  , .emac_phyctrl_wrl_o     (emac_phyctrl_wrl)

  , .emac_starttx_wrl_o     (emac_starttx_wrl)

// ----------------------- Read Enable ---------------------------------------

  , .emac_ctrl_rd_o         (emac_ctrl_rd)
  , .emac_stat_rd_o         (emac_stat_rd)
  , .emac_buf_rd_o          (emac_buf_rd)
  , .emac_phyctrl_rd_o      (emac_phyctrl_rd)
  , .emac_starttx_rd_o      (emac_starttx_rd)

  );

mac_control_block
 #(

  ) mac_control_block_inst
  (
       
        .sysclk_i                (clk_i)
      , .reset_i                 (reset_i)
       
      , .wr_data_i               (wr_data)
      , .tri_rd_data_o           (pr_src_o)

      // , .grant_dma_i          ()
      // , .dma_req_wr_i         ()
      // , .dma_req_rd_i         ()
      // , .req_dma_o            ()
      // , .hold_dma_o           () 

// ========================= RECEIVE  ==========================================

// ---------------------- Signals/Flags -------------------------------------- 
      , .rcv_OK_i              (rcv_OK)
      , .rcv_data_err_i        (rcv_data_err)
      , .rcv_crc_err_i         (rcv_crc_err)
      , .rcv_col_err_i         (rcv_col_err)
      , .rcv_err_i             (rcv_err)
      , .rcv_int_i             (rcv_int)
      
      , .rcv_OK_ack_o          (rcv_OK_ack)
      , .rcv_data_err_ack_o    (rcv_data_err_ack)
      , .rcv_crc_err_ack_o     (rcv_crc_err_ack)
      , .rcv_col_err_ack_o     (rcv_col_err_ack)
      , .rcv_err_ack_o         (rcv_err_ack)
      // , .rcv_int_ack_o         ()


      , .rcv_en_o              (rcv_en)
      , .rcv_all_o             (rcv_all)
      , .rcv_en_vld_type_o     (rcv_en_vld_type)
      , .rcv_ie_o              (rcv_int_en)
      // , .rcv_type_o          ()

// ========================= TRANSMIT ==========================================

// ---------------------- Signals/Flags --------------------------------------
      , .tran_col_err_i        (tran_col_err)
      , .tran_busy_i           (tran_busy)
      , .tran_dst_mac_o        (tran_dst_mac)
      
      , .tran_en_o             (tran_en)
      , .tran_ie_o             (tran_int_en)

// ========================= MAC =============================================

// ----------------------- Write Enable ---------------------------------------
      // , .emac_ctrl_wrh_i        (emac_ctrl_wrh)
      , .emac_ctrl_wrl_i       (emac_ctrl_wrl)

      , .emac_mymach_wrh_i     (emac_mymach_wrh)
      , .emac_mymach_wrl_i     (emac_mymach_wrl)
      , .emac_mymacl_wrh_i     (emac_mymacl_wrh)
      , .emac_mymacl_wrl_i     (emac_mymacl_wrl)

      , .emac_buf_wrh_i        (emac_buf_wrh)
      , .emac_buf_wrl_i        (emac_buf_wrl)

      , .emac_phyctrl_wrh_i    (emac_phyctrl_wrh)
      , .emac_phyctrl_wrl_i    (emac_phyctrl_wrl)


      // , .emac_starttx_wrh_i        (emac_starttx_wrh)
      , .emac_starttx_wrl_i    (emac_starttx_wrl)

// ----------------------- Read Enable ---------------------------------------
      , .emac_ctrl_rd_i        (emac_ctrl_rd)
      , .emac_stat_rd_i        (emac_stat_rd)
      , .emac_buf_rd_i         (emac_buf_rd)
      , .emac_phyctrl_rd_i     (emac_phyctrl_rd)
      , .emac_starttx_rd_i     (emac_starttx_rd)

// ---------------------- Signals/Flags -------------------------------------- 
      , .my_mac_o              (my_mac)

      , .speed_o               (speed)
      , .duplex_o              (duplex)
      , .col_distrack_o        (col_distrack)
      
      , .phy_ie_o              (phy_ie)
      
      , .mac_soft_reset_o      (soft_reset)
  );

mac_mii_gmii_receiver 
# (
  ) INST_receiver
  (
    .clk_i              (clk_i)
  , .reset_i            (reset_i)

  , .rx_clk_i           (rx_clk_i)
  , .rx_en_i            (rx_en_o)
  , .rx_er_i            (rx_err)
  , .rx_dv_i            (rx_dv)
  , .rx_d_i             (rx_d)
  , .crs_i              (crs)
  , .col_i              (rx_col && !col_distrack)

  , .speed_i            (speed || speed_PARAM)
  // , .en_vld_type_i      (rcv_en_vld_type)
  , .rcv_all_i          (rcv_all)
  , .rcv_int_en_i       (rcv_int_en)
  
  , .rcv_data_o         (rcv_data)
  , .rcv_data_wr_o      (rcv_data_avlb)
  , .cnt_byte_rcv_o     (rcv_byte_cnt)
  
  , .my_mac_i           (my_mac)  /// !!!!!
  // , .my_packet_type_i   (my_type) /// !!!!!
  
  , .dst_mac_o          (rcv_dst_mac_addr)
  , .src_mac_o          (rcv_src_mac_addr)
  , .type_packet_o      (rcv_type_packet)
  
  , .crc_enable_o       (rcv_crc_enable)
  , .rcv_crc_i          (rcv_crc)
  , .rcv_crc_data_o     (rcv_crc_data)
  , .reset_crc_rcv_o    (rcv_crc_reset)
  
  , .rcv_OK_o           (rcv_OK)
  , .crc_err_o          (rcv_crc_err)
  , .data_err_o         (rcv_data_err)
  , .col_err_o          (rcv_col_err)
  , .rcv_err_o          (rcv_err)

  , .rcv_OK_ack_i       (rcv_OK_ack)
  , .crc_err_ack_i      (rcv_crc_err_ack)
  , .data_err_ack_i     (rcv_data_err_ack)
  , .col_err_ack_i      (rcv_col_err_ack)
  , .rcv_err_ack_i      (rcv_err_ack)
  
  , .int_rcv_o          (rcv_int)

  );

mac_mii_gmii_transmitter 
# (
  ) INST_transmitter
  (
        .clk_i                (clk_i)
      , .reset_i              (reset_i)
      
      , .tran_start_i         (tran_en)

      , .tx_clk_i             (tx_clk_i)
      , .tx_en_o              (tx_en_o)
      , .tx_d_o               (tx_d_o)

      , .crs_i                (crs)
      , .col_i                (tx_col & !col_distrack)

      , .speed_i              (speed)
      , .duplex_i             (duplex)
      , .tran_int_en_i        (tran_int_en)

      , .tran_data_i          (data_to_tran)
      , .data_sedrd_o         (tran_sedrd)
      
      , .tran_dst_mac_i       (tran_dst_mac)
      , .tran_src_mac_i       (my_mac)
      , .tran_packet_type_i   (8'h08) 
      
      , .tran_crc_i           (tran_crc)
      , .crc_data_o           (tran_crc_data)
      , .crc_enable_o         (tran_crc_enable)
      , .reset_crc_tran_o     (tran_crc_reset)
      
      , .int_tran_o           (int_tran)
      
      , .rst_tran_o           (rst_transmit)
      , .cnt_byte_tran_o      (tran_byte_cnt)
      , .col_err_o            (tran_col_err)
  );  

mac_crc32 
# (

  ) crc32_receive
  (
    .clk_i       (rx_clk_i)
  , .reset_i     (rcv_crc_reset)
  , .crc_en_i    (rcv_crc_enable) 
  , .data_i      (rcv_data_for_crc)
  // , .crc_out_d_o   (rcv_crc)
  , .crc_out_o   (rcv_crc)
  );

mac_crc32 
# (

  ) crc32_transmit
  (
    .clk_i       (tx_clk_i)
  , .reset_i     (tran_crc_reset)
  , .crc_en_i    (tran_crc_enable) 
  // , .data_i      (tran_data_for_crc)
  , .data_i      (tran_crc_data)
  // , .data_i      (tran_crc_data)
  // , .crc_out_d_o   (tran_crc)
  , .crc_out_o   (tran_crc)
  );

endmodule




