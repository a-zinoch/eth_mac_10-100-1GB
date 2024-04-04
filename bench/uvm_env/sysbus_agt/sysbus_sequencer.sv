`ifndef SYSBUS_SEQUENCER
`define SYSBUS_SEQUENCER

class sysbus_sequencer extends uvm_sequencer #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_sequencer_utils(sysbus_sequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : sysbus_sequencer

`endif //SYSBUS_SEQUENCER