
`ifndef CDN_ENET_UVM_DRIVER_SV
`define CDN_ENET_UVM_DRIVER_SV

`uvm_analysis_imp_decl(_enet_uvm_driver_TxPktEndedPkt)
`uvm_analysis_imp_decl(_enet_uvm_driver_TxPktEndedMgmtPkt)
`uvm_analysis_imp_decl(_enet_uvm_driver_TxUserQueueExitPkt)
`uvm_analysis_imp_decl(_enet_uvm_driver_TxUserQueueExitMgmtPkt)


// ***************************************************************
// class: cdnEnetUvmDriver
// This class gets the packets from the sequencer(s) and drives them through the model instance (BFM). 
// ***************************************************************

class cdnEnetUvmDriver extends uvm_driver #(denaliEnetTransaction,denaliEnetTransaction);
  
  // ***************************************************************
  // A reference to the agent, as set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
  
  // *************************************************************** 
  // A reference to the instance, as set by the agent.
  // ***************************************************************
  cdnEnetUvmInstance pInst;
  
  integer disableRspPortWrite = 0;
  
  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_component_utils_begin(cdnEnetUvmDriver)
  `uvm_field_int(disableRspPortWrite, UVM_ALL_ON)
  `uvm_component_utils_end
  `uvm_register_cb(cdnEnetUvmDriver, cdnEnetUvmDriverCb)

  uvm_analysis_imp_enet_uvm_driver_TxPktEndedPkt #(denaliEnetTransaction, cdnEnetUvmDriver) DriverTransactionTxPktEndedPkt;
  uvm_analysis_imp_enet_uvm_driver_TxPktEndedMgmtPkt #(denaliEnetTransaction, cdnEnetUvmDriver) DriverTransactionTxPktEndedMgmtPkt;
  uvm_analysis_imp_enet_uvm_driver_TxUserQueueExitPkt #(denaliEnetTransaction, cdnEnetUvmDriver) DriverTransactionTxUserQueueExitPkt;
  uvm_analysis_imp_enet_uvm_driver_TxUserQueueExitMgmtPkt #(denaliEnetTransaction, cdnEnetUvmDriver) DriverTransactionTxUserQueueExitMgmtPkt;

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmDriver", uvm_component parent = null);
    super.new(name, parent);
    DriverTransactionTxPktEndedPkt = new("DriverTransactionTxPktEndedPkt", this);
    DriverTransactionTxPktEndedMgmtPkt = new("DriverTransactionTxPktEndedMgmtPkt", this);
    DriverTransactionTxUserQueueExitPkt = new("DriverTransactionTxUserQueueExitPkt", this);
    DriverTransactionTxUserQueueExitMgmtPkt = new("DriverTransactionTxUserQueueExitMgmtPkt", this);
  endfunction : new
  
  virtual function void transExecuted(denaliEnetTransaction tr);
    `uvm_do_callbacks(cdnEnetUvmDriver,cdnEnetUvmDriverCb,transExecuted(this,tr))
  endfunction

  // ***************************************************************
  // Method : run/run_phase
  // Desc.  : Start required threads.
  //          Note that callbacks are enabled from the env level.
  // ***************************************************************
  virtual task run_phase(uvm_phase phase);    
    super.run_phase(phase);    
    mainLoop();
  endtask : run_phase

  // ***************************************************************
  // Method : driveTransaction
  // Desc. : Implement the driving of the transaction to the VIP model.
  // ***************************************************************
  virtual task driveTransaction (denaliEnetTransaction tr); 
    `uvm_info("DRIVER", "Sending trans to bfm", UVM_HIGH);
     
    void'(pInst.transAdd(tr, 0));
    
    waitForTransactionEnd(tr);
  endtask : driveTransaction

  // ***************************************************************
  // Method : waitForTransactionEnd
  // Desc. : Wait for the transaction to end before getting the next item. The default implementation of this method is empty.
  // ***************************************************************
  virtual task waitForTransactionEnd (denaliEnetTransaction tr); 
  endtask : waitForTransactionEnd
  
  // ***************************************************************
  // Method : mainLoop
  // Desc. : Implement the logic for taking a transaction from the sequencer and drives it to the VIP model.
  // ***************************************************************
  virtual task mainLoop ();
    uvm_sequence_item item;
    denaliEnetTransaction tr;
    
    forever begin      
      // Get the next transaction from the sequencer.
      // If there are no transactions available, wait here. 
      seq_item_port.get_next_item(item);
        
      // Cast the uvm_sequence_items to denaliEnetTransaction
      $cast(tr, item);
      if (tr == null)
        `uvm_fatal("DRIVER", "casting failed or item returned null");
      

      // Drive item to the VIP
      driveTransaction(tr);                 
      
      // Call sequencer item_done
      seq_item_port.item_done();
    end
  endtask : mainLoop
  
  virtual function void writeRspPort(denaliEnetTransaction trans);
    if (disableRspPortWrite == 0)
      if (trans != null) begin
        if (trans.get_sequence_id!= -1)                   
          rsp_port.write(trans);
      end
  endfunction

  virtual function void write_enet_uvm_driver_TxPktEndedPkt (denaliEnetTransaction trans);
    writeRspPort(trans);
  endfunction : write_enet_uvm_driver_TxPktEndedPkt

  virtual function void write_enet_uvm_driver_TxPktEndedMgmtPkt (denaliEnetTransaction trans);
    writeRspPort(trans);
  endfunction : write_enet_uvm_driver_TxPktEndedMgmtPkt

  virtual function void write_enet_uvm_driver_TxUserQueueExitPkt (denaliEnetTransaction trans);
    void'(transExecuted(trans));
  endfunction : write_enet_uvm_driver_TxUserQueueExitPkt

  virtual function void write_enet_uvm_driver_TxUserQueueExitMgmtPkt (denaliEnetTransaction trans);
    void'(transExecuted(trans));
  endfunction : write_enet_uvm_driver_TxUserQueueExitMgmtPkt

  // ***************************************************************
  // Method : connect/connect_phase
  // Desc. : Connects the analysis ports to the instance.
  // ***************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);        
    pAgent.monitor.TxPktEndedPktCbPort.connect(DriverTransactionTxPktEndedPkt);
    pAgent.monitor.TxPktEndedMgmtPktCbPort.connect(DriverTransactionTxPktEndedMgmtPkt);
    pAgent.monitor.TxUserQueueExitPktCbPort.connect(DriverTransactionTxUserQueueExitPkt);
    pAgent.monitor.TxUserQueueExitMgmtPktCbPort.connect(DriverTransactionTxUserQueueExitMgmtPkt);
  endfunction : connect_phase
  
endclass : cdnEnetUvmDriver

`endif // CDN_ENET_UVM_DRIVER_SV
