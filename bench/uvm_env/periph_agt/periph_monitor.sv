`ifndef PERIPH_MONITOR
`define PERIPH_MONITOR

class periph_monitor extends uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	agt_config_periph agt_cfg;
	uvm_analysis_port #(periph_item) aport;
	virtual if_periph_bus dut_vi;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(periph_monitor)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass : periph_monitor

function void periph_monitor::build_phase(uvm_phase phase);

	aport = new("aport", this);
	if(!uvm_config_db #(agt_config_periph)::get(this, "", "periph_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Periph bus agt config not found!")
	end
	dut_vi = agt_cfg.periph_vi;
endfunction : build_phase

task periph_monitor::run_phase(uvm_phase phase);

	periph_item tx;
	tx = periph_item::type_id::create("tx");

	forever begin
		@(posedge dut_vi.clk);
		tx.mdio_int = dut_vi.mdint;
		tx.interrupt = dut_vi.eth_int;
		aport.write(tx);
	end
endtask : run_phase

`endif //PERIPH_MONITOR