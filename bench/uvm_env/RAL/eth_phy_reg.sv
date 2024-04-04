`ifndef ETH_PHY_REG
`define ETH_PHY_REG

class eth_phy_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field mrc;
	rand uvm_reg_field mwc;
	rand uvm_reg_field mdclk_en;
	rand uvm_reg_field phy_adr;
	rand uvm_reg_field adr;
	rand uvm_reg_field data;

	constraint mrc_c {mrc.value inside {[0:1]};}
	constraint mwc_c {mwc.value inside {[0:1]};}
	constraint mdclk_en_c {mdclk_en.value inside {[0:1]};}
	constraint phy_adr_c {phy_adr.value >= 0; phy_adr.value < 1<<5;}
	constraint adr_c {adr.value >= 0; adr.value < 1<<5;}
	constraint data_c {data.value >= 0; data.value < 1<<16;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_phy_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_phy_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_phy_reg

function void eth_phy_reg::build();

	mrc = uvm_reg_field::type_id::create("mrc");
	mrc.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 31   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
		);

	mwc = uvm_reg_field::type_id::create("mwc");
	mwc.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 30   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
		);

	mdclk_en = uvm_reg_field::type_id::create("mdclk_en");
	mdclk_en.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 28   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
		);

	phy_adr = uvm_reg_field::type_id::create("phy_adr");
	phy_adr.configure(
		.parent                 ( this ),
		.size                   ( 5    ),
		.lsb_pos                ( 21   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
		);

	adr = uvm_reg_field::type_id::create("adr");
	adr.configure(
		.parent                 ( this ),
		.size                   ( 5    ),
		.lsb_pos                ( 16   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
		);

	data = uvm_reg_field::type_id::create("data");
	data.configure(
		.parent                 ( this ),
		.size                   ( 16   ),
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

`endif //ETH_PHY_REG