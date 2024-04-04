`ifndef AGT_CONFIG_SLAVE
`define AGT_CONFIG_SLAVE

class agt_config_periph extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual if_periph_bus periph_vi;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(agt_config_periph)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "agt_config_periph");
		super.new(name);
	endfunction : new

endclass : agt_config_periph


`endif //AGT_CONFIG_SLAVE