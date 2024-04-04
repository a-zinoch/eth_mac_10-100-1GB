`ifndef PERIPH_OBJ
`define PERIPH_OBJ

class periph_packet extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	logic eth_interrupt;
	logic mdio_int;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(periph_packet)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_packet");
		super.new(name);
	endfunction : new

endclass : periph_packet

`endif //PERIPH_OBJ