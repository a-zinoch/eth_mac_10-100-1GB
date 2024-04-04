`define PAW                 11

module mac_mii_gmii_transmitter
  # (
    
    )
    (
       
        input  logic              clk_i             	//
      , input  logic              reset_i           	//
      
      , input  logic              tran_start_i       	//

      , input  logic              tx_clk_i          	//
      , output logic              tx_en_o           	//
      , output logic  [7:0]       tx_d_o            	//

      , input  logic              crs_i             	//
      , input  logic              col_i             	// collision 
      
      , input  logic              speed_i           	// speed (10/100) or 1000 
      , input  logic  						duplex_i 						// Full-duplex - 1 || half-duplex - 0
      , input  logic              tran_int_en_i      	// transmitter interrupt enable

      , input  logic  [31:0]      tran_data_i        	// data to transmit   
      , output logic              data_sedrd_o  		    // Read strobe output 
      
      , input  logic  [47:0]      tran_dst_mac_i    	// transmit destination MAC address
      , input  logic  [47:0]      tran_src_mac_i    	// transmit source MAC address ( device )
      , input  logic  [15:0]      tran_packet_type_i  // transmiting packet type 
      
      , input  logic  [31:0]      tran_crc_i         	// calculated CRC of packet
      , output logic  [7:0]       crc_data_o    			// data to CRC block
      , output logic              crc_enable_o      	// enable calculate CRC
      , output logic              reset_crc_tran_o   	// reset CRC block  
      
      , output logic              rst_tran_o 		     	// reset current transmit process
      
      , output logic  [13:0]      cnt_byte_tran_o    	// count transmit byte
      
      , output logic              col_err_o         	// collision error
      
      , output logic              int_tran_o          // transmitter interrupt       

  );
 
logic         tran_proc;              	// process of transmit
logic         transmiting_frame;        // indication that the frame is transmiting (State Dest Addr -> State Frame Check CRC)
logic         transmiting_data;         // indication that the Data Field is transmiting
logic         transmiting_fcs_reg;      // indication that the Frame check seq field is transmiting
logic         tran_byte_flg;            // byte transmitted flag
logic         tran_odd_nibble;          // transmitted odd nibble (speed 10/100)
logic [13:0 ] tran_byte_count;          // count of bytes transmitted (only frame without PREAMBLE and SFD)

logic [ 7:0 ] tran_byt_nib_dest_mac;    // Destination mac (byte or nibble) to transmit
logic [ 7:0 ] tran_byt_nib_src_mac;     // Source mac (byte or nibble) to transmit
logic [ 7:0 ] tran_byt_nib_type;        // Type (byte or nibble) to transmit
logic [ 7:0 ] tran_byt_nib_data;        // Data (byte or nibble) to transmit
logic [ 7:0 ] tran_byt_nib_fcs;         // Frame check seq (byte or nibble) to transmit

logic [ 1:0 ] tran_data_byte_sel;       // Data byte selector (1,2,3,4)
logic [ 1:0 ] tran_fcs_byte_sel;        // Frame check seq byte selector

logic         data_rd_flag;             // ready to read data
logic [31:0 ] data_to_tran;             // Data to transmit to the PHY layer (8 nibbles or 4 bytes)
logic [ 7:0 ] tran_data_out;            // Data to transmit to the PHY layer (tx_d_o) 1 byte or nibble depends on speed_i

logic         tran_preamble_conter_en;  // Enable preamble transimiting counter
logic [ 2:0 ] tran_preamble_byte_count; // count of preamble bytes transmitted

logic 				ifg_timer_work; 					// 
logic [ 4:0 ] ifg_timer; 								// inter-frame gap timer

logic 				col_hand_flg; 						// 
logic 				Jam; 											// Enable Jam sequence then collision detected

logic 				start_tran_delay; 				//
logic         start_tran_req;           // Request to start transmission

logic         frame_tran_finished;      // indication that the frame was transmitted successfully
logic         reset_packet_tran_flg; 		// 

// logic         tran_first_byte_flg;      //
logic         tran_wait_flg;            // wait after finished packet


// ===================== STATES ===============================================

typedef enum logic [2:0] {Idle, Preamble, Sfd, Dest_addr, Src_addr, Type, Data_pad, Frame_check_seq} mac_transmitter_states;
mac_transmitter_states current_state;

// ============================================================================

assign int_tran_o                = frame_tran_finished && tran_int_en_i;

assign tx_en_o                   = tran_proc;
assign tx_d_o                    = (transmiting_fcs_reg) ? tran_byt_nib_fcs : tran_data_out;
assign col_hand_flg 						 = !duplex_i && col_i;
assign col_err_o                 = col_hand_flg;
assign reset_packet_tran_flg     = (frame_tran_finished || col_hand_flg);

assign start_tran_req            = tran_start_i;
assign transmiting_frame         = current_state > Sfd;
assign transmiting_data          = current_state == Data_pad;

assign cnt_byte_tran_o           = tran_byte_count;
assign data_rd_flag              = (speed_i) ? (tran_byte_count == 'hC || tran_data_byte_sel == 'h2) : ((tran_byte_count == 'hD || tran_data_byte_sel == 'h3) && tran_byte_flg);  

assign tran_byte_flg             = ((speed_i && tran_proc) || (tran_odd_nibble && tran_proc));
assign tran_preamble_conter_en   = current_state == Preamble;
 

assign tran_byt_nib_dest_mac     = (speed_i) ? tran_dst_mac_i      [{tran_byte_count[2:0],3'b0}+:8] //[8*tran_byte_count+:8]   
                                             : tran_dst_mac_i      [4*(2*tran_byte_count + !tran_byte_flg)+:4];

assign tran_byt_nib_src_mac      = (speed_i) ? tran_src_mac_i      [8*(tran_byte_count - 6)+:8] // [{!tran_bytecount[2] && tran_bytecount[1], !tran_bytecount[1], tran_bytecount[0], 3'b0}] 
                                             : tran_src_mac_i      [4*(2*(tran_byte_count-6) + !tran_byte_flg)+:4];

assign tran_byt_nib_type         = (speed_i) ? tran_packet_type_i  [{tran_byte_count[1:0],3'b0}+:8]  //[8*(tran_byte_count - 12)+:8]
                                             : tran_packet_type_i  [4*(2*(tran_byte_count - 12) + !tran_byte_flg)+:4];

assign tran_byt_nib_data         = (speed_i) ? data_to_tran        [8*tran_data_byte_sel+:8]
                                             : data_to_tran        [4*(2*(tran_data_byte_sel) + !tran_byte_flg)+:4];

assign tran_byt_nib_fcs          = (speed_i) ? tran_crc_i          [8*tran_fcs_byte_sel+:8]
                                             : tran_crc_i          [4*(2*(tran_fcs_byte_sel) + tran_byte_flg)+:4]; 



// ================= tran_odd_nibble =================================================

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) tran_odd_nibble  <= 'b0;
      else          tran_odd_nibble  <= (tran_proc && !speed_i) ? !tran_odd_nibble : 'b0;

// ================= tran_byte_count (count of bytes transmitted) ====================

wire [13:0 ] tran_byte_count_wire = (speed_i && transmiting_frame)        ? tran_byte_count + 1 
                                  : (!tran_byte_flg && transmiting_frame) ? tran_byte_count + 1 
                                                                          : tran_byte_count;

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) tran_byte_count   <= 14'h0;
      else          tran_byte_count   <= tran_byte_count_wire;

// ================= tran_preamble_byte_count (count of preamble bytes transmitted) == 

wire [ 2:0 ] tran_preamble_byte_count_wire = (speed_i && tran_preamble_conter_en)         ? tran_preamble_byte_count + 1 
                                           : (tran_odd_nibble && tran_preamble_conter_en) ? tran_preamble_byte_count + 1 
                                                                                          : tran_preamble_byte_count;

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) tran_preamble_byte_count   <= 3'h0;
      else          tran_preamble_byte_count   <= tran_preamble_byte_count_wire;

// ================= tran_data_byte_sel ==============================================

wire [ 1:0 ] tran_data_byte_sel_wire = (speed_i && transmiting_data)          ? tran_data_byte_sel + 1
                                     : (!tran_byte_flg && transmiting_data)   ? tran_data_byte_sel + 1
                                                                              : tran_data_byte_sel;

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) tran_data_byte_sel  <= 'h0;
      else          tran_data_byte_sel  <= tran_data_byte_sel_wire;

// ================= data_sedrd_o =======================================================

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) data_sedrd_o  <= 'h0;
      else          data_sedrd_o  <= data_rd_flag;

// ================= data_to_tran ====================================================

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) data_to_tran  <= 'h0;
      else          data_to_tran  <= data_sedrd_o ? tran_data_i : data_to_tran;

// ================ tran_fcs_byte_sel ================================================

wire [ 1:0 ] tran_fcs_byte_sel_wire = (speed_i && transmiting_fcs_reg)        ? tran_fcs_byte_sel + 1
                                    : (tran_byte_flg && transmiting_fcs_reg)  ? tran_fcs_byte_sel + 1
                                                                              : tran_fcs_byte_sel;

always_ff @ (posedge tx_clk_i or negedge reset_i)
      if (!reset_i || reset_packet_tran_flg) tran_fcs_byte_sel  <= 'h0;
      else          tran_fcs_byte_sel  <= tran_fcs_byte_sel_wire;


always_ff @ (posedge tx_clk_i or negedge reset_i) begin
// =================================== RESET =======================================
  if (!reset_i || reset_packet_tran_flg) 
  begin
    current_state           <= Idle;
    tran_proc               <= 'b0;
    // crc_err_o               <= 'b0;
    crc_data_o              <= 'b0;
    crc_enable_o            <= 'b0;
    reset_crc_tran_o        <= 'b0;
    frame_tran_finished     <= 'b0;
    transmiting_fcs_reg     <= 'b0; // Можно вынести в отдельный always
  end

  else if(col_hand_flg) begin
    tran_proc               <= 'b0;

  end 

// ==================================== FSM ========================================
  else case (current_state)
// ===================== state Idel ===========================================
    Idle     :
      begin
        tran_proc           <= 'b0;
        reset_crc_tran_o    <= 'b1;   // inverted (reset by negedge)
        // if (frame_tran_finished)
        current_state       <= (start_tran_req) ? Preamble : current_state; 
      end
// ===================== state PREAMBLE =======================================
    Preamble : 
      begin
        tran_proc           <= 'b1;
        tran_data_out       <= (speed_i)? 8'h55 : 4'h5;
        current_state       <= (tran_preamble_byte_count == 'h6) ? Sfd : current_state;
      end
// ====================== state SFD ===========================================
    Sfd : 
      begin
        tran_data_out       <= (speed_i) ? 8'hD5 : (tran_byte_flg) ? 'h5 : 'hD; // ?
        current_state       <= (speed_i) ? Dest_addr : (!tran_byte_flg) ? Dest_addr : current_state;
      end
// ====================== state DESTINATION ADDRESS ===========================
    Dest_addr : 
      begin
        tran_data_out       <= tran_byt_nib_dest_mac;
        crc_enable_o        <= (speed_i) ? 'b1 : (!tran_byte_flg) ? 'b1 : 'b0;
        crc_data_o          <= (speed_i) ? tran_byt_nib_dest_mac : {tran_byt_nib_dest_mac[3:0],crc_data_o[7:4]};
        current_state       <= (speed_i && tran_byte_count == 'h5) ? Src_addr :(tran_byte_count == 'h5 && !tran_byte_flg) ? Src_addr : current_state;
      end
// ====================== state SOURCE ADDRESS ===========================
    Src_addr :
      begin
        tran_data_out       <= tran_byt_nib_src_mac;
        crc_enable_o        <= (speed_i) ? 'b1 : (!tran_byte_flg) ? 'b1 : 'b0;
        crc_data_o          <= (speed_i) ? tran_byt_nib_src_mac : {tran_byt_nib_src_mac[3:0],crc_data_o[7:4]};
        current_state       <= (speed_i && tran_byte_count == 'hB) ? Type :(tran_byte_count == 'hB && !tran_byte_flg) ? Type : current_state;
      end
// ====================== state TYPE / LENGTH ============================
    Type:
      begin
        tran_data_out       <= tran_byt_nib_type;
        crc_enable_o        <= (speed_i) ? 'b1 : (!tran_byte_flg) ? 'b1 : 'b0;
        crc_data_o          <= (speed_i) ? tran_byt_nib_type : {tran_byt_nib_type[3:0],crc_data_o[7:4]};
        current_state       <= (speed_i && tran_byte_count == 'hD) ? Data_pad :(tran_byte_count == 'hD && !tran_byte_flg) ? Data_pad : current_state;
      end
// ====================== state DATA / PAD ===============================
    Data_pad:
      begin
        tran_data_out       <= tran_byt_nib_data;
        crc_enable_o        <= (speed_i) ? 'b1 : (!tran_byte_flg) ? 'b1 : 'b0;
        crc_data_o          <= (speed_i) ? tran_byt_nib_data : {tran_byt_nib_data[3:0],crc_data_o[7:4]};
        current_state       <= (speed_i && tran_byte_count == (tran_packet_type_i + 'hD)) ? Frame_check_seq : (!tran_byte_flg && tran_byte_count == (tran_packet_type_i + 'hD)) ? Frame_check_seq : current_state;
      end
// ====================== state Frame Check CRC ===========================
    Frame_check_seq:
      begin
        crc_enable_o        <= 'b0;
        transmiting_fcs_reg <= 'b1;
        current_state       <= (speed_i && tran_fcs_byte_sel == 'h2) ? Idle : (!tran_byte_flg && tran_fcs_byte_sel == 'h3) ? Idle : current_state;
        frame_tran_finished <= (speed_i && tran_fcs_byte_sel == 'h2) ? 'b1  : (!tran_byte_flg && tran_fcs_byte_sel == 'h3) ? 'b1 : 'b0;
      end
    default:
      begin
        current_state       <= Idle;  
        tran_data_out       <= 'b0;
      end
    endcase
end

endmodule

// 8B 5B 00 00 73 5F 4B 5B 00 00 B5 7B 10 00 B5 7B 73 5F BB 33 FF 88






