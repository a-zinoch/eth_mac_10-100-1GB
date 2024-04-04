`ifndef ETH_SEQUENCE_LIB
`define ETH_SEQUENCE_LIB

class myEnetTransaction extends denaliEnetTransaction;

   `uvm_object_utils(myEnetTransaction)
   
   function new(string name = "myEnetTransaction");
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
   constraint AlignmentErr_c { AlignmentErr == 0;}
   constraint PauseOpcodeErr_c { PauseOpcodeErr == 0;}
   constraint PfcPauseOpcodeErr_c { PfcPauseOpcodeErr == 0;} 
   constraint DirectedProtErrSize_c {
	  ProtErrKind.size()   == 0;
	  ProtErrPhase.size()  == 0;
	  ProtErrTiming.size() == 0;
	  ProtErrLength.size() == 0;
   }

   constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR;}
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
	  
endclass: myEnetTransaction


//Extend the Ethernet trans for adding constraints
class ErrorEnetTransaction extends denaliEnetTransaction;
  `uvm_object_utils(ErrorEnetTransaction)
  
  function new(string name = "ErrorEnetTransaction");
	super.new(name); 
  endfunction : new 

  constraint err_gen {ProtErrKind.size() == 0;}
  constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR;}

  constraint LongFrameErr_c {
	 LongFrameErr == 1 -> PacketKind dist {DENALI_ENET_PACKETKIND_ETHERNET_802_3:=50,
									 DENALI_ENET_PACKETKIND_ETHERNET_PAUSE:=25,
									 DENALI_ENET_PACKETKIND_ETHERNET_MAGIC:=25};
  }

endclass


//Extend the Ethernet trans for adding constraints
class CrcErrorEnetTransaction extends denaliEnetTransaction;
  `uvm_object_utils(CrcErrorEnetTransaction)
  
  function new(string name = "CrcErrorEnetTransaction");
	super.new(name); 
  endfunction : new 

   constraint err_gen {ProtErrKind.size() == 0;}
   constraint ProtErrMode_c { ProtErrMode == DENALI_ENET_PROTERRORMODE_NO_PROT_ERR;}
   constraint LenErr_c { LenErr == 0;}

endclass


class PadSizeTransaction extends myEnetTransaction;
  `uvm_object_utils(PadSizeTransaction)
  
  function new(string name = "PadSizeTransaction");
	super.new(name); 
  endfunction : new 

//Following is the alternative solution to generate Pads. This needs 
//few modifications to be more intutive.
 constraint LenErr_c { LenErr == 1;}
 constraint PadsizePkt_a {DataLength == 46;}  
 constraint PadSize_LengthType {LengthType inside  {[1:45]};}

endclass


class DataLengthTransaction extends myEnetTransaction;
  `uvm_object_utils(DataLengthTransaction)
  
  function new(string name = "DataLengthTransaction");
	super.new(name); 
  endfunction : new 

  constraint DataLength_cov{ 
	   PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_802_3,DENALI_ENET_PACKETKIND_ETHERNET_VII,DENALI_ENET_PACKETKIND_ETHERNET_SNAP,DENALI_ENET_PACKETKIND_ETHERNET_PAUSE,DENALI_ENET_PACKETKIND_ETHERNET_PFC_PAUSE} -> DataLength inside {1,3,20,[40:45],[1001:1495],[1496:1500]}; }  

endclass


class IllegalIpgTransaction extends myEnetTransaction;
  `uvm_object_utils(IllegalIpgTransaction)
  
  function new(string name = "IllegalIpgTransaction");
	super.new(name); 
  endfunction : new 

  //Overwriting Ipg constraint present in myEnetTransaction class
  constraint Ipg_c { Ipg inside {[20:41]}; }  

endclass

