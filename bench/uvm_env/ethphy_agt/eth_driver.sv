`ifndef ETH_DRIVER
`define ETH_DRIVER

// ************************************************************************
// Analysis imports which connect to analysis ports.
// Through this macro "`uvm_analysis_imp_decl" we can create a 
// specific name analysis import class.
// 
// For example :: `uvm_analysis_imp_decl(_cdn_enet_TxUser_QueueExit)
// It will create uvm_analysis_imp_cdn_enet_TxUser_QueueExit class which
// will access write_cdn_enet_TxUser_QueueExit in place of normal write 
// method.
// ************************************************************************

`uvm_analysis_imp_decl(_cdn_enet_TxUser_QueueExit)

//Type def to declare various types of errors.
typedef enum {PREAMBLE_ERR, SFD_ERR, TYPE_ERR, CRC_ERR} typeOfErr;

class eth_driver extends cdnEnetUvmDriver;

	// declarations
	bit errorInjectionEnabled = 0; // a field that will is used to decide if errors will be injected
	typeOfErr errorKind; // a field that will is used to decide on which transaction field error will be injected.


	// ----------------------------------------------------------------------
	// Use the UVM registration macro for this class.
	// ----------------------------------------------------------------------
	`uvm_component_utils_begin(eth_driver)
	`uvm_field_int(errorInjectionEnabled, UVM_ALL_ON)
	`uvm_field_enum(typeOfErr, errorKind, UVM_ALL_ON)
	`uvm_component_utils_end

	// Using library imp port to declare TxPktStartedPktImp import port
	uvm_analysis_imp   #(denaliEnetTransaction, eth_driver) TxPktStartedPktImp;

	// Using specific named imp port to declare CoverTxUserQueueExitImp.
	uvm_analysis_imp_cdn_enet_TxUser_QueueExit #(denaliEnetTransaction, eth_driver) TxUserQueueExitImp;

	// ----------------------------------------------------------------------
	// Method : new
	// Desc.  : Call the constructor of the parent class.
	// ----------------------------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		begin
			int get_value;

			super.build_phase(phase);

			//Creating TxPktStartedPktImp imp port.
			TxPktStartedPktImp   = new("TxPktStartedPktImp", this);
			// If err flag is set then only TxUserQueueExitImp Imp port is created. 
			if(errorInjectionEnabled == 1) begin
				TxUserQueueExitImp = new ("TxUserQueueExitImp", this);
			end
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//Connecting monitor TxPktEndedPktCbPort to driver TxPktStartedPktImp imp port.
		pAgent.monitor.TxPktEndedPktCbPort.connect(TxPktStartedPktImp);

		// If err flag is set then only port is connected. 
		if(errorInjectionEnabled == 1) begin
			//Connecting monitor TxUserQueueExitPktCbPort to driver TxUserQueueExitImp imp port.
			pAgent.monitor.TxUserQueueExitPktCbPort.connect(TxUserQueueExitImp);
		end
	endfunction : connect_phase

	// ***************************************************************
	// This function gets triggered by imp port TxUserQueueExitImp.
	// On the basis of errorKind value, which can be set from test,
	// one case will be selected and error will be introduced.
	// You can refer test test_driver_error_injection_demo of mii
	// in test_mii.
	// ***************************************************************
	virtual function void write_cdn_enet_TxUser_QueueExit(denaliEnetTransaction trans);
		$display("\n##############################################");
		$display("write_cdn_enet_TxUser_QueueExit");
		$display("\n##############################################");
		//Introducing error on respective enum value "errorKind"
		case (errorKind)
			PREAMBLE_ERR: begin
				`uvm_info("write_cdn_enet_TxUser_QueueExit","Inject Preamble error",UVM_HIGH);
				trans.PreambleDataPreamble[1] = ~trans.PreambleDataPreamble[1] ; 
				trans.PreambleDataPreamble[3] = ~trans.PreambleDataPreamble[3] ; 
				void'(trans.transSet());
			end
				SFD_ERR: begin
				`uvm_info("write_cdn_enet_TxUser_QueueExit","Inject Sfd error",UVM_HIGH);
				trans.PreambleSfd[5] = ~trans.PreambleSfd[5];
				void'(trans.transSet());
			end
				TYPE_ERR: begin
				`uvm_info("write_cdn_enet_TxUser_QueueExit","Inject Type error",UVM_HIGH);
				trans.LengthType = $urandom % 1400;
				void'(trans.transSet());
			end
				CRC_ERR: begin
				`uvm_info("write_cdn_enet_TxUser_QueueExit","Inject Crc error",UVM_HIGH);
				trans.Crc = $urandom;
				void'(trans.transSet());
			end
		endcase
	endfunction : write_cdn_enet_TxUser_QueueExit

	// ----------------------------------------------------------------------
	// Method : write
	// Desc.  : will be called when uvm_analysis_imp: TxPktStartedPktImp is been written
	// ----------------------------------------------------------------------
	function void write(denaliEnetTransaction trans);
		//User can added logic to change or corrupt the trans field.
		$display("\n##############################################");
		$display("TxPktStartedPktImp : ");
		$display("##############################################\n");

	endfunction : write

endclass : eth_driver


`endif //ETH_DRIVER