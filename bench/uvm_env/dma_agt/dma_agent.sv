`ifndef DMA_AGENT
`define DMA_AGENT

class dma_agent extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_port #(dma_item) aport;

	dma_sequencer dma_sequencer_h;
	dma_driver    dma_driver_h;
	dma_monitor   dma_monitor_h;
	agt_config_dmabus agt_cfg;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : dma_agent

function void dma_agent::build_phase(uvm_phase phase);
	aport = new("aport", this);
	dma_sequencer_h = dma_sequencer::type_id::create("dma_sequencer_h",this);
	dma_driver_h = dma_driver::type_id::create("dma_driver_h",this);
	dma_monitor_h = dma_monitor::type_id::create("dma_monitor_h",this);

	if(!uvm_config_db #(agt_config_dmabus)::get(this, "", "dmabus_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Dma agt config not found!")
	end

endfunction : build_phase

function void dma_agent::connect_phase(uvm_phase phase);
	dma_driver_h.seq_item_port.connect( dma_sequencer_h.seq_item_export );
	dma_monitor_h.aport.connect( aport );
endfunction : connect_phase

`endif //DMA_AGENT