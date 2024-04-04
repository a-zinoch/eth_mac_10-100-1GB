`ifndef PERIPH_ITEM
`define PERIPH_ITEM

class periph_item extends uvm_sequence_item;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	logic interrupt;
	logic mdio_int;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(periph_item)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_item");
		super.new(name);
	endfunction : new

	function string convert2string;
		return $psprintf("interrupt=%d", interrupt);
	endfunction: convert2string

endclass : periph_item


`endif //PERIPH_ITEM