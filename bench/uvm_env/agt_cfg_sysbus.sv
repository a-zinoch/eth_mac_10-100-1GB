`ifndef AGT_CONFIG_MASTER
`define AGT_CONFIG_MASTER

class agt_config_sysbus #(type sb_reg_block = eth_reg_block) extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual if_sys_bus sysbus_vi;
	sb_reg_block reg_block;
	bit using_RAL;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(agt_config_sysbus)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "agt_config_sysbus");
		super.new(name);
	endfunction : new

endclass : agt_config_sysbus

`endif //AGT_CONFIG_MASTER
