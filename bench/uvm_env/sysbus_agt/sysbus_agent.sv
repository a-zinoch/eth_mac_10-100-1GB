`ifndef SYSBUS_AGENT
`define SYSBUS_AGENT

class sysbus_agent extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_port #(sysbus_item) aport;

	sysbus_sequencer sb_sequencer_h;
	sysbus_driver    sb_driver_h;
	sysbus_monitor   sb_monitor_h;
	uni_reg_adapter  reg_adapter;

	agt_config_sysbus agt_cfg;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(sysbus_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : sysbus_agent

function void sysbus_agent::build_phase(uvm_phase phase);
	aport = new("aport", this);
	sb_sequencer_h = sysbus_sequencer::type_id::create("sb_sequencer_h",this);
	sb_driver_h = sysbus_driver::type_id::create("sb_driver_h",this);
	sb_monitor_h = sysbus_monitor::type_id::create("sb_monitor_h",this);

	if(!uvm_config_db #(agt_config_sysbus)::get(this, "", "sysbus_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Sysbus agt config not found!")
	end

	if(agt_cfg.using_RAL) begin
		reg_adapter = uni_reg_adapter::type_id::create("reg_adapter",this);
	end

endfunction : build_phase

function void sysbus_agent::connect_phase(uvm_phase phase);
	sb_driver_h.seq_item_port.connect( sb_sequencer_h.seq_item_export );
	sb_monitor_h.aport.connect( aport );
endfunction : connect_phase

`endif //SYSBUS_AGENT