
`ifndef CDN_ENET_UVM_COVERAGE_SV
`define CDN_ENET_UVM_COVERAGE_SV

// ***************************************************************
// class: cdnEnetUvmCoverage
// This class represents the ENET coverage model
// ***************************************************************
class cdnEnetUvmCoverage extends denaliEnetCoverageInstance;
  
  // ***************************************************************
  // Reference to the agent, set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
 
  // ***************************************************************
  // Use the UVM registration macro for this class. 
  // ***************************************************************
  `uvm_component_utils(cdnEnetUvmCoverage)
  
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmCoverage", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : cdnEnetUvmCoverage

`endif // CDN_ENET_UVM_COVERAGE_SV
