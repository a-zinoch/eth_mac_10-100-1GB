`ifndef ETH_MONITOR
`define ETH_MONITOR

class eth_monitor extends cdnEnetUvmMonitor;

	//This variable is used to control the creation of coverage object
	//By default its value is one, means coverage object will be created.
	//User can control or set this value from test and enable, disable
	//coverage class object creation.
	bit coverageEnable = 1;

	// ***************************************************************
	// Use the UVM registration macro for this class.
	// ***************************************************************
	`uvm_component_utils_begin(eth_monitor)
	  `uvm_field_int(coverageEnable, UVM_ALL_ON)
	`uvm_component_utils_end

	// Coverage model
	eth_coverage coverModel;

	// ***************************************************************
	// Method : new
	// Desc.  : Call the constructor of the parent class.
	// ***************************************************************
	function new(string name, uvm_component parent);
	    super.new(name, parent);
	endfunction : new

	// ***************************************************************
	// Method : build_phase
	// Desc.  : Build phase to create object for coverage.
	//         
	// ***************************************************************

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		//Condition to control the creation of coverage object.
		if (coverageEnable == 1) begin
		 coverModel = eth_coverage::type_id::create("coverModel", this);
		end 
	endfunction : build_phase

	// ***************************************************************
	// Method : connect_phase
	// Desc.  : Connect analysis ports to imp ports in Coverage and
	//          Events model
	// ***************************************************************
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//Connecting RxPktEndedPktCbPort of monitor to CoverRxFrameEndedImp imp
		//port of covearge class.
		if (coverageEnable == 1) begin
		 this.RxPktEndedPktCbPort.connect(this.coverModel.CoverRxFrameEndedImp);
		end
	endfunction

endclass : eth_monitor


`endif //ETH_MONITOR