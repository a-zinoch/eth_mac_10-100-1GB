`ifndef ETH_FD_SEQ
`define ETH_FD_SEQ

class eth_fd_trans extends denaliEnetTransaction;

	`uvm_object_utils(eth_fd_trans)

	logic [47:0] dut_mac_adr = `VIP_MAC_ADR;

	rand int unsigned err_count;

	function new(string name = "eth_fd_trans");
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
		constraint RxDvError_c { RxDvError == 1;}
		constraint TxEnError_c { TxEnError == 1;}
		constraint CrcErr_c { CrcErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint SfdErr_c { SfdErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LenErr_c { LenErr == 0;}
		// constraint LenErr_c { LenErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LongFrameErr_c { LongFrameErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint ShortFrameErr_c { ShortFrameErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		// constraint AlignmentErr_c { AlignmentErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint ShortPreambleErr_c { ShortPreambleErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		constraint LongPreambleErr_c { LongPreambleErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		// constraint PktErrMode_c { PktErrMode dist {
		// 	DENALI_ENET_PKTERRORMODE_NO_PKT_ERR := `ERROR_RATIO,
		// 	DENALI_ENET_PKTERRORMODE_SINGLE_PKT_ERR := 1,
		// 	DENALI_ENET_PKTERRORMODE_MULTI_PKT_ERR :=  1};
		// }
		// constraint PauseOpcodeErr_c { PauseOpcodeErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
		// constraint PfcPauseOpcodeErr_c { PfcPauseOpcodeErr dist { 1 := 1, 0 := `ERROR_RATIO } ;}
	`endif

	`ifndef PROT_ERROR_EN
		constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR;}
	`else
		constraint ProtErrMode_c { ProtErrMode dist {
			DENALI_ENET_PROTERRORMODE_NO_PROT_ERR := `ERROR_RATIO,
			DENALI_ENET_PROTERRORMODE_SINGLE_PROT_ERR_KIND := 1,
			DENALI_ENET_PROTERRORMODE_MULTI_PROT_ERR_KIND :=  1};
		}
	`endif


	`ifdef DMA_READ_EN
		 constraint Ipg_c { Ipg inside {[40000:70000]};}
	`else
		// constraint Ipg_c { Ipg inside {[96:5000]};}
		constraint Ipg_c { Ipg inside {[250000:350000]};}
		// constraint Ipg_c { Ipg dist {[96:5000] := 50, 512 := 1};}
	`endif

	constraint DestAddrKind_c{
		DestAddrKind dist {
			DENALI_ENET_DESTADDRKIND_BROADCAST := 1,
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


	constraint OutMode_c { OutMode == DENALI_ENET_PKTOUTMODE_NORMAL;}

	constraint StErr_c {StErr == 0; }
	constraint OpErr_c {OpErr == 0; }
	constraint TaErr_c {TaErr == 0; }

endclass: eth_fd_trans

class eth_fd_pkt_fifo #(type T = int) extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	T queue[$];

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_fd_pkt_fifo)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_fd_seq");
		super.new(name);
	endfunction : new

endclass : eth_fd_pkt_fifo

class eth_rx_cb #(type T = denaliEnetTransaction) extends uvm_event_callback;
	eth_fd_pkt_fifo #(T) fifo;

	`uvm_object_utils(eth_rx_cb)

	function new (string name = "eth_rx_cb");
		super.new(name);
	endfunction : new

	function bit packet_predict(denaliEnetTransaction tx_pkt, logic [47:0] ref_adr);
		int i,max_time,index, ipg;

		i = 0;
		max_time = 0;

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

		if(tx_pkt.ProtErrTiming.size() != 0 &&
			tx_pkt.ProtErrMode != DENALI_ENET_PROTERRORMODE_NO_PROT_ERR ) begin
			foreach(tx_pkt.ProtErrTiming[i]) begin
				if(max_time < tx_pkt.ProtErrTiming[i]) begin
					max_time = tx_pkt.ProtErrTiming[i];
					index = i;
				end
			end

			ipg = tx_pkt.Ipg>>2;

			// if(tx_pkt.PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) begin
			// 	ipg = ipg - 'h6d;
			// end

			// if(tx_pkt.PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_MAGIC) begin
			// 	ipg = ipg - 'hba7;
			// end

			i = tx_pkt.ProtErrTiming[index] + tx_pkt.ProtErrLength[index];
			`uvm_error(get_full_name(), $psprintf("Worst packet %x %x %x",ipg,i,index));
			// if(tx_pkt.ProtErrKind[i] != DENALI_ENET_PROTERRKIND_IPG_RX_ER)
			// 	return 1;

			if((tx_pkt.ProtErrPhase[index] == DENALI_ENET_PACKETPHASE_IPG &&
				i >= ipg) && (tx_pkt.ProtErrKind[index] == DENALI_ENET_PROTERRKIND_IPG_RX_ER ||
				tx_pkt.ProtErrKind[index] == DENALI_ENET_PROTERRKIND_FALSE_CARRIER_INDICATION)) begin
				`uvm_error(get_full_name(), $psprintf("Worst packet %x %x %x",tx_pkt.Ipg,i,index));
				return 0;
			end
		end

		return 1;
	endfunction : packet_predict

	function bit packet_check(T rx_pkt,T tx_pkt);
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
				// $fwriteh(mcd, " Rx_Pkt ", rx_pkt.DataPayload);
				// $fwriteh(mcd, " Tx_Pkt ", tx_pkt.DataPayload);
				$fclose(mcd);
				`uvm_error(get_full_name(), $psprintf("Data error! %x %x %x", i, rx_pkt.DataPayload[i], tx_pkt.DataPayload[i]));
				return 0;
			end
		end

		return 1;
	endfunction : packet_check

	function bit pre_trigger(uvm_event e, uvm_object data);
		T rx_data, tx_data;
		$cast(rx_data, data);

		do begin
			if(fifo.queue.size() != 0) begin
				tx_data = fifo.queue.pop_back();
			end else begin
				`uvm_error(get_full_name(), "Queue is empty!");
				return 1;
			end
			// $display("---------------------- %x", tx_data.LengthType);
		// end while(!tx_data.LegalPacket);
		end while(!packet_predict(tx_data,`VIP_MAC_ADR));

		if(packet_check(rx_data, tx_data)) begin
			`uvm_error(get_full_name(), "Ok");
			return 1;
		end else begin
			`uvm_error(get_full_name(), "Invalid packet");
			return 0;
		end

	endfunction : pre_trigger

	function void post_trigger(uvm_event e, uvm_object data);
		assert(0) begin
		end else begin
			$finish();
		end
	endfunction : post_trigger

