`ifndef ETH_DMA_ADR_REG
`define ETH_DMA_ADR_REG

class eth_dma_adr_reg extends uvm_reg;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand uvm_reg_field dma_adr;

	constraint dma_adr_c { dma_adr.value >= 0 ;dma_adr.value < 1<<12;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_dma_adr_reg)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_dma_adr_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_dma_adr_reg

function void eth_dma_adr_reg::build();

	dma_adr = uvm_reg_field::type_id::create( "dma_adr" );
	dma_adr.configure(
		.parent                 ( this ),
		.size                   ( 12   ),
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

`endif //ETH_DMA_ADR_REG
