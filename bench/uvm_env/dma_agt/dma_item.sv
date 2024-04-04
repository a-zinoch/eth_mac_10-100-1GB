`ifndef DMA_ITEM
`define DMA_ITEM


class dma_item extends uvm_sequence_item;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand bit grant;
	rand int unsigned wr_data;

	logic [`DMA_ADR_WIDTH-1:0] addr;
	logic [`DMA_DAT_WIDTH-1:0] rd_data;
	logic en_clk;
	logic rqst;
	logic ce;
	logic we;
	logic oe;

	constraint c_grant { grant inside {[0:1]}; }
	constraint c_data { wr_data >= 0; wr_data <= 'hFFFF_FFFF;}
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(dma_item)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_item");
		super.new(name);
	endfunction : new

	function string convert2string;
		return $psprintf("grant=%d, t_data=%0d, r_data=%d", grant, wr_data, rd_data);
	endfunction: convert2string

endclass : dma_item


`endif //DMA_ITEM