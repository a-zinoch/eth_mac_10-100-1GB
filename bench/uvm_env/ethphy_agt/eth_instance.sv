`ifndef ETH_INST
`define ETH_INST

class eth_instance extends cdnEnetUvmInstance;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_instance)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_instance", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new


	virtual function int RxPktStartedPktCbF(ref denaliEnetTransaction trans);
		return super.RxPktStartedPktCbF(trans);
	endfunction : RxPktStartedPktCbF

	virtual function int TxPktStartedPktCbF(ref denaliEnetTransaction trans);
		return super.TxPktStartedPktCbF(trans);
	endfunction : TxPktStartedPktCbF

	virtual function int TxPktEndedPktCbF(ref denaliEnetTransaction trans);
		return super.TxPktEndedPktCbF(trans);
	endfunction : TxPktEndedPktCbF

// ***************************************************************
// Method : TxPktStartedPktCbF
// Desc.  : callback function overloading. This has to be used for 
// TX Path where the denaliEnetTransaction instance "trans" will be packed
// and will be sent to each location of the TX_FIFO.
// ***************************************************************
	// virtual function int TxPktStartedPktCbF(ref denaliEnetTransaction trans);
	// 	$display("TxPktStartedPktCbF!!!!");
	// 	return super.TxPktStartedPktCbF(trans);
	// endfunction : TxPktStartedPktCbF

// ***************************************************************
// Method : TxUserQueueExitPktCbF
// Desc.  : callback function overloading. This has to be used for 
// RX Path where the denaliEnetTransaction instance "trans" will be overridden
// with the contents of RX_FIFO's packet(list of byte) and will be 
// driven by the RX_STATION.
// ***************************************************************
	// virtual function int TxUserQueueExitPktCbF(ref denaliEnetTransaction trans);
	// 	//trans.LengthType = 0; // Overriding LengthType Field, and in the similar way other fields can be overridden.
	// 	//void'(trans.transSet()); // This is called for the overridden changes to take effect.
	// 	return super.TxUserQueueExitPktCbF(trans);
	// endfunction : TxUserQueueExitPktCbF

	// virtual function int TxPktRawDataBeforeTransmissionCbF(ref denaliEnetTransaction trans);
	// $display("TxPktRawDataBeforeTransmissionCbF : trans cb is ");
	// $display("TxPktRawDataBeforeTransmissionCbF : Type: 	",trans.Type.name());
	// $display("TxPktRawDataBeforeTransmissionCbF : Callback: 		",trans.Callback.name());
	// $display("Raw Data size is = ", trans.EthernetPacketRawData.size());
	// $display("Raw Data is = ", trans.EthernetPacketRawData[43]);
	// //trans.EthernetPacketRawData = new[121];
	// //for(i=0; i<trans.EthernetPacketRawData.size(); i++)
	// //   trans.EthernetPacketRawData[i] = 'h55;
	// //$display("RoutingType is = ", trans.RoutingType);
	// //trans.IPv6NextHeader = 49;
	// trans.EthernetPacketRawData[43] = 'hBB;
	// void'(trans.transSet());
	// return super.TxPktRawDataBeforeTransmissionCbF(trans);
	// endfunction

	// virtual function int RxPktRawDataAfterReceptionCbF(ref denaliEnetTransaction trans);
	// $display("RxPktRawDataAfterReceptionCbF : trans cb is ");
	// $display("RxPktRawDataAfterReceptionCbF : Type: 	",trans.Type.name());
	// $display("RxPktRawDataAfterReceptionCbF : Callback: 		",trans.Callback.name());
	// $display("Raw Data size is = ", trans.EthernetPacketRawData.size());
	// //trans.EthernetPacketRawData = new[121];
	// //for(i=0; i<trans.EthernetPacketRawData.size(); i++)
	// //   trans.EthernetPacketRawData[i] = 'h55;
	// //$display("RoutingType is = ", trans.RoutingType);
	// //trans.IPv6NextHeader = 49;
	// trans.EthernetPacketRawData[43] = 'hAA;
	// void'(trans.transSet());
	// return super.RxPktRawDataAfterReceptionCbF(trans);
	// endfunction


endclass : eth_instance

`endif //ETH_INST