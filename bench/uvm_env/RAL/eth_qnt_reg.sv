`ifndef ETH_QNT_REG
`define ETH_QNT_REG

class eth_qnt_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field byte_rec_qnt;
	rand uvm_reg_field word_rec_qnt;

	constraint byte_rec_qnt_c { byte_rec_qnt.value >= 0; byte_rec_qnt.value < 1<<11;}
	constraint word_rec_qnt_c { word_rec_qnt.value >= 0; word_rec_qnt.value < 1<<9;}
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_qnt_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_qnt_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_qnt_reg

function void eth_qnt_reg::build();

	byte_rec_qnt = uvm_reg_field::type_id::create( "byte_rec_qnt" );
	byte_rec_qnt.configure(
		.parent                 ( this ),
		.size                   ( 11   ),
		.lsb_pos                ( 0    ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	word_rec_qnt = uvm_reg_field::type_id::create( "word_rec_qnt" );
	word_rec_qnt.configure(
		.parent                 ( this ),
		.size                   ( 9    ),
		.lsb_pos                ( 16   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	// add_hdl_path_slice(.name("dir"),.offset(32),.size(32));
endfunction

`endif //ETH_QNT_REG
