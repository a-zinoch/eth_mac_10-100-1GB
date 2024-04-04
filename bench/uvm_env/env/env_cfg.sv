`ifndef ENV_CONFIG
`define ENV_CONFIG

class env_config extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
agt_config_sysbus agt_cfg_sysbus;
agt_config_periph agt_cfg_periph;
agt_config_dmabus agt_cfg_dmabus;

bit sysbus_agt_en;
bit periph_agt_en;
bit dmabus_agt_en;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(env_config)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "env_config");
		super.new(name);
	endfunction : new

endclass : env_config

`endif //ENV_CONFIG