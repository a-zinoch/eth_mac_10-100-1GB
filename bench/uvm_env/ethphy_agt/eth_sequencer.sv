`ifndef ETH_SEQUENCER
`define ETH_SEQUENCER

class eth_sequencer extends cdnEnetUvmSequencer;

	// ***************************************************************
	// Use the UVM registration macro for this class.
	// ***************************************************************
	`uvm_sequencer_utils_begin(eth_sequencer)
	`uvm_sequencer_utils_end

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : eth_sequencer

`endif //ETH_SEQUENCER