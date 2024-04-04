`ifndef ETH_RAM_ADR_TX9_REG
`define ETH_RAM_ADR_TX9_REG

class eth_ram_adr_tx9_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field ram_adr_tx9;

	constraint ram_adr_tx9_c { ram_adr_tx9.value >= 0 ;ram_adr_tx9.value < 1<<9;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_ram_adr_tx9_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_ram_adr_tx9_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_ram_adr_tx9_reg

function void eth_ram_adr_tx9_reg::build();

	ram_adr_tx9 = uvm_reg_field::type_id::create( "ram_adr_tx9" );
	ram_adr_tx9.configure(
		.parent                 ( this ),
		.size                   ( 8   ),
		.lsb_pos                ( 0    ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	// add_hdl_path_slice(.name("dir"),.offset(32),.size(32));
endfunction

`endif //ETH_RAM_ADR_TX9_REG
