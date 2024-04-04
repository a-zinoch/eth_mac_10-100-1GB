`ifndef PERIPH_SEQUENCER
`define PERIPH_SEQUENCER

class periph_sequencer extends uvm_sequencer #(periph_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_sequencer_utils(periph_sequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : periph_sequencer

`endif //PERIPH_SEQUENCER