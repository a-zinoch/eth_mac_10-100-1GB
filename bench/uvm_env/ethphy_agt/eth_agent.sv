`ifndef ETH_AGENT
`define ETH_AGENT

class eth_agent extends cdnEnetUvmAgent;

	`uvm_component_utils(eth_agent)

	//Overriding New-constructor of cdnEnetUvmAgent, always make user to call
	//super.new whenever overriding of base class constructor is done.
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	// ***************************************************************
	// Method : build/build_phase
	// Desc.  : Disable teh coverage for the passive agents as well
	// ***************************************************************
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Re-setting the coverageEnable default for all agents to '0'
		// Done for ENET specifically to improve performance
		set_config_int("monitor","coverageEnable",1);

	endfunction : build_phase

endclass : eth_agent

`endif //ETH_AGENT