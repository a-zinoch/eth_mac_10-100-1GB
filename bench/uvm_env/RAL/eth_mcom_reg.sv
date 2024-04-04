`ifndef ETH_MCOM_REG
`define ETH_MCOM_REG

class eth_mcom_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field rx_start;
	rand uvm_reg_field promisc;
	rand uvm_reg_field rst;
	rand uvm_reg_field irq_rx;
	rand uvm_reg_field irq_tx;
	rand uvm_reg_field phy_ie;
	rand uvm_reg_field col_dis;

	constraint rx_start_c {rx_start.value inside {[0:1]};}
	constraint promisc_c {promisc.value inside {[0:1]};}
	constraint rst_c {rst.value inside {[0:1]};}
	constraint irq_rx_c {irq_rx.value inside {[0:1]};}
	constraint irq_tx_c {irq_tx.value inside {[0:1]};}
	constraint phy_ie_c {phy_ie.value inside {[0:1]};}
	constraint col_dis_c {col_dis.value inside {[0:1]};}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_mcom_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_mcom_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_mcom_reg

function void eth_mcom_reg::build();
	rx_start = uvm_reg_field::type_id::create("rx_start");
	rx_start.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 1   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	promisc = uvm_reg_field::type_id::create("promisc");
	promisc.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 2   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	rst = uvm_reg_field::type_id::create("rst");
	rst.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 3   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	irq_rx = uvm_reg_field::type_id::create("irq_rx");
	irq_rx.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 4   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	irq_tx = uvm_reg_field::type_id::create("irq_tx");
	irq_tx.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 5   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	phy_ie = uvm_reg_field::type_id::create("phy_ie");
	phy_ie.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 6   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);
	col_dis = uvm_reg_field::type_id::create("col_dis");
	col_dis.configure(
		.parent                 ( this ),
		.size                   ( 1    ),
		.lsb_pos                ( 7   ),
		.access                 ( "RW" ),
		.volatile               ( 1    ),
		.reset                  ( 0    ),
		.has_reset              ( 1    ),
		.is_rand                ( 1    ),
		.individually_accessible( 0    )
	);

	// add_hdl_path_slice(.name("dir"),.offset(32),.size(32));
endfunction

`endif //ETH_MCOM_REG