class uvmEthPhyHalf extends cdnEnetUvmSequence;

	`uvm_object_utils(uvmEthPhyHalf)
	`uvm_declare_p_sequencer(cdnEnetUvmSequencer)

	//creating handle for extended sequence_item myEnetTransaction
	myEnetTransaction pkt;

	function new (string name = "uvmEthPhyHalf");
	super.new(name);
	endfunction : new

	task pkt_wait();
		p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger();
		fork 
			begin
				#60000ns;
			end

			begin
				p_sequencer.pAgent.monitor.RxPktEndedPktCbEvent.wait_trigger();
			end
		join_any
	endtask : pkt_wait

	virtual task body();
		int regValue;

		//Raise objection is used to control the finish of test
		//Unless this objection is dropped test will not end.
		if (starting_phase != null) begin
		 `uvm_info(get_full_name(), "sequence uvmEthPhyHalf", UVM_LOW);
		 starting_phase.raise_objection(this);
		end

		//Waiting for reset to get over.  
		`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for reset to end", UVM_HIGH);
		p_sequencer.pAgent.monitor.ResetDeassertedCbEvent.wait_trigger();

		`uvm_info(get_full_name(), "sequence uvmEthPhyHalf:: Register read write in process", UVM_HIGH);
		// Setting Messsage verbosity to HIGH
		p_sequencer.pAgent.regInst.writeReg(DENALI_ENET_REG_Verbosity,3);
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_Verbosity);
		`uvm_info(get_full_name(),$psprintf("ActivePhy:: reading DENALI_ENET_REG_Verbosity value = %d",regValue),UVM_HIGH);

		`uvm_info(get_full_name(), "sequence uvmEthPhyHalf started", UVM_HIGH);

		repeat(10) begin
			//Starting randomization of pkt.
			// This will generate a basic ethernet packet
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_802_3;
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;})

			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			//Waiting for TxPktEndedPktCbEvent. This event is triggered once BFM
			//end-up the current packet transmission. 
			pkt_wait();

			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_PAUSE;
				//DestAddrKind == DENALI_ENET_DESTADDRKIND_BROADCAST;
				//DestAddrHigh == 'hFFFF;
				//DestAddrLow == 'hFFFF_FFFF;
				})
			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			//Waiting for TxPktEndedPktCbEvent. This event is triggered once BFM
			//end-up the current packet transmission. 
			pkt_wait();

			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_PFC_PAUSE;
				//DestAddrKind == DENALI_ENET_DESTADDRKIND_BROADCAST;
				//DestAddrHigh == 'hFFFF;
				//DestAddrLow == 'hFFFF_FFFF;
				})
			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			//Waiting for TxPktEndedPktCbEvent. This event is triggered once BFM
			//end-up the current packet transmission. 
			pkt_wait();

			//This will generate an ethernet Jumbo packet
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_VLAN_TAG;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_JUMBO;
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;
				})

			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			pkt_wait();

			// This will generate an ethernet VII packet
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_VII;
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;})

			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			pkt_wait();

			// This will generate an ethernet Magic packet
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_MAGIC;
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;})

			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			pkt_wait();

			// This will generate an ethernet Snap packet
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind == DENALI_ENET_PACKETKIND_ETHERNET_SNAP;
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;})

			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf waiting for current packet transmission to end", UVM_HIGH);
			pkt_wait();
			end

			//This delay is to finish test gracefully. 
			#500000;

			if (starting_phase != null) begin
				`uvm_info(get_full_name(), "sequence uvmEthPhyHalf", UVM_LOW);
				starting_phase.drop_objection(this);
			end
			$finish();				   
		endtask : body

endclass : uvmEthPhyHalf

class eth_universal_seq extends cdnEnetUvmSequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	//creating handle for extended sequence_item myEnetTransaction
	myEnetTransaction pkt;
	bit full_duplex = 0; // 1 - full_duplex 0 - half duplex

	function new (string name = "eth_universal_seq");
		super.new(name);
	endfunction : new

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_universal_seq)
	`uvm_declare_p_sequencer(cdnEnetUvmSequencer)
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/

	task pkt_wait();
		p_sequencer.pAgent.monitor.TxPktEndedPktCbEvent.wait_trigger();
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

	task body();
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

		/*read DENALI_ENET_REG_DuplexKind*/
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_DuplexKind);
		full_duplex = regValue&'h01; 
		`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_DuplexKind value = %d",full_duplex),UVM_NONE);

		// Setting Messsage verbosity to HIGH
		p_sequencer.pAgent.regInst.writeReg(DENALI_ENET_REG_Verbosity,3);
		regValue = p_sequencer.pAgent.regInst.readReg(DENALI_ENET_REG_Verbosity);
		`uvm_info(get_full_name(),$psprintf("ActivePhy:: reading DENALI_ENET_REG_Verbosity value = %d",regValue),UVM_HIGH);

		`uvm_info(get_full_name(), "sequence eth_universal_seq started", UVM_HIGH);

		repeat(5) begin 
			`uvm_do_with(pkt,{
				TagKind == DENALI_ENET_TAGKIND_UNTAGGED;
				UpperLayerKind == DENALI_ENET_UPPERLAYERKIND_NONE;
				Type == DENALI_ENET_TR_pkt;
				PacketKind inside {DENALI_ENET_PACKETKIND_ETHERNET_MAGIC,DENALI_ENET_PACKETKIND_ETHERNET_802_3,DENALI_ENET_PACKETKIND_ETHERNET_VII,DENALI_ENET_PACKETKIND_ETHERNET_SNAP};
				DestAddrHigh == 'hFFFF;
				DestAddrLow == 'hFFFF_FFFF;
				})

			pkt_wait();			
		end

		//This delay is to finish test gracefully. 
		#500000;

		if (starting_phase != null) begin
			`uvm_info(get_full_name(), "sequence uvmEthPhyHalf", UVM_LOW);
			starting_phase.drop_objection(this);
		end
		$finish();	

	endtask : body

endclass : eth_universal_seq

`endif //ETH_SEQUENCE_LIB
