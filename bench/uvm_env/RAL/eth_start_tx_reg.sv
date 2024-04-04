`ifndef ETH_START_TX_REG
`define ETH_START_TX_REG

class eth_start_tx_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field start_trans;

	constraint start_trans_c { start_trans.value inside {[0:1]};}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_start_tx_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_start_tx_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_start_tx_reg

function void eth_start_tx_reg::build();

	start_trans = uvm_reg_field::type_id::create( "start_trans" );
	start_trans.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 0   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	// add_hdl_path_slice(.name("dir"),.offset(32),.size(32));
endfunction

`endif //ETH_START_TX_REG
