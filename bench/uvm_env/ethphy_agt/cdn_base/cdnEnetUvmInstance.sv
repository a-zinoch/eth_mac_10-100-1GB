
`ifndef CDN_ENET_UVM_INSTANCE_SV
`define CDN_ENET_UVM_INSTANCE_SV

// ***************************************************************
// class: cdnEnetUvmInstance
// This class is a wrapper for the model core, and provides an API for it. 
// ***************************************************************
class cdnEnetUvmInstance extends denaliEnetInstance;
  
  // ***************************************************************
  // Reference to the agent, set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
 
  // ***************************************************************
  // Use the UVM registration macro for this class. 
  // ***************************************************************
  `uvm_component_utils(cdnEnetUvmInstance)
  
  bit autoTurnOnGetResponseCallbacks    = 1;
  bit autoTurnOnErrorReportingCallbacks = 1;
  
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmInstance", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // ***************************************************************
  // Method : build/build_phase
  // Desc.  : Instantiate the coverage memory-instance.
  // ***************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    set_config_string("coverMem", "instName", {instName, "(coverage)"});
    coverMem = denaliEnetCoverageMemInstance::type_id::create("coverMem", this);
  endfunction : build_phase
 
  denaliEnetTransaction activeTransactions[integer];
  
  virtual function integer transAdd(denaliEnetTransaction obj, integer portNum, denaliArgTypeT insertType = DENALI_ARG_trans_append) ;
    integer status;
    status = super.transAdd(obj, portNum, insertType);     
    if (status >= 0)    
      activeTransactions[obj.transId] = obj;    
    return status;
  endfunction
  
  virtual function integer transDone(integer transId) ;
    integer status;
    status = super.transDone(transId);
    activeTransactions.delete(transId);
    `ifdef CDN_VIP_DEBUG
      `uvm_info("CDN_VIP_DEBUG", $sformatf("transDone was called with transId: %d ", transId), UVM_NONE);
    `endif    
    return status;
  endfunction
  
  virtual function denaliEnetTransaction tryPreExistingTransaction(integer transId);
    // The if statement was added to maintain valid behavior across all simulators
    // If an invalid index is used during a read operation or an attempt is made to
    // read a nonexistent entry, then a warning is issued by QUESTA (according to LRM)
    // to avoid warning a default item should be specified, however VCS doesn't support at this time
    // for a default item for associative arrays  02.12.12
    if (activeTransactions.exists(transId))
      tryPreExistingTransaction = activeTransactions[transId];
    `ifdef CDN_VIP_DEBUG  
    `uvm_info("CDN_VIP_DEBUG",
                $sformatf("tryPreExistingTransaction: fetching transId : %d", transId),
                UVM_FULL);
    `uvm_info("CDN_VIP_DEBUG",
              ((tryPreExistingTransaction == null)
                 ? "tryPreExistingTransaction: Didn't found transaction"
                 : $sformatf("tryPreExistingTransaction: Found Transaction %d", tryPreExistingTransaction)),
              UVM_FULL);
    // if Callback is Unset then it might be that the transaction was created by transAdd
    if (tryPreExistingTransaction != null)
      `uvm_info("CDN_VIP_DEBUG",
                  $sformatf("tryPreExistingTransaction: Last Callback to update transaction was %s",
                             tryPreExistingTransaction.Callback.name()),
                  UVM_FULL);
    `endif              
  endfunction
  
  virtual function void turnOnGetResponseCallbacks();
    if (autoTurnOnGetResponseCallbacks == 1)
    begin
      void'(this.setCallback(DENALI_ENET_CB_TxPktEndedPkt));
      void'(this.setCallback(DENALI_ENET_CB_TxPktEndedMgmtPkt));
    end
  endfunction

  virtual function void checkAllTransactionsEnded();
    `uvm_info("CDN_VIP_DEBUG", $sformatf("Number of active transactions is : %d", activeTransactions.num()),UVM_FULL); 
    if (activeTransactions.num() != 0)
    begin      
      `uvm_error("CDN_VIP_DEBUG", "activeTransactions queue is not empty, the following transactions are still pending:" );
      foreach (activeTransactions[i]) begin
        `uvm_info("CDN_VIP_DEBUG",
                    $sformatf("\nTransaction transId: %4d, Type : %10s, Last Callback : %10s ",
                              i,
                              activeTransactions[i].Type.name(),
                              activeTransactions[i].Callback.name()),
                              UVM_NONE);          
      end
    end
  endfunction
  
  virtual function void check_phase(uvm_phase phase);      
    super.check_phase(phase);
    `ifdef CDN_VIP_DEBUG
      checkAllTransactionsEnded();
    `endif
  endfunction


  virtual function void turnOnErrorReportingCallbacks();
    if (autoTurnOnErrorReportingCallbacks == 1)
    begin
      void'(this.setCallback(DENALI_ENET_CB_Error));
    end
  endfunction

  // ***************************************************************
  // Method : end_of_elaboration/end_of_elaboration_phase
  // Desc.  : Apply configuration settings in this phase
  // ***************************************************************
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    turnOnGetResponseCallbacks();
    turnOnErrorReportingCallbacks();
  endfunction : end_of_elaboration_phase
  
  // ***************************************************************
  // Method : DefaultCbF
  // Desc.  : callback function overloading
  //          This function is called whenever any of the other callback functions is called
  // ***************************************************************
  virtual function int DefaultCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.DefaultCbF(trans);
    
    activeTransactions[trans.transId] = trans;    
    
    pAgent.monitor.DefaultCbF(trans);
    pAgent.monitor.DefaultCbPort.write(trans);
    pAgent.monitor.DefaultCbEvent.trigger(trans);
    
    return status;
  endfunction : DefaultCbF
  
  // ***************************************************************
  // Method : ErrorCbF
  // Desc.  : A callback function overloading.
  //          A generic error has been detected. During this callback, Transaction field ErrorString stores character string that is a concatenation of all error messages associated with the transaction at the moment, field ErrorId holds the current error id, and field ErrorInfo holds the error severity.
  // ***************************************************************
  virtual function int ErrorCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.ErrorCbF(trans);
    
    pAgent.monitor.ErrorCbF(trans);
    pAgent.monitor.ErrorCbPort.write(trans);
    pAgent.monitor.ErrorCbEvent.trigger(trans);
    
    return status;    
  endfunction : ErrorCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ethernet packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitPktCbF(trans);
    pAgent.monitor.TxUserQueueExitPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitPktCbF
  
  // ***************************************************************
  // Method : TxPktStartedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ethernet packet transmission starts.
  // ***************************************************************
  virtual function int TxPktStartedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxPktStartedPktCbF(trans);
    
    pAgent.monitor.TxPktStartedPktCbF(trans);
    pAgent.monitor.TxPktStartedPktCbPort.write(trans);
    pAgent.monitor.TxPktStartedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxPktStartedPktCbF
  
  // ***************************************************************
  // Method : TxPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ethernet packet transmission has ended.
  // ***************************************************************
  virtual function int TxPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxPktEndedPktCbF(trans);
    
    pAgent.monitor.TxPktEndedPktCbF(trans);
    pAgent.monitor.TxPktEndedPktCbPort.write(trans);
    pAgent.monitor.TxPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxPktEndedPktCbF
  
  // ***************************************************************
  // Method : RxPktStartedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ethernet packet reception starts.
  // ***************************************************************
  virtual function int RxPktStartedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxPktStartedPktCbF(trans);
    
    pAgent.monitor.RxPktStartedPktCbF(trans);
    pAgent.monitor.RxPktStartedPktCbPort.write(trans);
    pAgent.monitor.RxPktStartedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxPktStartedPktCbF
  
  // ***************************************************************
  // Method : RxPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ethernet packet reception has ended.
  // ***************************************************************
  virtual function int RxPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxPktEndedPktCbF(trans);
    
    pAgent.monitor.RxPktEndedPktCbF(trans);
    pAgent.monitor.RxPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxPktEndedPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitMgmtPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Management packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitMgmtPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitMgmtPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitMgmtPktCbF(trans);
    pAgent.monitor.TxUserQueueExitMgmtPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitMgmtPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitMgmtPktCbF
  
  // ***************************************************************
  // Method : TxPktStartedMgmtPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Management packet transmission starts.
  // ***************************************************************
  virtual function int TxPktStartedMgmtPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxPktStartedMgmtPktCbF(trans);
    
    pAgent.monitor.TxPktStartedMgmtPktCbF(trans);
    pAgent.monitor.TxPktStartedMgmtPktCbPort.write(trans);
    pAgent.monitor.TxPktStartedMgmtPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxPktStartedMgmtPktCbF
  
  // ***************************************************************
  // Method : TxPktEndedMgmtPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Management packet transmission has ended.
  // ***************************************************************
  virtual function int TxPktEndedMgmtPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxPktEndedMgmtPktCbF(trans);
    
    pAgent.monitor.TxPktEndedMgmtPktCbF(trans);
    pAgent.monitor.TxPktEndedMgmtPktCbPort.write(trans);
    pAgent.monitor.TxPktEndedMgmtPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxPktEndedMgmtPktCbF
  
  // ***************************************************************
  // Method : RxPktEndedMgmtPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Management packet reception has ended.
  // ***************************************************************
  virtual function int RxPktEndedMgmtPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxPktEndedMgmtPktCbF(trans);
    
    pAgent.monitor.RxPktEndedMgmtPktCbF(trans);
    pAgent.monitor.RxPktEndedMgmtPktCbPort.write(trans);
    pAgent.monitor.RxPktEndedMgmtPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxPktEndedMgmtPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitTransportPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Transport packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitTransportPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitTransportPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitTransportPktCbF(trans);
    pAgent.monitor.TxUserQueueExitTransportPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitTransportPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitTransportPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitNetworkPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Network packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitNetworkPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitNetworkPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitNetworkPktCbF(trans);
    pAgent.monitor.TxUserQueueExitNetworkPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitNetworkPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitNetworkPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitMplsPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Mpls packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitMplsPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitMplsPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitMplsPktCbF(trans);
    pAgent.monitor.TxUserQueueExitMplsPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitMplsPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitMplsPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitSnapPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Snap packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitSnapPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitSnapPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitSnapPktCbF(trans);
    pAgent.monitor.TxUserQueueExitSnapPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitSnapPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitSnapPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitPtpPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ptp packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitPtpPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitPtpPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitPtpPktCbF(trans);
    pAgent.monitor.TxUserQueueExitPtpPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitPtpPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitPtpPktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitFcoePktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Fcoe packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitFcoePktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitFcoePktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitFcoePktCbF(trans);
    pAgent.monitor.TxUserQueueExitFcoePktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitFcoePktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitFcoePktCbF
  
  // ***************************************************************
  // Method : TxUserQueueExitFcPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Fc packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function int TxUserQueueExitFcPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxUserQueueExitFcPktCbF(trans);
    
    pAgent.monitor.TxUserQueueExitFcPktCbF(trans);
    pAgent.monitor.TxUserQueueExitFcPktCbPort.write(trans);
    pAgent.monitor.TxUserQueueExitFcPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxUserQueueExitFcPktCbF
  
  // ***************************************************************
  // Method : RxNetworkPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Network layer Info is extracted in a received Upper Layer packet, Network fields are available using this Callback.
  // ***************************************************************
  virtual function int RxNetworkPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxNetworkPktEndedPktCbF(trans);
    
    pAgent.monitor.RxNetworkPktEndedPktCbF(trans);
    pAgent.monitor.RxNetworkPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxNetworkPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxNetworkPktEndedPktCbF
  
  // ***************************************************************
  // Method : RxTransportPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Transport layer info is extracted in a received Upper Layer packet, Transport fields are available using this Callback
  // ***************************************************************
  virtual function int RxTransportPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxTransportPktEndedPktCbF(trans);
    
    pAgent.monitor.RxTransportPktEndedPktCbF(trans);
    pAgent.monitor.RxTransportPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxTransportPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxTransportPktEndedPktCbF
  
  // ***************************************************************
  // Method : RxMplsPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when Mpls stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_MPLS is detected. Mpls fields are availble using this Callback.
  // ***************************************************************
  virtual function int RxMplsPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxMplsPktEndedPktCbF(trans);
    
    pAgent.monitor.RxMplsPktEndedPktCbF(trans);
    pAgent.monitor.RxMplsPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxMplsPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxMplsPktEndedPktCbF
  
  // ***************************************************************
  // Method : RxSnapPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Snap stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_SNAP is detected. Snap fields are available using this Callback.
  // ***************************************************************
  virtual function int RxSnapPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxSnapPktEndedPktCbF(trans);
    
    pAgent.monitor.RxSnapPktEndedPktCbF(trans);
    pAgent.monitor.RxSnapPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxSnapPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxSnapPktEndedPktCbF
  
  // ***************************************************************
  // Method : RxPtpPktEndedPktCbF
  // Desc.  : A callback function overloading.
  //          Callback when the Ptp packet is found while extraction, Ptp fields are available using this Callback.
  // ***************************************************************
  virtual function int RxPtpPktEndedPktCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxPtpPktEndedPktCbF(trans);
    
    pAgent.monitor.RxPtpPktEndedPktCbF(trans);
    pAgent.monitor.RxPtpPktEndedPktCbPort.write(trans);
    pAgent.monitor.RxPtpPktEndedPktCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxPtpPktEndedPktCbF
  
  // ***************************************************************
  // Method : ResetAssertedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Reset is Asserted.
  // ***************************************************************
  virtual function int ResetAssertedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.ResetAssertedCbF(trans);
    
    pAgent.monitor.ResetAssertedCbF(trans);
    pAgent.monitor.ResetAssertedCbPort.write(trans);
    pAgent.monitor.ResetAssertedCbEvent.trigger(trans);
    
    return status;    
  endfunction : ResetAssertedCbF
  
  // ***************************************************************
  // Method : ResetDeassertedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Reset is Deasserted.
  // ***************************************************************
  virtual function int ResetDeassertedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.ResetDeassertedCbF(trans);
    
    pAgent.monitor.ResetDeassertedCbF(trans);
    pAgent.monitor.ResetDeassertedCbPort.write(trans);
    pAgent.monitor.ResetDeassertedCbEvent.trigger(trans);
    
    return status;    
  endfunction : ResetDeassertedCbF
  
  // ***************************************************************
  // Method : AlignStatusUpCbF
  // Desc.  : A callback function overloading.
  //          Callback when Alignment is Up.
  // ***************************************************************
  virtual function int AlignStatusUpCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AlignStatusUpCbF(trans);
    
    pAgent.monitor.AlignStatusUpCbF(trans);
    pAgent.monitor.AlignStatusUpCbPort.write(trans);
    pAgent.monitor.AlignStatusUpCbEvent.trigger(trans);
    
    return status;    
  endfunction : AlignStatusUpCbF
  
  // ***************************************************************
  // Method : AlignStatusDownCbF
  // Desc.  : A callback function overloading.
  //          Callback when Alignment is Down.
  // ***************************************************************
  virtual function int AlignStatusDownCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AlignStatusDownCbF(trans);
    
    pAgent.monitor.AlignStatusDownCbF(trans);
    pAgent.monitor.AlignStatusDownCbPort.write(trans);
    pAgent.monitor.AlignStatusDownCbEvent.trigger(trans);
    
    return status;    
  endfunction : AlignStatusDownCbF
  
  // ***************************************************************
  // Method : BlockLockUpCbF
  // Desc.  : A callback function overloading.
  //          Callback when Block Lock is Up.
  // ***************************************************************
  virtual function int BlockLockUpCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.BlockLockUpCbF(trans);
    
    pAgent.monitor.BlockLockUpCbF(trans);
    pAgent.monitor.BlockLockUpCbPort.write(trans);
    pAgent.monitor.BlockLockUpCbEvent.trigger(trans);
    
    return status;    
  endfunction : BlockLockUpCbF
  
  // ***************************************************************
  // Method : BlockLockDownCbF
  // Desc.  : A callback function overloading.
  //          Callback when Block Lock is Down.
  // ***************************************************************
  virtual function int BlockLockDownCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.BlockLockDownCbF(trans);
    
    pAgent.monitor.BlockLockDownCbF(trans);
    pAgent.monitor.BlockLockDownCbPort.write(trans);
    pAgent.monitor.BlockLockDownCbEvent.trigger(trans);
    
    return status;    
  endfunction : BlockLockDownCbF
  
  // ***************************************************************
  // Method : LocalFaultEndedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Local Fault Ended.
  // ***************************************************************
  virtual function int LocalFaultEndedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.LocalFaultEndedCbF(trans);
    
    pAgent.monitor.LocalFaultEndedCbF(trans);
    pAgent.monitor.LocalFaultEndedCbPort.write(trans);
    pAgent.monitor.LocalFaultEndedCbEvent.trigger(trans);
    
    return status;    
  endfunction : LocalFaultEndedCbF
  
  // ***************************************************************
  // Method : RemoteFaultEndedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Remote Fault Ended.
  // ***************************************************************
  virtual function int RemoteFaultEndedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RemoteFaultEndedCbF(trans);
    
    pAgent.monitor.RemoteFaultEndedCbF(trans);
    pAgent.monitor.RemoteFaultEndedCbPort.write(trans);
    pAgent.monitor.RemoteFaultEndedCbEvent.trigger(trans);
    
    return status;    
  endfunction : RemoteFaultEndedCbF
  
  // ***************************************************************
  // Method : TrainingFrameTransmittedCbF
  // Desc.  : A callback function overloading.
  //          Callback when a Training Frame is transmitted.
  // ***************************************************************
  virtual function int TrainingFrameTransmittedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TrainingFrameTransmittedCbF(trans);
    
    pAgent.monitor.TrainingFrameTransmittedCbF(trans);
    pAgent.monitor.TrainingFrameTransmittedCbPort.write(trans);
    pAgent.monitor.TrainingFrameTransmittedCbEvent.trigger(trans);
    
    return status;    
  endfunction : TrainingFrameTransmittedCbF
  
  // ***************************************************************
  // Method : TrainingFrameReceivedCbF
  // Desc.  : A callback function overloading.
  //          Callback when a Training Frame is received.
  // ***************************************************************
  virtual function int TrainingFrameReceivedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TrainingFrameReceivedCbF(trans);
    
    pAgent.monitor.TrainingFrameReceivedCbF(trans);
    pAgent.monitor.TrainingFrameReceivedCbPort.write(trans);
    pAgent.monitor.TrainingFrameReceivedCbEvent.trigger(trans);
    
    return status;    
  endfunction : TrainingFrameReceivedCbF
  
  // ***************************************************************
  // Method : Cl37ANStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Cl37 State changed.
  // ***************************************************************
  virtual function int Cl37ANStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl37ANStateChangedCbF(trans);
    
    pAgent.monitor.Cl37ANStateChangedCbF(trans);
    pAgent.monitor.Cl37ANStateChangedCbPort.write(trans);
    pAgent.monitor.Cl37ANStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl37ANStateChangedCbF
  
  // ***************************************************************
  // Method : TengkrPmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when TENGKR PMD Link Training FSM's state changes.
  // ***************************************************************
  virtual function int TengkrPmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TengkrPmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.TengkrPmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.TengkrPmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.TengkrPmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : TengkrPmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane0PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-0.
  // ***************************************************************
  virtual function int Cg100gbaserLane0PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane0PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane0PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane0PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane0PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane0PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane1PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-1.
  // ***************************************************************
  virtual function int Cg100gbaserLane1PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane1PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane1PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane1PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane1PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane1PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane2PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-2.
  // ***************************************************************
  virtual function int Cg100gbaserLane2PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane2PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane2PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane2PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane2PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane2PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane3PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-3.
  // ***************************************************************
  virtual function int Cg100gbaserLane3PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane3PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane3PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane3PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane3PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane3PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane4PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-4.
  // ***************************************************************
  virtual function int Cg100gbaserLane4PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane4PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane4PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane4PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane4PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane4PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane5PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-5.
  // ***************************************************************
  virtual function int Cg100gbaserLane5PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane5PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane5PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane5PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane5PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane5PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane6PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-6.
  // ***************************************************************
  virtual function int Cg100gbaserLane6PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane6PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane6PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane6PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane6PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane6PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane7PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-7.
  // ***************************************************************
  virtual function int Cg100gbaserLane7PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane7PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane7PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane7PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane7PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane7PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane8PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-8.
  // ***************************************************************
  virtual function int Cg100gbaserLane8PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane8PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane8PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane8PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane8PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane8PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cg100gbaserLane9PmdLinkTrainingStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-9.
  // ***************************************************************
  virtual function int Cg100gbaserLane9PmdLinkTrainingStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cg100gbaserLane9PmdLinkTrainingStateChangedCbF(trans);
    
    pAgent.monitor.Cg100gbaserLane9PmdLinkTrainingStateChangedCbF(trans);
    pAgent.monitor.Cg100gbaserLane9PmdLinkTrainingStateChangedCbPort.write(trans);
    pAgent.monitor.Cg100gbaserLane9PmdLinkTrainingStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cg100gbaserLane9PmdLinkTrainingStateChangedCbF
  
  // ***************************************************************
  // Method : Cl73ArbitrationStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when Cl73 Arbitration State changed.
  // ***************************************************************
  virtual function int Cl73ArbitrationStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl73ArbitrationStateChangedCbF(trans);
    
    pAgent.monitor.Cl73ArbitrationStateChangedCbF(trans);
    pAgent.monitor.Cl73ArbitrationStateChangedCbPort.write(trans);
    pAgent.monitor.Cl73ArbitrationStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl73ArbitrationStateChangedCbF
  
  // ***************************************************************
  // Method : SyncStatusUpCbF
  // Desc.  : A callback function overloading.
  //          Callback when Cl36 PCS Code Group Synchronization is achieved.
  // ***************************************************************
  virtual function int SyncStatusUpCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.SyncStatusUpCbF(trans);
    
    pAgent.monitor.SyncStatusUpCbF(trans);
    pAgent.monitor.SyncStatusUpCbPort.write(trans);
    pAgent.monitor.SyncStatusUpCbEvent.trigger(trans);
    
    return status;    
  endfunction : SyncStatusUpCbF
  
  // ***************************************************************
  // Method : SyncStatusDownCbF
  // Desc.  : A callback function overloading.
  //          Callback when Cl36 PCS Code Group Synchronization is lost.
  // ***************************************************************
  virtual function int SyncStatusDownCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.SyncStatusDownCbF(trans);
    
    pAgent.monitor.SyncStatusDownCbF(trans);
    pAgent.monitor.SyncStatusDownCbPort.write(trans);
    pAgent.monitor.SyncStatusDownCbEvent.trigger(trans);
    
    return status;    
  endfunction : SyncStatusDownCbF
  
  // ***************************************************************
  // Method : Cl73AnDmePageReadyToBeXmittedCbF
  // Desc.  : A callback function overloading.
  //          Callback when a DME Page is ready to be transmitted by the Clause-73 AN FSM for Backplane Interfaces. For Error Injection, this page can now be modified using Cl73AnDmePageToBeXmittedLow(Lower 32-bits) and Cl73AnDmePageToBeXmittedHigh(Upper 17-bits) registers.
  // ***************************************************************
  virtual function int Cl73AnDmePageReadyToBeXmittedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl73AnDmePageReadyToBeXmittedCbF(trans);
    
    pAgent.monitor.Cl73AnDmePageReadyToBeXmittedCbF(trans);
    pAgent.monitor.Cl73AnDmePageReadyToBeXmittedCbPort.write(trans);
    pAgent.monitor.Cl73AnDmePageReadyToBeXmittedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl73AnDmePageReadyToBeXmittedCbF
  
  // ***************************************************************
  // Method : Cl73AnDmePageXmittedCbF
  // Desc.  : A callback function overloading.
  //          Callback when a DME Page is transmitted by the Clause-73 AN FSM for Backplane Interfaces.
  // ***************************************************************
  virtual function int Cl73AnDmePageXmittedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl73AnDmePageXmittedCbF(trans);
    
    pAgent.monitor.Cl73AnDmePageXmittedCbF(trans);
    pAgent.monitor.Cl73AnDmePageXmittedCbPort.write(trans);
    pAgent.monitor.Cl73AnDmePageXmittedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl73AnDmePageXmittedCbF
  
  // ***************************************************************
  // Method : Cl73AnDmePageRcvdCbF
  // Desc.  : A callback function overloading.
  //          Callback when a DME Page is received by the Clause-73 AN FSM for Backplane Interfaces.
  // ***************************************************************
  virtual function int Cl73AnDmePageRcvdCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl73AnDmePageRcvdCbF(trans);
    
    pAgent.monitor.Cl73AnDmePageRcvdCbF(trans);
    pAgent.monitor.Cl73AnDmePageRcvdCbPort.write(trans);
    pAgent.monitor.Cl73AnDmePageRcvdCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl73AnDmePageRcvdCbF
  
  // ***************************************************************
  // Method : Cl37AnConfigRegXmittedCbF
  // Desc.  : A callback function overloading.
  //          Callback when a ConfigReg is transmitted by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX.
  // ***************************************************************
  virtual function int Cl37AnConfigRegXmittedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl37AnConfigRegXmittedCbF(trans);
    
    pAgent.monitor.Cl37AnConfigRegXmittedCbF(trans);
    pAgent.monitor.Cl37AnConfigRegXmittedCbPort.write(trans);
    pAgent.monitor.Cl37AnConfigRegXmittedCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl37AnConfigRegXmittedCbF
  
  // ***************************************************************
  // Method : Cl37AnConfigRegRcvdCbF
  // Desc.  : A callback function overloading.
  //          Callback when a ConfigReg is received by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX.
  // ***************************************************************
  virtual function int Cl37AnConfigRegRcvdCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.Cl37AnConfigRegRcvdCbF(trans);
    
    pAgent.monitor.Cl37AnConfigRegRcvdCbF(trans);
    pAgent.monitor.Cl37AnConfigRegRcvdCbPort.write(trans);
    pAgent.monitor.Cl37AnConfigRegRcvdCbEvent.trigger(trans);
    
    return status;    
  endfunction : Cl37AnConfigRegRcvdCbF
  
  // ***************************************************************
  // Method : EeeStateChangedCbF
  // Desc.  : A callback function overloading.
  //          Callback when EEE QUIET STATE is started.
  // ***************************************************************
  virtual function int EeeStateChangedCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.EeeStateChangedCbF(trans);
    
    pAgent.monitor.EeeStateChangedCbF(trans);
    pAgent.monitor.EeeStateChangedCbPort.write(trans);
    pAgent.monitor.EeeStateChangedCbEvent.trigger(trans);
    
    return status;    
  endfunction : EeeStateChangedCbF
  
  // ***************************************************************
  // Method : LpiTxTqTimerDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback when Lpi Tx Tq timer is done.
  // ***************************************************************
  virtual function int LpiTxTqTimerDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.LpiTxTqTimerDoneCbF(trans);
    
    pAgent.monitor.LpiTxTqTimerDoneCbF(trans);
    pAgent.monitor.LpiTxTqTimerDoneCbPort.write(trans);
    pAgent.monitor.LpiTxTqTimerDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : LpiTxTqTimerDoneCbF
  
  // ***************************************************************
  // Method : TxPktRawDataBeforeTransmissionCbF
  // Desc.  : A callback function overloading.
  //          This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is packed before transmission and the packed raw data list can be modified by the User. This callback is fired after the TxUserQueueExitPkt callback and before TxPktStartedPkt callback.
  // ***************************************************************
  virtual function int TxPktRawDataBeforeTransmissionCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.TxPktRawDataBeforeTransmissionCbF(trans);
    
    pAgent.monitor.TxPktRawDataBeforeTransmissionCbF(trans);
    pAgent.monitor.TxPktRawDataBeforeTransmissionCbPort.write(trans);
    pAgent.monitor.TxPktRawDataBeforeTransmissionCbEvent.trigger(trans);
    
    return status;    
  endfunction : TxPktRawDataBeforeTransmissionCbF
  
  // ***************************************************************
  // Method : RxPktRawDataAfterReceptionCbF
  // Desc.  : A callback function overloading.
  //          This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is received through the interface and after reception, the packed raw data list can be modified by the User before the list is unpacked into an Ethernet packet. This callback is fired after the RxPktStartedPkt callback and before RxPktEndedPkt callback.
  // ***************************************************************
  virtual function int RxPktRawDataAfterReceptionCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.RxPktRawDataAfterReceptionCbF(trans);
    
    pAgent.monitor.RxPktRawDataAfterReceptionCbF(trans);
    pAgent.monitor.RxPktRawDataAfterReceptionCbPort.write(trans);
    pAgent.monitor.RxPktRawDataAfterReceptionCbEvent.trigger(trans);
    
    return status;    
  endfunction : RxPktRawDataAfterReceptionCbF
  
  // ***************************************************************
  // Method : AvipNotifyOkToSendCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipNotifyOkToSendCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipNotifyOkToSendCbF(trans);
    
    pAgent.monitor.AvipNotifyOkToSendCbF(trans);
    pAgent.monitor.AvipNotifyOkToSendCbPort.write(trans);
    pAgent.monitor.AvipNotifyOkToSendCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipNotifyOkToSendCbF
  
  // ***************************************************************
  // Method : AvipFlushAllBuffersCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipFlushAllBuffersCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipFlushAllBuffersCbF(trans);
    
    pAgent.monitor.AvipFlushAllBuffersCbF(trans);
    pAgent.monitor.AvipFlushAllBuffersCbPort.write(trans);
    pAgent.monitor.AvipFlushAllBuffersCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipFlushAllBuffersCbF
  
  // ***************************************************************
  // Method : AvipRegWriteDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipRegWriteDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipRegWriteDoneCbF(trans);
    
    pAgent.monitor.AvipRegWriteDoneCbF(trans);
    pAgent.monitor.AvipRegWriteDoneCbPort.write(trans);
    pAgent.monitor.AvipRegWriteDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipRegWriteDoneCbF
  
  // ***************************************************************
  // Method : AvipRegReadDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipRegReadDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipRegReadDoneCbF(trans);
    
    pAgent.monitor.AvipRegReadDoneCbF(trans);
    pAgent.monitor.AvipRegReadDoneCbPort.write(trans);
    pAgent.monitor.AvipRegReadDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipRegReadDoneCbF
  
  // ***************************************************************
  // Method : AvipRegOpDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipRegOpDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipRegOpDoneCbF(trans);
    
    pAgent.monitor.AvipRegOpDoneCbF(trans);
    pAgent.monitor.AvipRegOpDoneCbPort.write(trans);
    pAgent.monitor.AvipRegOpDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipRegOpDoneCbF
  
  // ***************************************************************
  // Method : AvipMdioWriteDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipMdioWriteDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipMdioWriteDoneCbF(trans);
    
    pAgent.monitor.AvipMdioWriteDoneCbF(trans);
    pAgent.monitor.AvipMdioWriteDoneCbPort.write(trans);
    pAgent.monitor.AvipMdioWriteDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipMdioWriteDoneCbF
  
  // ***************************************************************
  // Method : AvipMdioReadDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipMdioReadDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipMdioReadDoneCbF(trans);
    
    pAgent.monitor.AvipMdioReadDoneCbF(trans);
    pAgent.monitor.AvipMdioReadDoneCbPort.write(trans);
    pAgent.monitor.AvipMdioReadDoneCbEvent.trigger(trans);
    
    return status;    
  endfunction : AvipMdioReadDoneCbF
  
  // ***************************************************************
  // Method : AvipMdioOpDoneCbF
  // Desc.  : A callback function overloading.
  //          Callback for AVIP use only.
  // ***************************************************************
  virtual function int AvipMdioOpDoneCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.AvipMdioOpDoneCbF(trans);
    
    pAgent.monitor.AvipMdioOpDoneCbF(trans);
    pAgent.monitor.AvipMdioOpDoneCbPort.write(trans);
    pAgent.monitor.AvipMdioOpDoneCbEvent.trigger(trans);

    return status;    
  endfunction : AvipMdioOpDoneCbF
  
  // ***************************************************************
  // Method : CoverageSampleCbF
  // Desc.  : A callback function overloading.
  //          An internal callback for coverage collection this callback is only for internal use.
  // ***************************************************************
  virtual function int CoverageSampleCbF(ref denaliEnetTransaction trans);
    int status;
    
    status = super.CoverageSampleCbF(trans);
    
    pAgent.monitor.CoverageSampleCbF(trans);
    pAgent.monitor.CoverageSampleCbPort.write(trans);
    pAgent.monitor.CoverageSampleCbEvent.trigger(trans);
    
    return status;    
  endfunction : CoverageSampleCbF

endclass : cdnEnetUvmInstance

`endif // CDN_ENET_UVM_INSTANCE_SV
