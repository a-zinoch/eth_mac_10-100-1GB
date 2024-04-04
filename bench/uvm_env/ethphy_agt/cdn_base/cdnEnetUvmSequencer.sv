
`ifndef CDN_ENET_UVM_SEQUENCER_SV
`define CDN_ENET_UVM_SEQUENCER_SV

// ***************************************************************
// class: cdnEnetUvmSequencer
// The sequencer is an advanced stimulus generator that controls data items that are provided to the driver for execution.
// ***************************************************************
class cdnEnetUvmSequencer extends uvm_sequencer #(denaliEnetTransaction,denaliEnetTransaction);

  // ***************************************************************
  // A reference to the agent, as set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
  
  // ***************************************************************
  // A reference to the instance, as set by the agent.
  // ***************************************************************
  cdnEnetUvmInstance pInst;

  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
    `uvm_component_utils(cdnEnetUvmSequencer)

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmSequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  

endclass : cdnEnetUvmSequencer 

`endif // CDN_ENET_UVM_SEQUENCER_SV
