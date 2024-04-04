`ifndef ETH_CARD_H_REG
`define ETH_CARD_H_REG

class eth_card_h_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field card_h;

	constraint card_h_c { card_h.value >= 0; card_h.value < 1<<24;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_card_h_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_card_h_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_card_h_reg

function void eth_card_h_reg::build();

	card_h = uvm_reg_field::type_id::create( "card_h" );
	card_h.configure(
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

`endif //ETH_CARD_H_REG
