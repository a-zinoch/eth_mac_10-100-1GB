`ifndef DMA_SUBSCRIBER
`define DMA_SUBSCRIBER

class dma_subscriber extends uvm_subscriber #(dma_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/

	// logic [`PAW-1:0] addr;
	// logic [31:0] data;
	// bus_op_t op;

	// covergroup crc_cg();
	// 	option.name         = "sysbus_cov";
	// 	option.comment      = "UVM Subscriber";
	// 	option.per_instance = 1;
	// 	coverpoint_op : coverpoint op;
	// 	coverpoint_addr : coverpoint addr;
	// 	coverpoint_data : coverpoint data;
	// endgroup : crc_cg

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_subscriber)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_subscriber", uvm_component parent=null);
		super.new(name, parent);
		// crc_cg = new;
	endfunction : new

	extern function void write(dma_item t);

endclass : dma_subscriber

function void dma_subscriber::write(dma_item t);
	// `uvm_info("mg", $psprintf("Subscriber received tx %s", t.convert2string()), UVM_NONE);
	// op  = t.bus_op;
	// addr = t.addr;
	// data = t.data;
	// crc_cg.sample();
endfunction : write

`endif //DMA_SUBSCRIBER