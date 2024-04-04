`define PAW                 11

module mac_mii_gmii_receiver
  #(


  )(
       
        input  logic              clk_i             //
      , input  logic              reset_i           //

      , input  logic              rx_clk_i          //
      , input  logic              rx_en_i           //
      , input  logic              rx_er_i           //
      , input  logic              rx_dv_i           //
      , input  logic  [7:0]       rx_d_i            //

      , input  logic              crs_i             //
      , input  logic              col_i             // collision 
      
      , input  logic              speed_i           // speed (10/100) or 1000 
      , input  logic              rcv_all_i         // receiving all packets
      // , input  logic              en_vld_type_i     // enable validating packet by type 
      , input  logic              rcv_int_en_i      // receiver interrupt

      , output logic              rcv_data_wr_o     // valid receieved data from PHY
      , output logic  [31:0]      rcv_data_o        // received data from PHY     
      , input  logic  [47:0]      my_mac_i          // MAC address of device
      // , input  logic  [15:0]      my_packet_type_i  // type packet, that needs to be accepted
      , output logic  [13:0]      cnt_byte_rcv_o    // count received byte
      
      , output logic              crc_enable_o      // enable calculate CRC
      , input  logic  [31:0]      rcv_crc_i         // calculated CRC of packet
      , output logic  [7:0]       rcv_crc_data_o    // received data to CRC block
      , output logic              reset_crc_rcv_o   // reset CRC block  

      , output logic  [47:0]      dst_mac_o         // received destination address
      , output logic  [47:0]      src_mac_o         // received source address
      , output logic  [15:0]      type_packet_o     // received packet type

      , input  logic              dma_en_i          // enable work with DMA
      , input  logic              dma_req_i         // request to DMA

// ================= Status Signals =========================================================

      // , output logic              type_first_o      //
      , output logic              rcv_err_o         // indicate receive error       (syncronized with sys Clock by "Closed-loop")
      , input  logic              rcv_err_ack_i     // Acknowledge synchronization from mac control block

      , output logic              col_err_o         // collision error              (syncronized with sys Clock by "Closed-loop")
      , input  logic              col_err_ack_i     // Acknowledge synchronization from mac control block

      , output logic              crc_err_o         // CRC error                    (syncronized with sys Clock by "Closed-loop")
      , input  logic              crc_err_ack_i     // Acknowledge synchronization from mac control block

      , output logic              data_err_o        // received data error          (syncronized with sys Clock by "Closed-loop")
      , input  logic              data_err_ack_i    // Acknowledge synchronization from mac control block
      
      , output logic              rcv_OK_o          // received packet successfully (syncronized with sys Clock by "Closed-loop")
      , input  logic              rcv_OK_ack_i      // Acknowledge synchronization from mac control block

      , output logic              int_rcv_o         // interupt from receiver       (syncronized with sys Clock by "Closed-loop")
      , input  logic              int_rcv_ack_i     // Acknowledge synchronization from mac control block
  );
 


logic         receiving;                // Indicate the process of transferring a packet from the physical layer (PHY)
logic         receiving_end;            // Indicate that the process of transferring a packet from the physical layer -> END

logic         rcv_end;                  // Indicate the end of receiving by receiver

logic         receiving_frame;          // indication that the frame is receiving (State Dest Addr -> State Frame Check CRC)
logic         receiving_data;           // indication that the data is receiving
logic         rcv_byte_flg;             // byte received flag
logic         rcv_even_nibble;          // received even nibble (speed 10/100)
logic [ 3:0 ] rcv_nibble;               // received nibble (4 bits - speed 10/100)
logic [ 7:0 ] rcv_byte;                 // received byte
logic [13:0 ] rcv_byte_count;           // count of bytes received (only frame without PREAMBLE and SFD)

logic [ 2:0 ] rcv_preamble_byte_count;  // count of preamble bytes received

logic         rcv_data_wr_flg;          // valid received word

logic [47:0 ] dst_mac_tmp;              // destination mac (temporary buffer)
logic [47:0 ] src_mac_tmp;              // source mac (temporary buffer)
logic [15:0 ] typ_packet_tmp;           // Packet Type / Length (temporary buffer)
logic         typ_byte;                 // indicator witch byte receiving

// logic         pckt_typ_flg;             // indication that the package has the type
logic         pckt_len_flg;             // indication that the package has the length
logic [ 5:0 ] pad_len;


logic         reset_crc_flg;            // reset crc 
logic [ 2:0 ] rcv_crc_count;            // count of CRC bytes received
logic         rcv_fcs_flg;              // 

logic         preamble_nvd;             // indication of invalid PREAMBLE
logic         address_nvd;              // indication of invalid DESTINATION ADDRESS
logic         type_nvd;                 // indication of invalid TYPE / LENGTH (if enable validation packets by type)
logic         frame_rcv_finished;       // frame reception is finished (packet)

logic         reset_packet_receive_flg; // 

// ================================= Status Siganls =================================

logic          rcv_err_flg;                      // Error during receiveing packet
logic          rcv_err_ack_1;                    // First triger acknowledge in synchronization signal RX_ERR
logic          rcv_err_ack_2;                    // Second triger acknowledge in synchronization signal RX_ERR

logic          col_err_flg;                      // Indication collision error during receiving packet
logic          col_err_ack_1;                    // First triger acknowledge in synchronization signal COL_ERR
logic          col_err_ack_2;                    // Second triger acknowledge in synchronization signal COL_ERR

logic          crc_err_flg;                      // Indication CRC error during receiving packet
logic          crc_err_ack_1;                    // First triger acknowledge in synchronization signal CRC_ERR
logic          crc_err_ack_2;                    // Second triger acknowledge in synchronization signal CRC_ERR

logic          data_err_flg;                     // Indication data error during receiving packet
logic          data_err_ack_1;                   // First triger acknowledge in synchronization signal DATA_ERR
logic          data_err_ack_2;                   // Second triger acknowledge in synchronization signal DATA_ERR 

logic          rcv_OK_flg;                       // Packet recived successfully
logic          rcv_OK_ack_1;                     // First triger acknowledge in synchronization signal RCV_OK
logic          rcv_OK_ack_2;                     // Second triger acknowledge in synchronization signal RCV_OK

logic          int_rcv_flg;                      // Iterrupt from receiver

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if (~reset_i) begin
    rcv_err_o <= '0;
  end
  else begin
    rcv_err_o <= (!rcv_err_ack_2) ? rcv_err_flg : '0;
  end 
end 


always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if (~reset_i) begin
    col_err_o <= '0;
  end
  else begin
    col_err_o <= (!col_err_ack_2) ? col_err_flg : '0;
  end 
end 


always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if (~reset_i) begin
    crc_err_o <= '0;
  end
  else begin
    crc_err_o <= (!crc_err_ack_2) ? crc_err_flg : '0;
  end 
end 


always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if (~reset_i) begin
    data_err_o <= '0;
  end
  else begin
    data_err_o <= (!data_err_ack_2) ? data_err_flg : '0;
  end 
end 


always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if (~reset_i) begin
    rcv_OK_o <= '0;
  end
  else begin
    rcv_OK_o <= (!rcv_OK_ack_2) ? rcv_OK_flg : '0;
  end 
end 


// ================================= Status Siganls Sinchronization ===================

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if(~reset_i) begin
    rcv_err_ack_1 <= '0;
    rcv_err_ack_2 <= '0;
  end
  else begin
    rcv_err_ack_1 <= rcv_err_ack_i;
    rcv_err_ack_2 <= rcv_err_ack_1;
  end
end

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if(~reset_i) begin
    col_err_ack_1 <= '0;
    col_err_ack_2 <= '0;
  end
  else begin
    col_err_ack_1 <= col_err_ack_i;
    col_err_ack_2 <= col_err_ack_1;
  end
end

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if(~reset_i) begin
    crc_err_ack_1 <= '0;
    crc_err_ack_2 <= '0;
  end
  else begin
    crc_err_ack_1 <= crc_err_ack_i;
    crc_err_ack_2 <= crc_err_ack_1;
  end
end

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if(~reset_i) begin
    data_err_ack_1 <= '0;
    data_err_ack_2 <= '0;
  end
  else begin
    data_err_ack_1 <= data_err_ack_i;
    data_err_ack_2 <= data_err_ack_1;
  end
end

always_ff @ (posedge rx_clk_i or negedge reset_i)
begin
  if(~reset_i) begin
    rcv_OK_ack_1 <= '0;
    rcv_OK_ack_2 <= '0;
  end
  else begin
    rcv_OK_ack_1 <= rcv_OK_ack_i;
    rcv_OK_ack_2 <= rcv_OK_ack_1;
  end
end

// ================================= STATES ===========================================

typedef enum logic [3:0] {Idle, Preamble, Sfd, Dest_addr, Src_addr, Type, Data_pad, Frame_check_seq, End_receiving} mac_receiver_states; // ADD VLAN
mac_receiver_states current_state;

// ====================================================================================

assign rcv_OK_flg               = (frame_rcv_finished && !rcv_err_flg || rcv_OK_o);
assign int_rcv_flg              = (rcv_OK_flg && rcv_int_en_i);

assign rcv_err_flg              = col_err_flg || crc_err_flg || data_err_flg;
assign col_err_flg              = (receiving && rx_en_i && rx_dv_i && col_i && !rx_er_i);
assign data_err_flg             = (receiving_data && rx_en_i && rx_dv_i && !col_i && rx_er_i);

assign receiving                = (rx_en_i  && rx_dv_i && !col_i && !rx_er_i);

assign rcv_byte_flg             = (speed_i  || rcv_even_nibble);
assign rcv_byte                 = (speed_i) ? rx_d_i : {rx_d_i[3:0],rcv_nibble};
assign rcv_fcs_flg              = (rx_en_i  && current_state == Frame_check_seq);
assign receiving_data           = (rx_en_i  && rx_dv_i && current_state == Data_pad);

assign pckt_len_flg             = (typ_packet_tmp <= 'h05DC); // if <= 0x05DC then TYPE / LENGHT = Length

assign cnt_byte_rcv_o           = rcv_byte_count;

assign rcv_data_wr_flg          = (receiving && rcv_byte_flg && rcv_byte_count[1] && !rcv_byte_count[0] && current_state >= Data_pad);
assign rcv_data_wr_o            = rcv_data_wr_flg;

assign reset_packet_receive_flg = (frame_rcv_finished || type_nvd || address_nvd || preamble_nvd || col_err_flg || crc_err_flg || data_err_flg);


assign dst_mac_o                = (current_state > Dest_addr) ? dst_mac_tmp    : 'b0;
assign src_mac_o                = (current_state > Src_addr)  ? src_mac_tmp    : 'b0;
assign type_packet_o            = (current_state > Type)      ? typ_packet_tmp : 'b0;

// ================= Recived nibble (rcv_nibble) ===============================================

always_ff @ (posedge rx_clk_i or negedge reset_i)
  if(~reset_i)        rcv_nibble <= '0;
  else if(!speed_i)   rcv_nibble <= (reset_packet_receive_flg)? 1'b0 :rx_d_i[3:0];

// ================= Indication recived even nibble (rcv_even_nibble) ==========================

always_ff @ (posedge rx_clk_i or negedge reset_i)
  if(~reset_i)      rcv_even_nibble <= '0;
  else if(!speed_i) rcv_even_nibble <= (receiving)? !rcv_even_nibble : 1'b0;

// ================= Count of bytes received (rcv_byte_count) ==================================

wire  [13:0]rcv_count_sum       = rcv_byte_count + 1;
wire  [13:0]rcv_byte_count_wire = (reset_packet_receive_flg) ? 14'h0 : (receiving_frame & receiving & rcv_byte_flg)? rcv_count_sum[13:0] : rcv_byte_count;

always_ff @ (posedge rx_clk_i or negedge reset_i)
      if(~reset_i) rcv_byte_count <= '0;
      else         rcv_byte_count <= rcv_byte_count_wire;

// ================ Forming recieved data to CRC (rcv_crc_data_o) ==============================

always_ff @(posedge rx_clk_i or negedge reset_i) begin
  if(~reset_i)     rcv_crc_data_o <= '0;
  else             rcv_crc_data_o <= rcv_byte_flg ? rcv_byte : rcv_crc_data_o;
end

// ================ CRC =======================================================

assign reset_crc_flg = (receiving && current_state == Preamble)? 1'b0 : 1'b1;
assign crc_enable_o  = (receiving && rcv_byte_flg && rcv_byte_count > 0 && current_state != Frame_check_seq);

always @ (posedge rx_clk_i or negedge reset_i)
  if(~reset_i) reset_crc_rcv_o <= '0;
  else         reset_crc_rcv_o <= reset_crc_flg;

// =============================== FSM ========================================

always_ff @ (posedge rx_clk_i or negedge reset_i) begin
// ===================== RESET ================================================
  if (~reset_i || reset_packet_receive_flg) 
    begin
      current_state           <= Idle;
      pad_len                 <= 6'h2e;
      
      receiving_frame         <= '0;
      typ_packet_tmp          <= '0;
      typ_byte                <= '0;
      
      rcv_preamble_byte_count <= '0;
      rcv_crc_count           <= '0;

      preamble_nvd            <= '0;
      address_nvd             <= '0;
      type_nvd                <= '0;
      crc_err_flg             <= '0;
      
      frame_rcv_finished      <= '0;
    end
  else
    begin
      case (current_state)
  // ===================== state Idle =======================================
      Idle :
        begin
          if(rcv_byte_flg && rcv_byte == 'h55) begin
            current_state <= Preamble;
            rcv_preamble_byte_count <= rcv_preamble_byte_count + 1;
          end
        end 
  // ===================== state PREAMBLE =======================================
      Preamble : 
        begin
          if (receiving)
            begin
              if (speed_i) 
                begin
                  preamble_nvd  <= (rcv_byte != 8'h55) ? 'b1 : 'b0;
                  current_state <= (rcv_preamble_byte_count == 'h6) ? Sfd : current_state;
                end
              else 
                begin
                  preamble_nvd  <= (rcv_byte_flg && rcv_byte != 8'h55) ? 'b1 : 'b0;
                  current_state <= (rcv_preamble_byte_count == 'h7) ? Sfd : current_state;
                end
              rcv_preamble_byte_count <= (rcv_byte_flg) ? rcv_preamble_byte_count + 1 : rcv_preamble_byte_count;
            end
          else 
            begin
              current_state <= End_receiving;
            end 
        end
  // ====================== state SFD ===========================================
      Sfd : 
        begin
          if (receiving)
            begin
              if (rcv_byte_flg && rcv_byte == 8'hD5) 
                begin
                  receiving_frame   <= 1;
                  current_state     <= Dest_addr;
                end 
              else
                begin
                  preamble_nvd      <= 1;
                end 
            end
          else 
            begin
              current_state <= End_receiving;
            end
        end
  // ====================== state DESTINATION ADDRESS =========================== /// TODO Add recognition Braodcast and multicast 
      Dest_addr : 
        begin
          if (receiving)
            begin
              if (!rcv_all_i && rcv_byte_flg && rcv_byte != my_mac_i[(5-rcv_byte_count)*8+:8] && rcv_byte != 'hFF)
                address_nvd    <= 1;
              else if (speed_i) 
                begin
                  dst_mac_tmp    <= {dst_mac_tmp[39:0], rcv_byte};
                  current_state  <= (rcv_byte_count == 'h5) ? Src_addr : current_state;
                end 
              else 
                begin
                  dst_mac_tmp    <= (rcv_byte_flg) ? {dst_mac_tmp[39:0], rcv_byte} : dst_mac_tmp;
                  current_state  <= (rcv_byte_count == 'h6) ? Src_addr : current_state;
                end
            end
          else 
            begin
              current_state <= End_receiving;
            end
        end
  // ====================== state SOURCE ADDRESS ================================
      Src_addr :
        begin
          if (receiving)
            begin
              if (speed_i) 
                begin
                  src_mac_tmp    <= {src_mac_tmp[39:0], rcv_byte};     
                  current_state  <= (rcv_byte_count == 'hB) ? Type : current_state;
                end 
              else 
                begin
                  src_mac_tmp    <= (rcv_byte_flg) ? {src_mac_tmp[39:0], rcv_byte} : src_mac_tmp; 
                  current_state  <= (rcv_byte_count == 'hC) ? Type : current_state;
                end
            end
          else
            begin
              current_state <= End_receiving;
            end
        end
  // ====================== state TYPE / LENGTH ================================= /// TODO VLAN Frame
      Type:
        begin
          if (receiving) 
            begin
              typ_byte         <= (rcv_byte_flg) ? !typ_byte  : typ_byte;
              typ_packet_tmp   <= (rcv_byte_flg) ? {typ_packet_tmp[7:0],rcv_byte} : typ_packet_tmp;
              current_state    <= (rcv_byte_flg && typ_byte && pckt_len_flg)? Data_pad : current_state;
            end
          else
            begin
              current_state <= End_receiving;
            end 
        end
  // ====================== state DATA / PAD ===============================  /// TODO Fix Last Bytes  ????
      Data_pad:
        begin
          if (receiving) 
            begin
              if (speed_i) 
                begin
                  pad_len              <= (pad_len) ? pad_len - 1 : pad_len;
                  rcv_data_o           <= {rcv_data_o[24:0],rcv_byte};
                  current_state        <= ((typ_packet_tmp <= (rcv_byte_count - 8'hE)) && !pad_len) ? Frame_check_seq : current_state;
                end 
              else 
                begin
                  pad_len              <= (rcv_byte_flg && pad_len) ? pad_len - 1 : pad_len;
                  rcv_data_o           <= (rcv_byte_flg) ? {rcv_data_o[24:0],rcv_byte} : rcv_data_o;
                  current_state        <= ((typ_packet_tmp <= (rcv_byte_count - 8'hF)) && !pad_len) ? Frame_check_seq : current_state;
                end
            end
          else 
            begin 
              current_state <= End_receiving;
            end 
        end
  // ===================== state Frame Check CRC ===========================
      Frame_check_seq:
        begin
          if (receiving)
            begin
              if (speed_i) 
                begin
                  crc_err_flg         <= (rcv_crc_data_o != rcv_crc_i[rcv_crc_count*8+:8]) ? 'b1 : 'b0;
                  current_state       <= (rcv_crc_count == 4'h3)? End_receiving : current_state;
                  // Alignment for further writing to memory 
                  rcv_data_o          <= {rcv_data_o[24:0],8'b0};
                end 
              else 
                begin
                  crc_err_flg         <= (rcv_crc_data_o != rcv_crc_i[rcv_crc_count*8+:8]) ? 'b1 : 'b0;
                  current_state       <= (rcv_byte_flg && rcv_crc_count == 4'h3)? End_receiving : current_state;
                  // Alignment for further writing to memory 
                  rcv_data_o          <= (rcv_byte_flg) ? {rcv_data_o[24:0],8'b0} : rcv_data_o;
                end
              rcv_crc_count     <= (rcv_byte_flg) ? rcv_crc_count + 'b1 : rcv_crc_count;
            end
          else 
            begin
              current_state <= End_receiving;
            end 
        end
  // ===================== state Frame Check CRC ===========================
      End_receiving:
        begin
          rcv_preamble_byte_count <= '0;
          current_state <= Idle;
          frame_rcv_finished  <= 'b1;
        end 
      endcase
    end
end

endmodule






