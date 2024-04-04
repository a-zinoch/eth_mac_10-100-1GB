`ifndef ETH_HD_SEQ
`define ETH_HD_SEQ

class eth_hd_trans extends denaliEnetTransaction;

	`uvm_object_utils(eth_hd_trans)

	logic [47:0] dut_mac_adr = `VIP_MAC_ADR; 

	function new(string name = "eth_hd_trans");
		super.new(name); 
	endfunction : new 

	//Overriding constraint 
	constraint PktErrMode_c { PktErrMode == DENALI_ENET_PKTERRORMODE_NO_PKT_ERR;}

	`ifndef ERROR_ENABLE
		constraint RxDvError_c { RxDvError == 0;}
		constraint TxEnError_c { TxEnError == 0;}
		constraint CrcErr_c { CrcErr == 0;}
		constraint SfdErr_c { SfdErr == 0;}
		constraint LenErr_c { LenErr == 0;}
		constraint LongFrameErr_c { LongFrameErr == 0;}
		constraint ShortFrameErr_c { ShortFrameErr == 0;}
		constraint AlignmentErr_c { AlignmentErr == 0;}
		constraint ShortPreambleErr_c { ShortPreambleErr == 0; }
		constraint LongPreambleErr_c { LongPreambleErr == 0; }
	`else
		constraint RxDvError_c { RxDvError == 0;}
		constraint TxEnError_c { TxEnError == 0;}
		constraint CrcErr_c { CrcErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint SfdErr_c { SfdErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LenErr_c { LenErr == 0;}
		// constraint LenErr_c { LenErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LongFrameErr_c { LongFrameErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint ShortFrameErr_c { ShortFrameErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint AlignmentErr_c { AlignmentErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint ShortPreambleErr_c { ShortPreambleErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LongPreambleErr_c { LongPreambleErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
	`endif

	`ifndef PROT_ERROR_EN
		constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR;}
		constraint DirectedProtErrSize_c {
			ProtErrKind.size()   == 0;
			ProtErrPhase.size()  == 0;
			ProtErrLength.size() == 0;
			ProtErrTiming.size() == 0;
		}
	`else
		constraint ProtErrMode_c {ProtErrMode dist {
			DENALI_ENET_PROTERRORMODE_NO_PROT_ERR := `ERROR_RATIO,
			DENALI_ENET_PROTERRORMODE_SINGLE_PROT_ERR_KIND := 1, 
			DENALI_ENET_PROTERRORMODE_MULTI_PROT_ERR_KIND := 1 
			};
		}
		// constraint ProtOrderErr {
		// 	solve ProtErrMode before ;
		// }
		// constraint ProtErrGenMode_c	{
		// 	ProtErrGenMode == DENALI_ENET_PROTERRORGENMODE_RANDOM_PROT_ERR;
		// 	// foreach(ProtErrKind[i]) ProtErrKind[i] inside {
		// 	// 	DENALI_ENET_PROTERRKIND_UNSET,
		// 	// 	// DENALI_ENET_PROTERRKIND_FALSE_CARRIER_INDICATION,
		// 	// 	DENALI_ENET_PROTERRKIND_RX_ER,
		// 	// 	DENALI_ENET_PROTERRKIND_IPG_RX_ER,
		// 	// 	DENALI_ENET_PROTERRKIND_RX_DV_DOWN,
		// 	// 	DENALI_ENET_PROTERRKIND_CRS_DV_DOWN,
		// 	// 	// DENALI_ENET_PROTERRKIND_CRS_DOWN_COLLECT,
		// 	// 	DENALI_ENET_PROTERRKIND_CRS_DOWN_INJECT,
		// 	// 	DENALI_ENET_PROTERRKIND_COLLISION,
		// 	// 	DENALI_ENET_PROTERRKIND_TX_ER,
		// 	// 	// DENALI_ENET_PROTERRKIND_RX_CARRIER_EXTENSION_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_TX_CARRIER_EXTENSION_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_START_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_DATA_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_INVALID_CONTROL_CHARACTER,
		// 	// 	// DENALI_ENET_PROTERRKIND_REMOTE_FAULT,
		// 	// 	// DENALI_ENET_PROTERRKIND_LOCAL_FAULT,
		// 	// 	DENALI_ENET_PROTERRKIND_RESERVED_SEQUENCE_ORDERED_SET,
		// 	// 	// DENALI_ENET_PROTERRKIND_TERMINATION_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_INVALID_CODE,
		// 	// 	// DENALI_ENET_PROTERRKIND_DESKEW_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_INVALID_SYNC_HEADER,
		// 	// 	// DENALI_ENET_PROTERRKIND_INVALID_BLOCK_TYPE_FIELD,
		// 	// 	DENALI_ENET_PROTERRKIND_NOT_DEFINED,
		// 	// 	// DENALI_ENET_PROTERRKIND_SMII_JABBER_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_SMII_LINK_DOWN,
		// 	// 	// DENALI_ENET_PROTERRKIND_TX_DUPLICATION_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_RX_DUPLICATION_ERROR,
		// 	// 	// DENALI_ENET_PROTERRKIND_RGMII_LINK_DOWN,
		// 	// 	// DENALI_ENET_PROTERRKIND_CARRIER_SENSE,
		// 	// 	DENALI_ENET_PROTERRKIND_SIGNAL_ORDER_FAULT,
		// 	// 	DENALI_ENET_PROTERRKIND_INVALID_CHARACTER,
		// 	// 	DENALI_ENET_PROTERRKIND_INVALID_AM_PATTERN,
		// 	// 	DENALI_ENET_PROTERRKIND_INVALID_BIP3_ERROR,
		// 	// 	DENALI_ENET_PROTERRKIND_INVALID_DATA_OCTET,
		// 	// 	DENALI_ENET_PROTERRKIND_INVALID_BIP7_ERROR,
		// 	// 	DENALI_ENET_PROTERRKIND_IPG_INVALID_RX_ER,
		// 	// 	DENALI_ENET_PROTERRKIND_IPG_INVALID_TX_ER
		// 	// 	// DENALI_ENET_PROTERRKIND_IPG_TX_INVALID_CODE,
		// 	// 	// DENALI_ENET_PROTERRKIND_IPG_RX_INVALID_CODE
		// 	// };
		// }
	`endif

	`ifdef DMA_READ_EN
		constraint Ipg_c { Ipg inside {[500:5000]};}
	`else
		constraint Ipg_c { Ipg inside {[96:100]};}
	`endif

	constraint DestAddrKind_c{
		DestAddrKind dist {
			DENALI_ENET_DESTADDRKIND_BROADCAST := 1000,
			DENALI_ENET_DESTADDRKIND_MULTICAST := 1,
			DENALI_ENET_DESTADDRKIND_UNSET := 1, 
			DENALI_ENET_DESTADDRKIND_UNICAST := 7 		
		};
	}

	constraint DestAddr_c {
		solve DestAddrKind before DestAddrHigh,DestAddrLow;
		(DestAddrKind == DENALI_ENET_DESTADDRKIND_UNICAST) -> (DestAddrHigh == dut_mac_adr[47:32]);
		(DestAddrKind == DENALI_ENET_DESTADDRKIND_UNICAST) -> (DestAddrLow == dut_mac_adr[31:0]);
		(DestAddrKind == DENALI_ENET_DESTADDRKIND_BROADCAST) -> (DestAddrHigh == 'hFFFF);
		(DestAddrKind == DENALI_ENET_DESTADDRKIND_BROADCAST) -> (DestAddrLow =='hFFFF_FFFF);
	}

	constraint PauseOpcodeErr_c { PauseOpcodeErr == 0;}
	constraint PfcPauseOpcodeErr_c { PfcPauseOpcodeErr == 0;} 
	
	constraint OutMode_c { OutMode == DENALI_ENET_PKTOUTMODE_NORMAL;}

	constraint StErr_c {StErr == 0; }
	constraint OpErr_c {OpErr == 0; }
	constraint TaErr_c {TaErr == 0; }
					
	// function void post_randomize;
	// 	super.post_randomize(); 
	// 	// if(DestAddrKind == DENALI_ENET_DESTADDRKIND_UNICAST) begin
	// 	// 	DestAddrHigh = dut_mac_adr[47:32];
	// 	// 	DestAddrLow = dut_mac_adr[31:0];
	// 	// 	`uvm_error(get_full_name(),"post randomize!!!");
	// 	// end
	// 	`uvm_warning(get_full_name(), $psprintf("Size of ProtErr array %x", ProtErrKind.size()));
	// endfunction
endclass: eth_hd_trans

class eth_hd_sequence extends cdnEnetUvmSequence;

	`uvm_object_utils(eth_hd_sequence)
	`uvm_declare_p_sequencer(cdnEnetUvmSequencer)

	bit receive_ok;
	int n = `PACKET_COUNT;
	denaliEnetTransaction queue[$];

	function new (string name = "eth_hd_sequence");
		super.new(name);
	endfunction : new

	task transceiver();
		uvm_object obj;
		eth_hd_trans pkt;
		denaliEnetTransaction tmp_pkt;

		pkt = eth_hd_trans::type_id::create("pkt");

		#8500ns;

		repeat(n) begin
			`ifndef UPPER_LEVEL_PKT
				`uvm_do_with(pkt,{
						TagKind inside {DENALI_ENET_TAGKIND_UNTAGGED,
							DENALI_ENET_TAGKIND_VLAN_DOUBLE_TAG,
							DENALI_ENET_TAGKIND_VLAN_TAG
						};
						UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
						Type == DENALI_ENET_TR_pkt;
						PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_MAGIC,
							DENALI_ENET_PACKETKIND_ETHERNET_802_3,
							DENALI_ENET_PACKETKIND_ETHERNET_VII,
							DENALI_ENET_PACKETKIND_ETHERNET_SNAP,
							// DENALI_ENET_PACKETKIND_ETHERNET_PAUSE,
							DENALI_ENET_PACKETKIND_ETHERNET_JUMBO
						};
						(PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) -> DataLength dist {[0:399] := 10,[400:999] := 20,[1000:1800] := 70};
						(PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) -> LongFrameErr == 0;
					})
			`else
				`uvm_do_with(pkt,{
					Type == DENALI_ENET_TR_transportPkt;
					TransportKind inside {DENALI_ENET_TRANSPORTKIND_TCP, DENALI_ENET_TRANSPORTKIND_UDP};
					NetworkKind inside {DENALI_ENET_NETWORKKIND_IPV6, DENALI_ENET_NETWORKKIND_IPV4};
					})

				`uvm_do_with(pkt,{
					Type == DENALI_ENET_TR_mplsPkt;
					MplsKind == DENALI_ENET_MPLSKIND_NO_MPLS;
					})

				`uvm_do_with(pkt,{
					Type == DENALI_ENET_TR_snapPkt;
					SnapKind == DENALI_ENET_SNAPKIND_NO_SNAP;
					})

				`uvm_do_with(pkt,{
					Type == DENALI_ENET_TR_pkt;
					PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_802_3;
					TagKind inside {DENALI_ENET_TAGKIND_UNTAGGED,
						DENALI_ENET_TAGKIND_VLAN_DOUBLE_TAG,
						DENALI_ENET_TAGKIND_VLAN_TAG
					};
					UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_UNSET;
					})
			`endif

			p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger_data(obj);
			$cast(tmp_pkt, obj);
			if(packet_predict(tmp_pkt, `VIP_MAC_ADR)) begin
				queue.push_front(tmp_pkt);
			end else begin
				#5000ns;
				continue;
			end


			fork 
				begin
					#200000ns; // max waiting time
					assert(0) begin 
					end else begin
						$finish();
					end
				end
	
				begin
					p_sequencer.pAgent.monitor.RxPktEndedPktCbEvent.wait_trigger_data(obj);
					$cast(tmp_pkt, obj);
					if(packet_check(tmp_pkt, queue.pop_back())) begin
						`uvm_error(get_full_name(), "Ok");
					end else begin
						`uvm_error(get_full_name(), "Invalid packet");
						`uvm_error(get_full_name(), $psprintf("%x", queue.size));	
						assert(0) begin 
						end else begin
							$finish();
						end
					end
				end
			join_any
			disable fork; 
			// #5000ns;
		end
	endtask : transmitter

	virtual task body();
		int regValue;

		//Raise objection is used to control the finish of test
		//Unless this objection is dropped test will not end.
		if (starting_phase != null) begin
			`uvm_info(get_full_name(), "sequence eth_universal_seq", UVM_MEDIUM);
			starting_phase.raise_objection(this);
		end

		//Waiting for reset to get over.  
		`uvm_info(get_full_name(), "sequence eth_universal_seq waiting for reset to end", UVM_MEDIUM);
		p_sequencer.pAgent.monitor.ResetDeassertedCbEvent.wait_trigger();

		#500ns;

		// Setting Messsage verbosity to HIGH
		p_sequencer.pAgent.regInst.writeReg(DENALI_ENET_REG_Verbosity,3);
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_Verbosity);
		`uvm_info(get_full_name(),$psprintf("ActivePhy:: reading DENALI_ENET_REG_Verbosity value = %d",regValue),UVM_MEDIUM);

		// p_sequencer.pAgent.monitor.RxPktEndedPktCbEvent.add_callback(rx_cb, 1);

		// #10000;

		transceiver();

		#500000;

		if(queue.size != 0) begin
			`uvm_fatal(get_full_name(), "Test fail!");
		end

		if (starting_phase != null) begin
			starting_phase.drop_objection(this);
		end
		$finish();	

	endtask : body

	function bit packet_predict(denaliEnetTransaction tx_pkt, logic [47:0] ref_adr);
		int i,j;
		if(!tx_pkt.LegalPacket) begin
			return 0;
		end

		if(tx_pkt.DestAddrKind == DENALI_ENET_DESTADDRKIND_BROADCAST ||
				tx_pkt.DestAddrKind == DENALI_ENET_DESTADDRKIND_MULTICAST) begin
			return 1;
		end 

		if({tx_pkt.DestAddrHigh, tx_pkt.DestAddrLow} != ref_adr) begin
			return 0;
		end

		if(tx_pkt.ProtErrTiming.size() != 0) begin
			i = tx_pkt.ProtErrTiming.size() - 1;
			j = tx_pkt.ProtErrTiming[i] + tx_pkt.ProtErrLength[i];

			if(tx_pkt.ProtErrKind[i] != DENALI_ENET_PROTERRKIND_IPG_RX_ER)
				return 1;

			if(tx_pkt.ProtErrPhase[i] == DENALI_ENET_PACKETPHASE_IPG ||
				j > tx_pkt.Ipg)
				return 0;
		end

		return 1;
	endfunction : addr_check


	function bit packet_check(denaliEnetTransaction rx_pkt,denaliEnetTransaction tx_pkt);
		integer mcd;
		if(!rx_pkt.LegalPacket) begin 
			`uvm_error(get_full_name(), "Illegal packet");
			return 0;
		end 

		if(rx_pkt.Type != tx_pkt.Type) begin 
			`uvm_error(get_full_name(), "Non valid type of packet");
			return 0;
		end 

		if(rx_pkt.LengthType != tx_pkt.LengthType) begin 
			`uvm_error(get_full_name(), "Length/type field different from reference");
			`uvm_error(get_full_name(), $psprintf("%x, %x", rx_pkt.LengthType, tx_pkt.LengthType));
			return 0;
		end 

		if(rx_pkt.DataPayload.size != tx_pkt.DataPayload.size) begin 
			if(rx_pkt.DataPayload.size != tx_pkt.DataPayload.size + tx_pkt.PadsizePkt) begin
				`uvm_error(get_full_name(), "Size of data payload different from reference");
				`uvm_error(get_full_name(), $psprintf("%x, %x", rx_pkt.DataPayload.size, tx_pkt.DataPayload.size));
				return 0;
			end
		end 

		// for(int i = 0; i < rx_pkt.DataPayload.size; i++) begin
		// 	if(rx_pkt.DataPayload[i] != tx_pkt.DataPayload[i]) begin
		// 		return 0;
		// 	end
		// end

		for(int i = 0; i < rx_pkt.DataPayload.size; i++) begin
			if(rx_pkt.DataPayload[i] != tx_pkt.DataPayload[i]) begin
				mcd = $fopen("xyz.txt");
				for(int j = 0; j < rx_pkt.DataPayload.size; j++) begin
					if(rx_pkt.DataPayload[j] != tx_pkt.DataPayload[j]) begin
						$fdisplay(mcd, " \tData[%d] %x | %x",j ,rx_pkt.DataPayload[j], tx_pkt.DataPayload[j]); 
					end else begin
						$fdisplay(mcd, " Data[%d] %x | %x",j ,rx_pkt.DataPayload[j], tx_pkt.DataPayload[j]);
					end 
				end
				$fclose(mcd);
				`uvm_error(get_full_name(), $psprintf("Data error! %x %x %x", i, rx_pkt.DataPayload[i], tx_pkt.DataPayload[i]));
				return 0;
			end
		end

		return 1;
	endfunction : packet_check

endclass : eth_hd_sequence

`endif