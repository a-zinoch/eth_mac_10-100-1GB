`ifndef ETH_MAJOR_ESQ
`define ETH_MAJOR_ESQ

class UniEthTransaction extends denaliEnetTransaction;

   `uvm_object_utils(UniEthTransaction)
   
   function new(string name = "UniEthTransaction");
	 super.new(name); 
   endfunction : new 

   //Overriding constraint 
   constraint PktErrMode_c { PktErrMode == DENALI_ENET_PKTERRORMODE_NO_PKT_ERR;}

   constraint RxDvError_c { RxDvError == 0;}
   constraint TxEnError_c { TxEnError == 0;}

   constraint CrcErr_c { CrcErr == 0;}
   constraint SfdErr_c { SfdErr == 0;}
   constraint LenErr_c { LenErr == 0;}
   constraint LongFrameErr_c { LongFrameErr == 0;}
   constraint ShortFrameErr_c { ShortFrameErr == 0;}

	// constraint CrcErr_c { CrcErr dist { 1 := 1, 0 := 30 } ;}
	// constraint SfdErr_c { SfdErr dist { 1 := 1, 0 := 30 } ;}
	// constraint LenErr_c { LenErr dist { 1 := 1, 0 := 30 } ;}
	// constraint LongFrameErr_c { LongFrameErr dist { 1 := 1, 0 := 30 } ;}
	// constraint ShortFrameErr_c { ShortFrameErr dist { 1 := 1, 0 := 30 } ;}


   constraint AlignmentErr_c { AlignmentErr == 0;}
   constraint PauseOpcodeErr_c { PauseOpcodeErr == 0;}
   constraint PfcPauseOpcodeErr_c { PfcPauseOpcodeErr == 0;} 
   constraint DirectedProtErrSize_c {
	  ProtErrKind.size()   == 0;
	  ProtErrPhase.size()  == 0;
	  ProtErrTiming.size() == 0;
	  ProtErrLength.size() == 0;
   }

   constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR ;}
   constraint Ipg_c { Ipg inside {[96:5000]};}
   constraint OutMode_c { OutMode == DENALI_ENET_PKTOUTMODE_NORMAL;}

   constraint ShortPreambleErr_c { ShortPreambleErr == 0; }
   constraint LongPreambleErr_c { LongPreambleErr == 0; }
   constraint StErr_c {StErr == 0; }
   constraint OpErr_c {OpErr == 0; }
   constraint TaErr_c {TaErr == 0; }
								 
   //Below we can override constraint of  denaliEnetTransaction class and add
   //or overwrite constraint as per requirement. For Example:-
   //constraint PreamblePreambleLength_c {PreamblePreambleLength == 56;}
   
   //Update the transaction once randomization phase is over.
   
   //function void post_randomize();
   // Add logic to modify values of transaction. 
   // 
   //endfunction // post_randomize
	  
endclass: UniEthTransaction

class uvmUniEthSeq extends cdnEnetUvmSequence;

	`uvm_object_utils(uvmUniEthSeq)
	`uvm_declare_p_sequencer(cdnEnetUvmSequencer)

	//creating handle for extended sequence_item UniEthTransaction
	UniEthTransaction pkt;
	logic [47:0] mac_adr = `DUT_MAC_ADR;
	bit full_duplex = 0; // 1 - full_duplex 0 - half duplex
	
	denaliEnetTransaction trans;
	uvm_object obj;

	function new (string name = "uvmUniEthSeq");
		super.new(name);
	endfunction : new

	task pkt_wait();
		// p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger();
		p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger_data(obj);
		// `uvm_warning(get_full_name(), obj.sprint());

		if(!this.full_duplex) begin
			fork 
				begin
					#60000ns;
				end
	
				begin
					p_sequencer.pAgent.monitor.RxPktEndedPktCbEvent.wait_trigger();
				end
			join_any
		end
	endtask : pkt_wait

	virtual task body();
		int regValue;

		//Raise objection is used to control the finish of test
		//Unless this objection is dropped test will not end.
		if (starting_phase != null) begin
			`uvm_info(get_full_name(), "sequence eth_universal_seq", UVM_LOW);
			starting_phase.raise_objection(this);
		end

		//Waiting for reset to get over.  
		`uvm_info(get_full_name(), "sequence eth_universal_seq waiting for reset to end", UVM_HIGH);
		p_sequencer.pAgent.monitor.ResetDeassertedCbEvent.wait_trigger();

		#500ns;

		/*read DENALI_ENET_REG_DuplexKind*/
		// regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_DuplexKind);
		// full_duplex = regValue&'h01; 
		`ifdef HALF_DUPLEX
			full_duplex = 0;
		`else
			full_duplex = 1;
		`endif
		`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_DuplexKind value = %d",full_duplex),UVM_NONE);

		// Setting Messsage verbosity to HIGH
		p_sequencer.pAgent.regInst.writeReg(DENALI_ENET_REG_Verbosity,3);
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_Verbosity);
		`uvm_info(get_full_name(),$psprintf("ActivePhy:: reading DENALI_ENET_REG_Verbosity value = %d",regValue),UVM_HIGH);

		`uvm_info(get_full_name(), "sequence eth_universal_seq started", UVM_HIGH);

		repeat(10) begin 
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				// PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_MAGIC,DENALI_ENET_PACKETKIND_ETHERNET_802_3,DENALI_ENET_PACKETKIND_ETHERNET_VII,DENALI_ENET_PACKETKIND_ETHERNET_SNAP};
				PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_802_3};
				DestAddrLow == mac_adr[31:0];
				DestAddrHigh == mac_adr[47:32];
				})

			pkt_wait();						
		end

		//This delay is to finish test gracefully. 
		#500000;

		if (starting_phase != null) begin
			`uvm_info(get_full_name(), "sequence uvmUniEthSeq", UVM_LOW);
			starting_phase.drop_objection(this);
		end
		$finish();	

	endtask : body

endclass : uvmUniEthSeq

`endif //ETH_SEQUENCE_NEW_LIB
