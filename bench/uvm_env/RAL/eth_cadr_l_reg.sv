`ifndef ETH_CARD_L_REG
`define ETH_CARD_L_REG

class eth_card_l_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field card_l;

	constraint card_l_c { card_l.value >= 0; card_l.value < 1<<24;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_card_l_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_card_l_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_card_l_reg

function void eth_card_l_reg::build();

	card_l = uvm_reg_field::type_id::create( "card_l" );
	card_l.configure(
		.parent                 ( this ),
		.size                   ( 24   ),
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

`endif //ETH_CARD_L_REG
