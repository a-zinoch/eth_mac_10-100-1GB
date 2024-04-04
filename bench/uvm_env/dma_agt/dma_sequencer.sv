`ifndef DMA_SEQUENCER
`define DMA_SEQUENCER

class dma_sequencer extends uvm_sequencer #(dma_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_sequencer_utils(dma_sequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : dma_sequencer

`endif //DMA_SEQUENCER