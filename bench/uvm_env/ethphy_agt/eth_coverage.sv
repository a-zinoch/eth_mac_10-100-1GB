`ifndef ETH_COVERAGE
`define ETH_COVERAGE

// *************************************************************************
// Analysis imports which connect to analysis ports, Through this macro
// "`uvm_analysis_imp_decl" we can create a specific name analysis import
// class.
// For example :: `uvm_analysis_imp_decl(_cdn_enet_rxframe_ended)
// It will create uvm_analysis_imp_cdn_enet_rxframe_ended class which
// will access write_cdn_enet_rxframe_ended in place of normal write method.
// *************************************************************************
`uvm_analysis_imp_decl(_cdn_enet_rxframe_ended)

  
class eth_coverage extends uvm_component;

  // Pointer to the transaction(Packet class) to be covered
  denaliEnetTransaction coverTrans;

  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_component_utils(eth_coverage)

  
  // Analysis imports which connect to analysis ports ultimately connected to UVC callbacks
  uvm_analysis_imp_cdn_enet_rxframe_ended #(denaliEnetTransaction, eth_coverage) CoverRxFrameEndedImp;


  // ***************************************************************
  // This function gets triggered by imp port CoverRxFrameEndedImp
  // ***************************************************************
  virtual function void write_cdn_enet_rxframe_ended(denaliEnetTransaction trans);
    
    $cast(coverTrans, trans);
    //Calling this method by which the coverage sample will be triggered.   
    collectRxFrameEndedCoverage();

  endfunction : write_cdn_enet_rxframe_ended


  // Example coverage group
  // ======================  
  covergroup covRxFrameEndedTrans; 
    option.per_instance = 1;

    PacketKind : coverpoint coverTrans.PacketKind
    {
      bins Ethernet_802_3 = {DENALI_ENET_PACKETKIND_ETHERNET_802_3};
      bins Ethernet_VII   = {DENALI_ENET_PACKETKIND_ETHERNET_VII};
      bins Ethernet_Pause = {DENALI_ENET_PACKETKIND_ETHERNET_PAUSE};
      bins Ethernet_Jumbo = {DENALI_ENET_PACKETKIND_ETHERNET_JUMBO};
      bins Ethernet_Snap  = {DENALI_ENET_PACKETKIND_ETHERNET_SNAP};
      bins Ethernet_Magic = {DENALI_ENET_PACKETKIND_ETHERNET_MAGIC};
    }
        
    DataLength : coverpoint coverTrans.DataLength
    {
      bins Small  = {[46:500]};
      bins Medium = {[501:1000]};
      bins Large  = {[1001:1500]};
      bins Jumbo  = {[1535:9000]};
    }
    
    //Cross Coverage          
    PacketKindXDataLength : cross PacketKind,DataLength;
      
  endgroup : covRxFrameEndedTrans


  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "eth_coverage", uvm_component parent = null);
    super.new(name, parent);

    //cerating instance for covRxFrameEndedTrans covergroup.
    covRxFrameEndedTrans = new();
    covRxFrameEndedTrans.set_inst_name({get_full_name(), ".covRxFrameEndedTrans"});

    //creating object for CoverRxFrameEndedImp.
    CoverRxFrameEndedImp = new("CoverRxFrameEndedImp", this);

  endfunction : new

  
  // ***************************************************************
  // This function gets triggered by import port
  // ***************************************************************
  virtual function void collectRxFrameEndedCoverage();
    //This will invoke coverage sampling in various coverpoint of respective covergroup.  
    covRxFrameEndedTrans.sample();
    `uvm_info(get_type_name(), {"Transaction Coverage Collected For Rx Frame Ended:\n"}, UVM_HIGH)
            
  endfunction : collectRxFrameEndedCoverage 

endclass : eth_coverage

`endif
