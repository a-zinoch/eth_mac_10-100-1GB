`ifndef AGT_CONFIG_DMABUS
`define AGT_CONFIG_DMABUS

class agt_config_dmabus extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual if_dma_bus dmabus_vi;
	int unsigned rom_size, flash_size, ram_size;
	int unsigned rom_width, flash_width, ram_width;
	int unsigned rom_offest, flash_offest, ram_offest;
	string rom_image, flash_image, ram_image;
	bit ram_en,rom_en,flash_en;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(agt_config_dmabus)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "agt_config_dmabus");
		super.new(name);
	endfunction : new

endclass : agt_config_dmabus

`endif //AGT_CONFIG_DMABUS