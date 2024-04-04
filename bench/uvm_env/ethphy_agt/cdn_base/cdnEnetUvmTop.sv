//------------------------------------------------------------------------------
// This file loads all the VIP uvm files
//------------------------------------------------------------------------------


`ifndef CDN_ENET_UVM_TOP_SV
`define CDN_ENET_UVM_TOP_SV

`include "uvm_macros.svh"


package cdnEnetUvm;
  import uvm_pkg::*;  
  import DenaliSvEnet::*;
  import DenaliSvMem::*;
   
  //////////////////////////////////////////////////
  //         Class Forward Declarations           //
  //////////////////////////////////////////////////

  typedef class cdnEnetUvmAgent;
  typedef class cdnEnetUvmDriver;

  typedef class cdnEnetUvmInstance;
  typedef class cdnEnetUvmMemInstance;
  typedef class cdnEnetUvmMonitor;   
  typedef class cdnEnetUvmSequencer;
  typedef class cdnEnetUvmCoverage;


`include "cdnEnetUvmInstance.sv"
`include "cdnEnetUvmMemInstance.sv"
`include "cdnEnetUvmMonitor.sv"
`include "cdnEnetUvmSequencer.sv"
`include "cdnEnetUvmSequence.sv"
`include "cdnEnetUvmCoverage.sv"
`include "cdnEnetUvmDriver.sv"

`include "cdnEnetUvmAgent.sv"

endpackage
  
`endif // CDN_ENET_UVM_TOP_SV

