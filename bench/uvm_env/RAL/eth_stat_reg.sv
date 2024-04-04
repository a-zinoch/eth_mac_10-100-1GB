`ifndef ETH_STAT_REG
`define ETH_STAT_REG

class eth_stat_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field tx_status;
	rand uvm_reg_field pkg_ready;
	rand uvm_reg_field rx_data_err;
	rand uvm_reg_field rec_crc_err;
	rand uvm_reg_field rx_col_err;
	rand uvm_reg_field tx_err;
	rand uvm_reg_field rx_buffer_err;
	rand uvm_reg_field phy_irq;
	rand uvm_reg_field mcast;
	rand uvm_reg_field bcast;
	rand uvm_reg_field pkg_buf;

	constraint tx_status_c {tx_status.value inside {[0:1]};}
	constraint pkg_ready_c {pkg_ready.value inside {[0:1]};}
	constraint rx_data_err_c {rx_data_err.value inside {[0:1]};}
	constraint rec_crc_err_c {rec_crc_err.value inside {[0:1]};}
	constraint rx_col_err_c {rx_col_err.value inside {[0:1]};}
	constraint tx_err_c {tx_err.value inside {[0:1]};}
	constraint rx_buffer_err_c {rx_buffer_err.value inside {[0:1]};}
	constraint phy_irq_c {phy_irq.value inside {[0:1]};}
	constraint mcast_c {mcast.value inside {[0:1]};}
	constraint bcast_c {bcast.value inside {[0:1]};}
	constraint pkg_buf_c {pkg_buf.value inside {[0:1]};}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_stat_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_stat_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_stat_reg

function void eth_stat_reg::build();

	tx_status = uvm_reg_field::type_id::create("tx_status");
	tx_status.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 0   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	pkg_ready = uvm_reg_field::type_id::create("pkg_ready");
	pkg_ready.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 1   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	rx_data_err = uvm_reg_field::type_id::create("rx_data_err");
	rx_data_err.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 2   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	rec_crc_err = uvm_reg_field::type_id::create("rec_crc_err");
	rec_crc_err.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 3   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	rx_col_err = uvm_reg_field::type_id::create("rx_col_err");
	rx_col_err.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 4   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	tx_err = uvm_reg_field::type_id::create("tx_err");
	tx_err.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 5   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	rx_buffer_err = uvm_reg_field::type_id::create("rx_buffer_err");
	rx_buffer_err.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 6   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	phy_irq = uvm_reg_field::type_id::create("phy_irq");
	phy_irq.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 7   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	mcast = uvm_reg_field::type_id::create("mcast");
	mcast.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 8   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	bcast = uvm_reg_field::type_id::create("bcast");
	bcast.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 9   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	pkg_buf = uvm_reg_field::type_id::create("pkg_buf");
	pkg_buf.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 10   ),
		.access                 ( "RO" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);


	// add_hdl_path_slice(.name("dir"),.offset(32),.size(32));
endfunction

`endif //ETH_STAT_REG
