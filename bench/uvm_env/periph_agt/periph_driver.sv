`ifndef PERIPH_DRIVER
`define PERIPH_DRIVER

class periph_driver extends uvm_driver #(periph_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	agt_config_periph agt_cfg;
	virtual if_periph_bus dut_vi;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(periph_driver)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : periph_driver


function void periph_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(agt_config_periph)::get(this, "", "periph_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Periph bus agt config not found!")
	end
	dut_vi = agt_cfg.periph_vi;
endfunction : build_phase


task periph_driver::run_phase(uvm_phase phase);
	periph_item tx,rx;

	forever begin
		seq_item_port.get(tx);
		$cast(rx, tx.clone());
		rx.set_id_info(tx);

		@(posedge dut_vi.clk);
		dut_vi.mdint = tx.mdio_int; 
		rx.interrupt = dut_vi.eth_int;

		seq_item_port.put_response(rx);
	end

endtask : run_phase

`endif //PERIPH_DRIVER