endclass : eth_rx_cb

class eth_fd_sequence extends cdnEnetUvmSequence;

	`uvm_object_utils(eth_fd_sequence)
	`uvm_declare_p_sequencer(cdnEnetUvmSequencer)

	int n = `PACKET_COUNT;
	eth_rx_cb #(denaliEnetTransaction) rx_cb;
	eth_fd_pkt_fifo #(denaliEnetTransaction) fifo;

	function new (string name = "eth_fd_sequence");
		super.new(name);
	endfunction : new

	task transmitter();
		uvm_object obj;
		eth_fd_trans pkt;
		denaliEnetTransaction tmp_trans;

		repeat(n) begin
			`ifndef UPPER_LEVEL_PKT
				`uvm_do_with(pkt,{
						TagKind inside {DENALI_ENET_TAGKIND_UNTAGGED
							// ,DENALI_ENET_TAGKIND_VLAN_DOUBLE_TAG
							// ,DENALI_ENET_TAGKIND_VLAN_TAG
							// ,DENALI_ENET_TAGKIND_CUSTOM_VLAN_TAG
						};
						UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
						Type == DENALI_ENET_TR_pkt;
						PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_MAGIC,
							DENALI_ENET_PACKETKIND_ETHERNET_802_3,
							DENALI_ENET_PACKETKIND_ETHERNET_VII,
							DENALI_ENET_PACKETKIND_ETHERNET_SNAP,
							`ifdef FULL_DUPLEX
							DENALI_ENET_PACKETKIND_ETHERNET_PAUSE,
							`endif
							DENALI_ENET_PACKETKIND_ETHERNET_JUMBO
							// DENALI_ENET_PACKETKIND_ETHERNET_PFC_PAUSE
						};
						(PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) -> DataLength dist {[0:399] := 10,[400:999] := 20,[1000:1800] := 70};
						// (PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) -> DataLength dist {[0:50] := 10,[0:50] := 20,[0:50] := 70};
						(PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_PAUSE) -> TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
						(PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_JUMBO) -> LongFrameErr == 0;
						// (PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_PAUSE) -> PauseOpcodeErr dist { 1 := 1, 0 := `ERROR_RATIO };
						// (PacketKind==DENALI_ENET_PACKETKIND_ETHERNET_PFC_PAUSE) -> PfcPauseOpcodeErr dist { 1 := 1, 0 := `ERROR_RATIO };
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
					TagKind inside {DENALI_ENET_TAGKIND_UNTAGGED
						,DENALI_ENET_TAGKIND_VLAN_DOUBLE_TAG
						,DENALI_ENET_TAGKIND_VLAN_TAG
						,DENALI_ENET_TAGKIND_CUSTOM_VLAN_TAG
					};
					UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_UNSET;
					})
			`endif

			p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger_data(obj);
			$cast(tmp_trans, obj);
			fifo.queue.push_front(tmp_trans);
			// `uvm_warning(get_full_name(), $psprintf("+++++++++++++++++++Size of queue : %x, tl : %x ", fifo.queue.size, tmp_trans.LengthType ));
		end
	endtask : transmitter

	virtual task body();
		int regValue;
		denaliEnetTransaction pkt;

		rx_cb = new ("rx_cb");
		fifo = new ("fifo");
		rx_cb.fifo = fifo;

		//Raise objection is used to control the finish of test
		//Unless this objection is dropped test will not end.
		if (starting_phase != null) begin
			`uvm_info(get_full_name(), "sequence eth_universal_seq", UVM_NONE);
			starting_phase.raise_objection(this);
		end

		//Waiting for reset to get over.
		`uvm_info(get_full_name(), "sequence eth_universal_seq waiting for reset to end", UVM_NONE);
		p_sequencer.pAgent.monitor.ResetDeassertedCbEvent.wait_trigger();

		#500ns;

		// Setting Messsage verbosity to HIGH
		p_sequencer.pAgent.regInst.writeReg(DENALI_ENET_REG_Verbosity, 3);
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_Verbosity);
		`uvm_info(get_full_name(),$psprintf("ActivePhy:: reading DENALI_ENET_REG_Verbosity value = %d",regValue),UVM_MEDIUM);

		p_sequencer.pAgent.monitor.RxPktEndedPktCbEvent.add_callback(rx_cb, 1);

		transmitter();

		#5000000;


		if(fifo.queue.size() != 0) begin
			while(fifo.queue.size() > 0) begin
				pkt = fifo.queue.pop_back();
				if(rx_cb.packet_predict(pkt, `VIP_MAC_ADR)) begin
					`uvm_fatal(get_full_name(), $psprintf("Test fail! Fifo has valid packets!(%x)", fifo.queue.size()));
				end
			end
			`uvm_info(get_full_name(), "Test Ok! Fifo has invalid packets!", UVM_NONE);
		end else begin
			`uvm_info(get_full_name(), "Test Ok!", UVM_NONE);
		end

		if (starting_phase != null) begin
			starting_phase.drop_objection(this);
		end
		$finish();

	endtask : body

endclass : eth_fd_sequence

`endif
