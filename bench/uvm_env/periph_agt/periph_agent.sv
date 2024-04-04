`ifndef PERIPH_AGENT
`define PERIPH_AGENT

class periph_agent extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_port #(periph_item) aport;

	periph_sequencer periph_sequencer_h;
	periph_driver    periph_driver_h;
	periph_monitor   periph_monitor_h;

	agt_config_periph agt_cfg;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(periph_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : periph_agent

function void periph_agent::build_phase(uvm_phase phase);
	aport = new("aport", this);
	periph_sequencer_h = periph_sequencer::type_id::create("periph_sequencer_h",this);
	periph_driver_h = periph_driver::type_id::create("periph_driver_h",this);
	periph_monitor_h = periph_monitor::type_id::create("periph_monitor_h",this);

	if(!uvm_config_db #(agt_config_periph)::get(this, "", "periph_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Periph agt config not found!")
	end
endfunction : build_phase

function void periph_agent::connect_phase(uvm_phase phase);
	periph_driver_h.seq_item_port.connect( periph_sequencer_h.seq_item_export );
	periph_monitor_h.aport.connect( aport );
endfunction : connect_phase

`endif //PERIPH_AGENT