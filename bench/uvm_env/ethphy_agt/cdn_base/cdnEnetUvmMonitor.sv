
`ifndef CDN_ENET_UVM_MONITOR_SV
`define CDN_ENET_UVM_MONITOR_SV

`uvm_analysis_imp_decl(_enet_monitor_Error)


// ***************************************************************
// class: cdnEnetUvmMonitor
// This class monitors protocol activity, extracts events and analysis ports, and collects coverage.
// ***************************************************************
class cdnEnetUvmMonitor extends uvm_monitor;
  
  // ***************************************************************
  // A reference to the agent, as set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
  
  // ***************************************************************
  // A reference to the instance, as set by the agent.
  // ***************************************************************
  cdnEnetUvmInstance pInst;
  
  // ***************************************************************
  // A reference to the coverage model and coverage enable bit
  // ***************************************************************
  cdnEnetUvmCoverage coverModel;
  bit coverageEnable = 0;

  
  // ***************************************************************
  // UVM Class and fields registration
  // ***************************************************************
  `uvm_component_utils_begin(cdnEnetUvmMonitor)
    `uvm_field_int(coverageEnable, UVM_ALL_ON)
  `uvm_component_utils_end

  // ***************************************************************
  //  DefaultCbF is called when the DefaultCbF function in pInst is called.
  // ***************************************************************
  virtual function void DefaultCbF(denaliEnetTransaction trans);
  endfunction : DefaultCbF

  // ***************************************************************
  // ErrorCbF function
  // This function is called when the ErrorCbF function in pInst is called, if the Error callback is enabled.
  // ErrorCbF function description: A generic error has been detected. During this callback, Transaction field ErrorString stores character string that is a concatenation of all error messages associated with the transaction at the moment, field ErrorId holds the current error id, and field ErrorInfo holds the error severity.
  // ***************************************************************
  virtual function void ErrorCbF(denaliEnetTransaction trans);
  endfunction : ErrorCbF

  // ***************************************************************
  // TxUserQueueExitPktCbF function
  // This function is called when the TxUserQueueExitPktCbF function in pInst is called, if the TxUserQueueExitPkt callback is enabled.
  // TxUserQueueExitPktCbF function description: Callback when the Ethernet packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitPktCbF

  // ***************************************************************
  // TxPktStartedPktCbF function
  // This function is called when the TxPktStartedPktCbF function in pInst is called, if the TxPktStartedPkt callback is enabled.
  // TxPktStartedPktCbF function description: Callback when the Ethernet packet transmission starts.
  // ***************************************************************
  virtual function void TxPktStartedPktCbF(denaliEnetTransaction trans);
  endfunction : TxPktStartedPktCbF

  // ***************************************************************
  // TxPktEndedPktCbF function
  // This function is called when the TxPktEndedPktCbF function in pInst is called, if the TxPktEndedPkt callback is enabled.
  // TxPktEndedPktCbF function description: Callback when the Ethernet packet transmission has ended.
  // ***************************************************************
  virtual function void TxPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : TxPktEndedPktCbF

  // ***************************************************************
  // RxPktStartedPktCbF function
  // This function is called when the RxPktStartedPktCbF function in pInst is called, if the RxPktStartedPkt callback is enabled.
  // RxPktStartedPktCbF function description: Callback when the Ethernet packet reception starts.
  // ***************************************************************
  virtual function void RxPktStartedPktCbF(denaliEnetTransaction trans);
  endfunction : RxPktStartedPktCbF

  // ***************************************************************
  // RxPktEndedPktCbF function
  // This function is called when the RxPktEndedPktCbF function in pInst is called, if the RxPktEndedPkt callback is enabled.
  // RxPktEndedPktCbF function description: Callback when the Ethernet packet reception has ended.
  // ***************************************************************
  virtual function void RxPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxPktEndedPktCbF

  // ***************************************************************
  // TxUserQueueExitMgmtPktCbF function
  // This function is called when the TxUserQueueExitMgmtPktCbF function in pInst is called, if the TxUserQueueExitMgmtPkt callback is enabled.
  // TxUserQueueExitMgmtPktCbF function description: Callback when the Management packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitMgmtPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitMgmtPktCbF

  // ***************************************************************
  // TxPktStartedMgmtPktCbF function
  // This function is called when the TxPktStartedMgmtPktCbF function in pInst is called, if the TxPktStartedMgmtPkt callback is enabled.
  // TxPktStartedMgmtPktCbF function description: Callback when the Management packet transmission starts.
  // ***************************************************************
  virtual function void TxPktStartedMgmtPktCbF(denaliEnetTransaction trans);
  endfunction : TxPktStartedMgmtPktCbF

  // ***************************************************************
  // TxPktEndedMgmtPktCbF function
  // This function is called when the TxPktEndedMgmtPktCbF function in pInst is called, if the TxPktEndedMgmtPkt callback is enabled.
  // TxPktEndedMgmtPktCbF function description: Callback when the Management packet transmission has ended.
  // ***************************************************************
  virtual function void TxPktEndedMgmtPktCbF(denaliEnetTransaction trans);
  endfunction : TxPktEndedMgmtPktCbF

  // ***************************************************************
  // RxPktEndedMgmtPktCbF function
  // This function is called when the RxPktEndedMgmtPktCbF function in pInst is called, if the RxPktEndedMgmtPkt callback is enabled.
  // RxPktEndedMgmtPktCbF function description: Callback when the Management packet reception has ended.
  // ***************************************************************
  virtual function void RxPktEndedMgmtPktCbF(denaliEnetTransaction trans);
  endfunction : RxPktEndedMgmtPktCbF

  // ***************************************************************
  // TxUserQueueExitTransportPktCbF function
  // This function is called when the TxUserQueueExitTransportPktCbF function in pInst is called, if the TxUserQueueExitTransportPkt callback is enabled.
  // TxUserQueueExitTransportPktCbF function description: Callback when the Transport packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitTransportPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitTransportPktCbF

  // ***************************************************************
  // TxUserQueueExitNetworkPktCbF function
  // This function is called when the TxUserQueueExitNetworkPktCbF function in pInst is called, if the TxUserQueueExitNetworkPkt callback is enabled.
  // TxUserQueueExitNetworkPktCbF function description: Callback when the Network packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitNetworkPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitNetworkPktCbF

  // ***************************************************************
  // TxUserQueueExitMplsPktCbF function
  // This function is called when the TxUserQueueExitMplsPktCbF function in pInst is called, if the TxUserQueueExitMplsPkt callback is enabled.
  // TxUserQueueExitMplsPktCbF function description: Callback when the Mpls packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitMplsPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitMplsPktCbF

  // ***************************************************************
  // TxUserQueueExitSnapPktCbF function
  // This function is called when the TxUserQueueExitSnapPktCbF function in pInst is called, if the TxUserQueueExitSnapPkt callback is enabled.
  // TxUserQueueExitSnapPktCbF function description: Callback when the Snap packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitSnapPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitSnapPktCbF

  // ***************************************************************
  // TxUserQueueExitPtpPktCbF function
  // This function is called when the TxUserQueueExitPtpPktCbF function in pInst is called, if the TxUserQueueExitPtpPkt callback is enabled.
  // TxUserQueueExitPtpPktCbF function description: Callback when the Ptp packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitPtpPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitPtpPktCbF

  // ***************************************************************
  // TxUserQueueExitFcoePktCbF function
  // This function is called when the TxUserQueueExitFcoePktCbF function in pInst is called, if the TxUserQueueExitFcoePkt callback is enabled.
  // TxUserQueueExitFcoePktCbF function description: Callback when the Fcoe packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitFcoePktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitFcoePktCbF

  // ***************************************************************
  // TxUserQueueExitFcPktCbF function
  // This function is called when the TxUserQueueExitFcPktCbF function in pInst is called, if the TxUserQueueExitFcPkt callback is enabled.
  // TxUserQueueExitFcPktCbF function description: Callback when the Fc packet has exited from the Queue, and now the packet can be modified by the User.
  // ***************************************************************
  virtual function void TxUserQueueExitFcPktCbF(denaliEnetTransaction trans);
  endfunction : TxUserQueueExitFcPktCbF

  // ***************************************************************
  // RxNetworkPktEndedPktCbF function
  // This function is called when the RxNetworkPktEndedPktCbF function in pInst is called, if the RxNetworkPktEndedPkt callback is enabled.
  // RxNetworkPktEndedPktCbF function description: Callback when the Network layer Info is extracted in a received Upper Layer packet, Network fields are available using this Callback.
  // ***************************************************************
  virtual function void RxNetworkPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxNetworkPktEndedPktCbF

  // ***************************************************************
  // RxTransportPktEndedPktCbF function
  // This function is called when the RxTransportPktEndedPktCbF function in pInst is called, if the RxTransportPktEndedPkt callback is enabled.
  // RxTransportPktEndedPktCbF function description: Callback when the Transport layer info is extracted in a received Upper Layer packet, Transport fields are available using this Callback
  // ***************************************************************
  virtual function void RxTransportPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxTransportPktEndedPktCbF

  // ***************************************************************
  // RxMplsPktEndedPktCbF function
  // This function is called when the RxMplsPktEndedPktCbF function in pInst is called, if the RxMplsPktEndedPkt callback is enabled.
  // RxMplsPktEndedPktCbF function description: Callback when Mpls stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_MPLS is detected. Mpls fields are availble using this Callback.
  // ***************************************************************
  virtual function void RxMplsPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxMplsPktEndedPktCbF

  // ***************************************************************
  // RxSnapPktEndedPktCbF function
  // This function is called when the RxSnapPktEndedPktCbF function in pInst is called, if the RxSnapPktEndedPkt callback is enabled.
  // RxSnapPktEndedPktCbF function description: Callback when the Snap stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_SNAP is detected. Snap fields are available using this Callback.
  // ***************************************************************
  virtual function void RxSnapPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxSnapPktEndedPktCbF

  // ***************************************************************
  // RxPtpPktEndedPktCbF function
  // This function is called when the RxPtpPktEndedPktCbF function in pInst is called, if the RxPtpPktEndedPkt callback is enabled.
  // RxPtpPktEndedPktCbF function description: Callback when the Ptp packet is found while extraction, Ptp fields are available using this Callback.
  // ***************************************************************
  virtual function void RxPtpPktEndedPktCbF(denaliEnetTransaction trans);
  endfunction : RxPtpPktEndedPktCbF

  // ***************************************************************
  // ResetAssertedCbF function
  // This function is called when the ResetAssertedCbF function in pInst is called, if the ResetAsserted callback is enabled.
  // ResetAssertedCbF function description: Callback when Reset is Asserted.
  // ***************************************************************
  virtual function void ResetAssertedCbF(denaliEnetTransaction trans);
  endfunction : ResetAssertedCbF

  // ***************************************************************
  // ResetDeassertedCbF function
  // This function is called when the ResetDeassertedCbF function in pInst is called, if the ResetDeasserted callback is enabled.
  // ResetDeassertedCbF function description: Callback when Reset is Deasserted.
  // ***************************************************************
  virtual function void ResetDeassertedCbF(denaliEnetTransaction trans);
  endfunction : ResetDeassertedCbF

  // ***************************************************************
  // AlignStatusUpCbF function
  // This function is called when the AlignStatusUpCbF function in pInst is called, if the AlignStatusUp callback is enabled.
  // AlignStatusUpCbF function description: Callback when Alignment is Up.
  // ***************************************************************
  virtual function void AlignStatusUpCbF(denaliEnetTransaction trans);
  endfunction : AlignStatusUpCbF

  // ***************************************************************
  // AlignStatusDownCbF function
  // This function is called when the AlignStatusDownCbF function in pInst is called, if the AlignStatusDown callback is enabled.
  // AlignStatusDownCbF function description: Callback when Alignment is Down.
  // ***************************************************************
  virtual function void AlignStatusDownCbF(denaliEnetTransaction trans);
  endfunction : AlignStatusDownCbF

  // ***************************************************************
  // BlockLockUpCbF function
  // This function is called when the BlockLockUpCbF function in pInst is called, if the BlockLockUp callback is enabled.
  // BlockLockUpCbF function description: Callback when Block Lock is Up.
  // ***************************************************************
  virtual function void BlockLockUpCbF(denaliEnetTransaction trans);
  endfunction : BlockLockUpCbF

  // ***************************************************************
  // BlockLockDownCbF function
  // This function is called when the BlockLockDownCbF function in pInst is called, if the BlockLockDown callback is enabled.
  // BlockLockDownCbF function description: Callback when Block Lock is Down.
  // ***************************************************************
  virtual function void BlockLockDownCbF(denaliEnetTransaction trans);
  endfunction : BlockLockDownCbF

  // ***************************************************************
  // LocalFaultEndedCbF function
  // This function is called when the LocalFaultEndedCbF function in pInst is called, if the LocalFaultEnded callback is enabled.
  // LocalFaultEndedCbF function description: Callback when Local Fault Ended.
  // ***************************************************************
  virtual function void LocalFaultEndedCbF(denaliEnetTransaction trans);
  endfunction : LocalFaultEndedCbF

  // ***************************************************************
  // RemoteFaultEndedCbF function
  // This function is called when the RemoteFaultEndedCbF function in pInst is called, if the RemoteFaultEnded callback is enabled.
  // RemoteFaultEndedCbF function description: Callback when Remote Fault Ended.
  // ***************************************************************
  virtual function void RemoteFaultEndedCbF(denaliEnetTransaction trans);
  endfunction : RemoteFaultEndedCbF

  // ***************************************************************
  // TrainingFrameTransmittedCbF function
  // This function is called when the TrainingFrameTransmittedCbF function in pInst is called, if the TrainingFrameTransmitted callback is enabled.
  // TrainingFrameTransmittedCbF function description: Callback when a Training Frame is transmitted.
  // ***************************************************************
  virtual function void TrainingFrameTransmittedCbF(denaliEnetTransaction trans);
  endfunction : TrainingFrameTransmittedCbF

  // ***************************************************************
  // TrainingFrameReceivedCbF function
  // This function is called when the TrainingFrameReceivedCbF function in pInst is called, if the TrainingFrameReceived callback is enabled.
  // TrainingFrameReceivedCbF function description: Callback when a Training Frame is received.
  // ***************************************************************
  virtual function void TrainingFrameReceivedCbF(denaliEnetTransaction trans);
  endfunction : TrainingFrameReceivedCbF

  // ***************************************************************
  // Cl37ANStateChangedCbF function
  // This function is called when the Cl37ANStateChangedCbF function in pInst is called, if the Cl37ANStateChanged callback is enabled.
  // Cl37ANStateChangedCbF function description: Callback when Cl37 State changed.
  // ***************************************************************
  virtual function void Cl37ANStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cl37ANStateChangedCbF

  // ***************************************************************
  // TengkrPmdLinkTrainingStateChangedCbF function
  // This function is called when the TengkrPmdLinkTrainingStateChangedCbF function in pInst is called, if the TengkrPmdLinkTrainingStateChanged callback is enabled.
  // TengkrPmdLinkTrainingStateChangedCbF function description: Callback when TENGKR PMD Link Training FSM's state changes.
  // ***************************************************************
  virtual function void TengkrPmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : TengkrPmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane0PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-0.
  // ***************************************************************
  virtual function void Cg100gbaserLane0PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane0PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane1PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-1.
  // ***************************************************************
  virtual function void Cg100gbaserLane1PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane1PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane2PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-2.
  // ***************************************************************
  virtual function void Cg100gbaserLane2PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane2PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane3PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-3.
  // ***************************************************************
  virtual function void Cg100gbaserLane3PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane3PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane4PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-4.
  // ***************************************************************
  virtual function void Cg100gbaserLane4PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane4PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane5PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-5.
  // ***************************************************************
  virtual function void Cg100gbaserLane5PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane5PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane6PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-6.
  // ***************************************************************
  virtual function void Cg100gbaserLane6PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane6PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane7PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-7.
  // ***************************************************************
  virtual function void Cg100gbaserLane7PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane7PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane8PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-8.
  // ***************************************************************
  virtual function void Cg100gbaserLane8PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane8PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function
  // This function is called when the Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane9PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-9.
  // ***************************************************************
  virtual function void Cg100gbaserLane9PmdLinkTrainingStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cg100gbaserLane9PmdLinkTrainingStateChangedCbF

  // ***************************************************************
  // Cl73ArbitrationStateChangedCbF function
  // This function is called when the Cl73ArbitrationStateChangedCbF function in pInst is called, if the Cl73ArbitrationStateChanged callback is enabled.
  // Cl73ArbitrationStateChangedCbF function description: Callback when Cl73 Arbitration State changed.
  // ***************************************************************
  virtual function void Cl73ArbitrationStateChangedCbF(denaliEnetTransaction trans);
  endfunction : Cl73ArbitrationStateChangedCbF

  // ***************************************************************
  // SyncStatusUpCbF function
  // This function is called when the SyncStatusUpCbF function in pInst is called, if the SyncStatusUp callback is enabled.
  // SyncStatusUpCbF function description: Callback when Cl36 PCS Code Group Synchronization is achieved.
  // ***************************************************************
  virtual function void SyncStatusUpCbF(denaliEnetTransaction trans);
  endfunction : SyncStatusUpCbF

  // ***************************************************************
  // SyncStatusDownCbF function
  // This function is called when the SyncStatusDownCbF function in pInst is called, if the SyncStatusDown callback is enabled.
  // SyncStatusDownCbF function description: Callback when Cl36 PCS Code Group Synchronization is lost.
  // ***************************************************************
  virtual function void SyncStatusDownCbF(denaliEnetTransaction trans);
  endfunction : SyncStatusDownCbF

  // ***************************************************************
  // Cl73AnDmePageReadyToBeXmittedCbF function
  // This function is called when the Cl73AnDmePageReadyToBeXmittedCbF function in pInst is called, if the Cl73AnDmePageReadyToBeXmitted callback is enabled.
  // Cl73AnDmePageReadyToBeXmittedCbF function description: Callback when a DME Page is ready to be transmitted by the Clause-73 AN FSM for Backplane Interfaces. For Error Injection, this page can now be modified using Cl73AnDmePageToBeXmittedLow(Lower 32-bits) and Cl73AnDmePageToBeXmittedHigh(Upper 17-bits) registers.
  // ***************************************************************
  virtual function void Cl73AnDmePageReadyToBeXmittedCbF(denaliEnetTransaction trans);
  endfunction : Cl73AnDmePageReadyToBeXmittedCbF

  // ***************************************************************
  // Cl73AnDmePageXmittedCbF function
  // This function is called when the Cl73AnDmePageXmittedCbF function in pInst is called, if the Cl73AnDmePageXmitted callback is enabled.
  // Cl73AnDmePageXmittedCbF function description: Callback when a DME Page is transmitted by the Clause-73 AN FSM for Backplane Interfaces.
  // ***************************************************************
  virtual function void Cl73AnDmePageXmittedCbF(denaliEnetTransaction trans);
  endfunction : Cl73AnDmePageXmittedCbF

  // ***************************************************************
  // Cl73AnDmePageRcvdCbF function
  // This function is called when the Cl73AnDmePageRcvdCbF function in pInst is called, if the Cl73AnDmePageRcvd callback is enabled.
  // Cl73AnDmePageRcvdCbF function description: Callback when a DME Page is received by the Clause-73 AN FSM for Backplane Interfaces.
  // ***************************************************************
  virtual function void Cl73AnDmePageRcvdCbF(denaliEnetTransaction trans);
  endfunction : Cl73AnDmePageRcvdCbF

  // ***************************************************************
  // Cl37AnConfigRegXmittedCbF function
  // This function is called when the Cl37AnConfigRegXmittedCbF function in pInst is called, if the Cl37AnConfigRegXmitted callback is enabled.
  // Cl37AnConfigRegXmittedCbF function description: Callback when a ConfigReg is transmitted by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX.
  // ***************************************************************
  virtual function void Cl37AnConfigRegXmittedCbF(denaliEnetTransaction trans);
  endfunction : Cl37AnConfigRegXmittedCbF

  // ***************************************************************
  // Cl37AnConfigRegRcvdCbF function
  // This function is called when the Cl37AnConfigRegRcvdCbF function in pInst is called, if the Cl37AnConfigRegRcvd callback is enabled.
  // Cl37AnConfigRegRcvdCbF function description: Callback when a ConfigReg is received by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX.
  // ***************************************************************
  virtual function void Cl37AnConfigRegRcvdCbF(denaliEnetTransaction trans);
  endfunction : Cl37AnConfigRegRcvdCbF

  // ***************************************************************
  // EeeStateChangedCbF function
  // This function is called when the EeeStateChangedCbF function in pInst is called, if the EeeStateChanged callback is enabled.
  // EeeStateChangedCbF function description: Callback when EEE QUIET STATE is started.
  // ***************************************************************
  virtual function void EeeStateChangedCbF(denaliEnetTransaction trans);
  endfunction : EeeStateChangedCbF

  // ***************************************************************
  // LpiTxTqTimerDoneCbF function
  // This function is called when the LpiTxTqTimerDoneCbF function in pInst is called, if the LpiTxTqTimerDone callback is enabled.
  // LpiTxTqTimerDoneCbF function description: Callback when Lpi Tx Tq timer is done.
  // ***************************************************************
  virtual function void LpiTxTqTimerDoneCbF(denaliEnetTransaction trans);
  endfunction : LpiTxTqTimerDoneCbF

  // ***************************************************************
  // TxPktRawDataBeforeTransmissionCbF function
  // This function is called when the TxPktRawDataBeforeTransmissionCbF function in pInst is called, if the TxPktRawDataBeforeTransmission callback is enabled.
  // TxPktRawDataBeforeTransmissionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is packed before transmission and the packed raw data list can be modified by the User. This callback is fired after the TxUserQueueExitPkt callback and before TxPktStartedPkt callback.
  // ***************************************************************
  virtual function void TxPktRawDataBeforeTransmissionCbF(denaliEnetTransaction trans);
  endfunction : TxPktRawDataBeforeTransmissionCbF

  // ***************************************************************
  // RxPktRawDataAfterReceptionCbF function
  // This function is called when the RxPktRawDataAfterReceptionCbF function in pInst is called, if the RxPktRawDataAfterReception callback is enabled.
  // RxPktRawDataAfterReceptionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is received through the interface and after reception, the packed raw data list can be modified by the User before the list is unpacked into an Ethernet packet. This callback is fired after the RxPktStartedPkt callback and before RxPktEndedPkt callback.
  // ***************************************************************
  virtual function void RxPktRawDataAfterReceptionCbF(denaliEnetTransaction trans);
  endfunction : RxPktRawDataAfterReceptionCbF

  // ***************************************************************
  // AvipNotifyOkToSendCbF function
  // This function is called when the AvipNotifyOkToSendCbF function in pInst is called, if the AvipNotifyOkToSend callback is enabled.
  // AvipNotifyOkToSendCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipNotifyOkToSendCbF(denaliEnetTransaction trans);
  endfunction : AvipNotifyOkToSendCbF

  // ***************************************************************
  // AvipFlushAllBuffersCbF function
  // This function is called when the AvipFlushAllBuffersCbF function in pInst is called, if the AvipFlushAllBuffers callback is enabled.
  // AvipFlushAllBuffersCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipFlushAllBuffersCbF(denaliEnetTransaction trans);
  endfunction : AvipFlushAllBuffersCbF

  // ***************************************************************
  // AvipRegWriteDoneCbF function
  // This function is called when the AvipRegWriteDoneCbF function in pInst is called, if the AvipRegWriteDone callback is enabled.
  // AvipRegWriteDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipRegWriteDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipRegWriteDoneCbF

  // ***************************************************************
  // AvipRegReadDoneCbF function
  // This function is called when the AvipRegReadDoneCbF function in pInst is called, if the AvipRegReadDone callback is enabled.
  // AvipRegReadDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipRegReadDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipRegReadDoneCbF

  // ***************************************************************
  // AvipRegOpDoneCbF function
  // This function is called when the AvipRegOpDoneCbF function in pInst is called, if the AvipRegOpDone callback is enabled.
  // AvipRegOpDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipRegOpDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipRegOpDoneCbF

  // ***************************************************************
  // AvipMdioWriteDoneCbF function
  // This function is called when the AvipMdioWriteDoneCbF function in pInst is called, if the AvipMdioWriteDone callback is enabled.
  // AvipMdioWriteDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipMdioWriteDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipMdioWriteDoneCbF

  // ***************************************************************
  // AvipMdioReadDoneCbF function
  // This function is called when the AvipMdioReadDoneCbF function in pInst is called, if the AvipMdioReadDone callback is enabled.
  // AvipMdioReadDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipMdioReadDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipMdioReadDoneCbF

  // ***************************************************************
  // AvipMdioOpDoneCbF function
  // This function is called when the AvipMdioOpDoneCbF function in pInst is called, if the AvipMdioOpDone callback is enabled.
  // AvipMdioOpDoneCbF function description: Callback for AVIP use only.
  // ***************************************************************
  virtual function void AvipMdioOpDoneCbF(denaliEnetTransaction trans);
  endfunction : AvipMdioOpDoneCbF

  // ***************************************************************
  // CoverageSampleCbF function
  // This function is called when the CoverageSampleCbF function in pInst is called, if the CoverageSample callback is enabled.
  // CoverageSampleCbF function description: An internal callback for coverage collection this callback is only for internal use.
  // ***************************************************************
  virtual function void CoverageSampleCbF(denaliEnetTransaction trans);
  endfunction : CoverageSampleCbF


  // ***************************************************************
  //  DefaultCbPort Analysis port is written when the DefaultCbF function in pInst is called.
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) DefaultCbPort;

  // ***************************************************************
  // ErrorCbPort analysis port
  // This analysis port is written when the ErrorCbF function in pInst is called, if the Error callback is enabled.
  // ErrorCbF function description: A generic error has been detected. During this callback, Transaction field ErrorString stores character string that is a concatenation of all error messages associated with the transaction at the moment, field ErrorId holds the current error id, and field ErrorInfo holds the error severity. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) ErrorCbPort;

  // ***************************************************************
  // TxUserQueueExitPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitPktCbF function in pInst is called, if the TxUserQueueExitPkt callback is enabled.
  // TxUserQueueExitPktCbF function description: Callback when the Ethernet packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitPktCbPort;

  // ***************************************************************
  // TxPktStartedPktCbPort analysis port
  // This analysis port is written when the TxPktStartedPktCbF function in pInst is called, if the TxPktStartedPkt callback is enabled.
  // TxPktStartedPktCbF function description: Callback when the Ethernet packet transmission starts. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxPktStartedPktCbPort;

  // ***************************************************************
  // TxPktEndedPktCbPort analysis port
  // This analysis port is written when the TxPktEndedPktCbF function in pInst is called, if the TxPktEndedPkt callback is enabled.
  // TxPktEndedPktCbF function description: Callback when the Ethernet packet transmission has ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxPktEndedPktCbPort;

  // ***************************************************************
  // RxPktStartedPktCbPort analysis port
  // This analysis port is written when the RxPktStartedPktCbF function in pInst is called, if the RxPktStartedPkt callback is enabled.
  // RxPktStartedPktCbF function description: Callback when the Ethernet packet reception starts. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxPktStartedPktCbPort;

  // ***************************************************************
  // RxPktEndedPktCbPort analysis port
  // This analysis port is written when the RxPktEndedPktCbF function in pInst is called, if the RxPktEndedPkt callback is enabled.
  // RxPktEndedPktCbF function description: Callback when the Ethernet packet reception has ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxPktEndedPktCbPort;

  // ***************************************************************
  // TxUserQueueExitMgmtPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitMgmtPktCbF function in pInst is called, if the TxUserQueueExitMgmtPkt callback is enabled.
  // TxUserQueueExitMgmtPktCbF function description: Callback when the Management packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitMgmtPktCbPort;

  // ***************************************************************
  // TxPktStartedMgmtPktCbPort analysis port
  // This analysis port is written when the TxPktStartedMgmtPktCbF function in pInst is called, if the TxPktStartedMgmtPkt callback is enabled.
  // TxPktStartedMgmtPktCbF function description: Callback when the Management packet transmission starts. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxPktStartedMgmtPktCbPort;

  // ***************************************************************
  // TxPktEndedMgmtPktCbPort analysis port
  // This analysis port is written when the TxPktEndedMgmtPktCbF function in pInst is called, if the TxPktEndedMgmtPkt callback is enabled.
  // TxPktEndedMgmtPktCbF function description: Callback when the Management packet transmission has ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxPktEndedMgmtPktCbPort;

  // ***************************************************************
  // RxPktEndedMgmtPktCbPort analysis port
  // This analysis port is written when the RxPktEndedMgmtPktCbF function in pInst is called, if the RxPktEndedMgmtPkt callback is enabled.
  // RxPktEndedMgmtPktCbF function description: Callback when the Management packet reception has ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxPktEndedMgmtPktCbPort;

  // ***************************************************************
  // TxUserQueueExitTransportPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitTransportPktCbF function in pInst is called, if the TxUserQueueExitTransportPkt callback is enabled.
  // TxUserQueueExitTransportPktCbF function description: Callback when the Transport packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitTransportPktCbPort;

  // ***************************************************************
  // TxUserQueueExitNetworkPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitNetworkPktCbF function in pInst is called, if the TxUserQueueExitNetworkPkt callback is enabled.
  // TxUserQueueExitNetworkPktCbF function description: Callback when the Network packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitNetworkPktCbPort;

  // ***************************************************************
  // TxUserQueueExitMplsPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitMplsPktCbF function in pInst is called, if the TxUserQueueExitMplsPkt callback is enabled.
  // TxUserQueueExitMplsPktCbF function description: Callback when the Mpls packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitMplsPktCbPort;

  // ***************************************************************
  // TxUserQueueExitSnapPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitSnapPktCbF function in pInst is called, if the TxUserQueueExitSnapPkt callback is enabled.
  // TxUserQueueExitSnapPktCbF function description: Callback when the Snap packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitSnapPktCbPort;

  // ***************************************************************
  // TxUserQueueExitPtpPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitPtpPktCbF function in pInst is called, if the TxUserQueueExitPtpPkt callback is enabled.
  // TxUserQueueExitPtpPktCbF function description: Callback when the Ptp packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitPtpPktCbPort;

  // ***************************************************************
  // TxUserQueueExitFcoePktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitFcoePktCbF function in pInst is called, if the TxUserQueueExitFcoePkt callback is enabled.
  // TxUserQueueExitFcoePktCbF function description: Callback when the Fcoe packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitFcoePktCbPort;

  // ***************************************************************
  // TxUserQueueExitFcPktCbPort analysis port
  // This analysis port is written when the TxUserQueueExitFcPktCbF function in pInst is called, if the TxUserQueueExitFcPkt callback is enabled.
  // TxUserQueueExitFcPktCbF function description: Callback when the Fc packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxUserQueueExitFcPktCbPort;

  // ***************************************************************
  // RxNetworkPktEndedPktCbPort analysis port
  // This analysis port is written when the RxNetworkPktEndedPktCbF function in pInst is called, if the RxNetworkPktEndedPkt callback is enabled.
  // RxNetworkPktEndedPktCbF function description: Callback when the Network layer Info is extracted in a received Upper Layer packet, Network fields are available using this Callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxNetworkPktEndedPktCbPort;

  // ***************************************************************
  // RxTransportPktEndedPktCbPort analysis port
  // This analysis port is written when the RxTransportPktEndedPktCbF function in pInst is called, if the RxTransportPktEndedPkt callback is enabled.
  // RxTransportPktEndedPktCbF function description: Callback when the Transport layer info is extracted in a received Upper Layer packet, Transport fields are available using this Callback 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxTransportPktEndedPktCbPort;

  // ***************************************************************
  // RxMplsPktEndedPktCbPort analysis port
  // This analysis port is written when the RxMplsPktEndedPktCbF function in pInst is called, if the RxMplsPktEndedPkt callback is enabled.
  // RxMplsPktEndedPktCbF function description: Callback when Mpls stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_MPLS is detected. Mpls fields are availble using this Callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxMplsPktEndedPktCbPort;

  // ***************************************************************
  // RxSnapPktEndedPktCbPort analysis port
  // This analysis port is written when the RxSnapPktEndedPktCbF function in pInst is called, if the RxSnapPktEndedPkt callback is enabled.
  // RxSnapPktEndedPktCbF function description: Callback when the Snap stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_SNAP is detected. Snap fields are available using this Callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxSnapPktEndedPktCbPort;

  // ***************************************************************
  // RxPtpPktEndedPktCbPort analysis port
  // This analysis port is written when the RxPtpPktEndedPktCbF function in pInst is called, if the RxPtpPktEndedPkt callback is enabled.
  // RxPtpPktEndedPktCbF function description: Callback when the Ptp packet is found while extraction, Ptp fields are available using this Callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxPtpPktEndedPktCbPort;

  // ***************************************************************
  // ResetAssertedCbPort analysis port
  // This analysis port is written when the ResetAssertedCbF function in pInst is called, if the ResetAsserted callback is enabled.
  // ResetAssertedCbF function description: Callback when Reset is Asserted. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) ResetAssertedCbPort;

  // ***************************************************************
  // ResetDeassertedCbPort analysis port
  // This analysis port is written when the ResetDeassertedCbF function in pInst is called, if the ResetDeasserted callback is enabled.
  // ResetDeassertedCbF function description: Callback when Reset is Deasserted. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) ResetDeassertedCbPort;

  // ***************************************************************
  // AlignStatusUpCbPort analysis port
  // This analysis port is written when the AlignStatusUpCbF function in pInst is called, if the AlignStatusUp callback is enabled.
  // AlignStatusUpCbF function description: Callback when Alignment is Up. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AlignStatusUpCbPort;

  // ***************************************************************
  // AlignStatusDownCbPort analysis port
  // This analysis port is written when the AlignStatusDownCbF function in pInst is called, if the AlignStatusDown callback is enabled.
  // AlignStatusDownCbF function description: Callback when Alignment is Down. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AlignStatusDownCbPort;

  // ***************************************************************
  // BlockLockUpCbPort analysis port
  // This analysis port is written when the BlockLockUpCbF function in pInst is called, if the BlockLockUp callback is enabled.
  // BlockLockUpCbF function description: Callback when Block Lock is Up. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) BlockLockUpCbPort;

  // ***************************************************************
  // BlockLockDownCbPort analysis port
  // This analysis port is written when the BlockLockDownCbF function in pInst is called, if the BlockLockDown callback is enabled.
  // BlockLockDownCbF function description: Callback when Block Lock is Down. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) BlockLockDownCbPort;

  // ***************************************************************
  // LocalFaultEndedCbPort analysis port
  // This analysis port is written when the LocalFaultEndedCbF function in pInst is called, if the LocalFaultEnded callback is enabled.
  // LocalFaultEndedCbF function description: Callback when Local Fault Ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) LocalFaultEndedCbPort;

  // ***************************************************************
  // RemoteFaultEndedCbPort analysis port
  // This analysis port is written when the RemoteFaultEndedCbF function in pInst is called, if the RemoteFaultEnded callback is enabled.
  // RemoteFaultEndedCbF function description: Callback when Remote Fault Ended. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RemoteFaultEndedCbPort;

  // ***************************************************************
  // TrainingFrameTransmittedCbPort analysis port
  // This analysis port is written when the TrainingFrameTransmittedCbF function in pInst is called, if the TrainingFrameTransmitted callback is enabled.
  // TrainingFrameTransmittedCbF function description: Callback when a Training Frame is transmitted. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TrainingFrameTransmittedCbPort;

  // ***************************************************************
  // TrainingFrameReceivedCbPort analysis port
  // This analysis port is written when the TrainingFrameReceivedCbF function in pInst is called, if the TrainingFrameReceived callback is enabled.
  // TrainingFrameReceivedCbF function description: Callback when a Training Frame is received. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TrainingFrameReceivedCbPort;

  // ***************************************************************
  // Cl37ANStateChangedCbPort analysis port
  // This analysis port is written when the Cl37ANStateChangedCbF function in pInst is called, if the Cl37ANStateChanged callback is enabled.
  // Cl37ANStateChangedCbF function description: Callback when Cl37 State changed. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl37ANStateChangedCbPort;

  // ***************************************************************
  // TengkrPmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the TengkrPmdLinkTrainingStateChangedCbF function in pInst is called, if the TengkrPmdLinkTrainingStateChanged callback is enabled.
  // TengkrPmdLinkTrainingStateChangedCbF function description: Callback when TENGKR PMD Link Training FSM's state changes. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TengkrPmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane0PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane0PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-0. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane0PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane1PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane1PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-1. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane1PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane2PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane2PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-2. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane2PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane3PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane3PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-3. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane3PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane4PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane4PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-4. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane4PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane5PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane5PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-5. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane5PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane6PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane6PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-6. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane6PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane7PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane7PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-7. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane7PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane8PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane8PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-8. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane8PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cg100gbaserLane9PmdLinkTrainingStateChangedCbPort analysis port
  // This analysis port is written when the Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane9PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-9. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cg100gbaserLane9PmdLinkTrainingStateChangedCbPort;

  // ***************************************************************
  // Cl73ArbitrationStateChangedCbPort analysis port
  // This analysis port is written when the Cl73ArbitrationStateChangedCbF function in pInst is called, if the Cl73ArbitrationStateChanged callback is enabled.
  // Cl73ArbitrationStateChangedCbF function description: Callback when Cl73 Arbitration State changed. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl73ArbitrationStateChangedCbPort;

  // ***************************************************************
  // SyncStatusUpCbPort analysis port
  // This analysis port is written when the SyncStatusUpCbF function in pInst is called, if the SyncStatusUp callback is enabled.
  // SyncStatusUpCbF function description: Callback when Cl36 PCS Code Group Synchronization is achieved. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) SyncStatusUpCbPort;

  // ***************************************************************
  // SyncStatusDownCbPort analysis port
  // This analysis port is written when the SyncStatusDownCbF function in pInst is called, if the SyncStatusDown callback is enabled.
  // SyncStatusDownCbF function description: Callback when Cl36 PCS Code Group Synchronization is lost. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) SyncStatusDownCbPort;

  // ***************************************************************
  // Cl73AnDmePageReadyToBeXmittedCbPort analysis port
  // This analysis port is written when the Cl73AnDmePageReadyToBeXmittedCbF function in pInst is called, if the Cl73AnDmePageReadyToBeXmitted callback is enabled.
  // Cl73AnDmePageReadyToBeXmittedCbF function description: Callback when a DME Page is ready to be transmitted by the Clause-73 AN FSM for Backplane Interfaces. For Error Injection, this page can now be modified using Cl73AnDmePageToBeXmittedLow(Lower 32-bits) and Cl73AnDmePageToBeXmittedHigh(Upper 17-bits) registers. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl73AnDmePageReadyToBeXmittedCbPort;

  // ***************************************************************
  // Cl73AnDmePageXmittedCbPort analysis port
  // This analysis port is written when the Cl73AnDmePageXmittedCbF function in pInst is called, if the Cl73AnDmePageXmitted callback is enabled.
  // Cl73AnDmePageXmittedCbF function description: Callback when a DME Page is transmitted by the Clause-73 AN FSM for Backplane Interfaces. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl73AnDmePageXmittedCbPort;

  // ***************************************************************
  // Cl73AnDmePageRcvdCbPort analysis port
  // This analysis port is written when the Cl73AnDmePageRcvdCbF function in pInst is called, if the Cl73AnDmePageRcvd callback is enabled.
  // Cl73AnDmePageRcvdCbF function description: Callback when a DME Page is received by the Clause-73 AN FSM for Backplane Interfaces. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl73AnDmePageRcvdCbPort;

  // ***************************************************************
  // Cl37AnConfigRegXmittedCbPort analysis port
  // This analysis port is written when the Cl37AnConfigRegXmittedCbF function in pInst is called, if the Cl37AnConfigRegXmitted callback is enabled.
  // Cl37AnConfigRegXmittedCbF function description: Callback when a ConfigReg is transmitted by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl37AnConfigRegXmittedCbPort;

  // ***************************************************************
  // Cl37AnConfigRegRcvdCbPort analysis port
  // This analysis port is written when the Cl37AnConfigRegRcvdCbF function in pInst is called, if the Cl37AnConfigRegRcvd callback is enabled.
  // Cl37AnConfigRegRcvdCbF function description: Callback when a ConfigReg is received by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) Cl37AnConfigRegRcvdCbPort;

  // ***************************************************************
  // EeeStateChangedCbPort analysis port
  // This analysis port is written when the EeeStateChangedCbF function in pInst is called, if the EeeStateChanged callback is enabled.
  // EeeStateChangedCbF function description: Callback when EEE QUIET STATE is started. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) EeeStateChangedCbPort;

  // ***************************************************************
  // LpiTxTqTimerDoneCbPort analysis port
  // This analysis port is written when the LpiTxTqTimerDoneCbF function in pInst is called, if the LpiTxTqTimerDone callback is enabled.
  // LpiTxTqTimerDoneCbF function description: Callback when Lpi Tx Tq timer is done. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) LpiTxTqTimerDoneCbPort;

  // ***************************************************************
  // TxPktRawDataBeforeTransmissionCbPort analysis port
  // This analysis port is written when the TxPktRawDataBeforeTransmissionCbF function in pInst is called, if the TxPktRawDataBeforeTransmission callback is enabled.
  // TxPktRawDataBeforeTransmissionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is packed before transmission and the packed raw data list can be modified by the User. This callback is fired after the TxUserQueueExitPkt callback and before TxPktStartedPkt callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) TxPktRawDataBeforeTransmissionCbPort;

  // ***************************************************************
  // RxPktRawDataAfterReceptionCbPort analysis port
  // This analysis port is written when the RxPktRawDataAfterReceptionCbF function in pInst is called, if the RxPktRawDataAfterReception callback is enabled.
  // RxPktRawDataAfterReceptionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is received through the interface and after reception, the packed raw data list can be modified by the User before the list is unpacked into an Ethernet packet. This callback is fired after the RxPktStartedPkt callback and before RxPktEndedPkt callback. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) RxPktRawDataAfterReceptionCbPort;

  // ***************************************************************
  // AvipNotifyOkToSendCbPort analysis port
  // This analysis port is written when the AvipNotifyOkToSendCbF function in pInst is called, if the AvipNotifyOkToSend callback is enabled.
  // AvipNotifyOkToSendCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipNotifyOkToSendCbPort;

  // ***************************************************************
  // AvipFlushAllBuffersCbPort analysis port
  // This analysis port is written when the AvipFlushAllBuffersCbF function in pInst is called, if the AvipFlushAllBuffers callback is enabled.
  // AvipFlushAllBuffersCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipFlushAllBuffersCbPort;

  // ***************************************************************
  // AvipRegWriteDoneCbPort analysis port
  // This analysis port is written when the AvipRegWriteDoneCbF function in pInst is called, if the AvipRegWriteDone callback is enabled.
  // AvipRegWriteDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipRegWriteDoneCbPort;

  // ***************************************************************
  // AvipRegReadDoneCbPort analysis port
  // This analysis port is written when the AvipRegReadDoneCbF function in pInst is called, if the AvipRegReadDone callback is enabled.
  // AvipRegReadDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipRegReadDoneCbPort;

  // ***************************************************************
  // AvipRegOpDoneCbPort analysis port
  // This analysis port is written when the AvipRegOpDoneCbF function in pInst is called, if the AvipRegOpDone callback is enabled.
  // AvipRegOpDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipRegOpDoneCbPort;

  // ***************************************************************
  // AvipMdioWriteDoneCbPort analysis port
  // This analysis port is written when the AvipMdioWriteDoneCbF function in pInst is called, if the AvipMdioWriteDone callback is enabled.
  // AvipMdioWriteDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipMdioWriteDoneCbPort;

  // ***************************************************************
  // AvipMdioReadDoneCbPort analysis port
  // This analysis port is written when the AvipMdioReadDoneCbF function in pInst is called, if the AvipMdioReadDone callback is enabled.
  // AvipMdioReadDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipMdioReadDoneCbPort;

  // ***************************************************************
  // AvipMdioOpDoneCbPort analysis port
  // This analysis port is written when the AvipMdioOpDoneCbF function in pInst is called, if the AvipMdioOpDone callback is enabled.
  // AvipMdioOpDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) AvipMdioOpDoneCbPort;

  // ***************************************************************
  // CoverageSampleCbPort analysis port
  // This analysis port is written when the CoverageSampleCbF function in pInst is called, if the CoverageSample callback is enabled.
  // CoverageSampleCbF function description: An internal callback for coverage collection this callback is only for internal use. 
  // ***************************************************************
  uvm_analysis_port #(denaliEnetTransaction) CoverageSampleCbPort;


  // ***************************************************************
  // UVM event DefaultCbEvent is triggered when the DefaultCbF function in pInst is called
  // ***************************************************************
  uvm_event DefaultCbEvent;
   
  // ***************************************************************
  // UVM event ErrorCbEvent
  // This event is triggered when the ErrorCbF function in pInst is called, if the Error callback is enabled.
  // ErrorCbF function description: A generic error has been detected. During this callback, Transaction field ErrorString stores character string that is a concatenation of all error messages associated with the transaction at the moment, field ErrorId holds the current error id, and field ErrorInfo holds the error severity. 
  // ***************************************************************
  uvm_event ErrorCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitPktCbEvent
  // This event is triggered when the TxUserQueueExitPktCbF function in pInst is called, if the TxUserQueueExitPkt callback is enabled.
  // TxUserQueueExitPktCbF function description: Callback when the Ethernet packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitPktCbEvent;
   
  // ***************************************************************
  // UVM event TxPktStartedPktCbEvent
  // This event is triggered when the TxPktStartedPktCbF function in pInst is called, if the TxPktStartedPkt callback is enabled.
  // TxPktStartedPktCbF function description: Callback when the Ethernet packet transmission starts. 
  // ***************************************************************
  uvm_event TxPktStartedPktCbEvent;
   
  // ***************************************************************
  // UVM event TxPktEndedPktCbEvent
  // This event is triggered when the TxPktEndedPktCbF function in pInst is called, if the TxPktEndedPkt callback is enabled.
  // TxPktEndedPktCbF function description: Callback when the Ethernet packet transmission has ended. 
  // ***************************************************************
  uvm_event TxPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxPktStartedPktCbEvent
  // This event is triggered when the RxPktStartedPktCbF function in pInst is called, if the RxPktStartedPkt callback is enabled.
  // RxPktStartedPktCbF function description: Callback when the Ethernet packet reception starts. 
  // ***************************************************************
  uvm_event RxPktStartedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxPktEndedPktCbEvent
  // This event is triggered when the RxPktEndedPktCbF function in pInst is called, if the RxPktEndedPkt callback is enabled.
  // RxPktEndedPktCbF function description: Callback when the Ethernet packet reception has ended. 
  // ***************************************************************
  uvm_event RxPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitMgmtPktCbEvent
  // This event is triggered when the TxUserQueueExitMgmtPktCbF function in pInst is called, if the TxUserQueueExitMgmtPkt callback is enabled.
  // TxUserQueueExitMgmtPktCbF function description: Callback when the Management packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitMgmtPktCbEvent;
   
  // ***************************************************************
  // UVM event TxPktStartedMgmtPktCbEvent
  // This event is triggered when the TxPktStartedMgmtPktCbF function in pInst is called, if the TxPktStartedMgmtPkt callback is enabled.
  // TxPktStartedMgmtPktCbF function description: Callback when the Management packet transmission starts. 
  // ***************************************************************
  uvm_event TxPktStartedMgmtPktCbEvent;
   
  // ***************************************************************
  // UVM event TxPktEndedMgmtPktCbEvent
  // This event is triggered when the TxPktEndedMgmtPktCbF function in pInst is called, if the TxPktEndedMgmtPkt callback is enabled.
  // TxPktEndedMgmtPktCbF function description: Callback when the Management packet transmission has ended. 
  // ***************************************************************
  uvm_event TxPktEndedMgmtPktCbEvent;
   
  // ***************************************************************
  // UVM event RxPktEndedMgmtPktCbEvent
  // This event is triggered when the RxPktEndedMgmtPktCbF function in pInst is called, if the RxPktEndedMgmtPkt callback is enabled.
  // RxPktEndedMgmtPktCbF function description: Callback when the Management packet reception has ended. 
  // ***************************************************************
  uvm_event RxPktEndedMgmtPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitTransportPktCbEvent
  // This event is triggered when the TxUserQueueExitTransportPktCbF function in pInst is called, if the TxUserQueueExitTransportPkt callback is enabled.
  // TxUserQueueExitTransportPktCbF function description: Callback when the Transport packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitTransportPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitNetworkPktCbEvent
  // This event is triggered when the TxUserQueueExitNetworkPktCbF function in pInst is called, if the TxUserQueueExitNetworkPkt callback is enabled.
  // TxUserQueueExitNetworkPktCbF function description: Callback when the Network packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitNetworkPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitMplsPktCbEvent
  // This event is triggered when the TxUserQueueExitMplsPktCbF function in pInst is called, if the TxUserQueueExitMplsPkt callback is enabled.
  // TxUserQueueExitMplsPktCbF function description: Callback when the Mpls packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitMplsPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitSnapPktCbEvent
  // This event is triggered when the TxUserQueueExitSnapPktCbF function in pInst is called, if the TxUserQueueExitSnapPkt callback is enabled.
  // TxUserQueueExitSnapPktCbF function description: Callback when the Snap packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitSnapPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitPtpPktCbEvent
  // This event is triggered when the TxUserQueueExitPtpPktCbF function in pInst is called, if the TxUserQueueExitPtpPkt callback is enabled.
  // TxUserQueueExitPtpPktCbF function description: Callback when the Ptp packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitPtpPktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitFcoePktCbEvent
  // This event is triggered when the TxUserQueueExitFcoePktCbF function in pInst is called, if the TxUserQueueExitFcoePkt callback is enabled.
  // TxUserQueueExitFcoePktCbF function description: Callback when the Fcoe packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitFcoePktCbEvent;
   
  // ***************************************************************
  // UVM event TxUserQueueExitFcPktCbEvent
  // This event is triggered when the TxUserQueueExitFcPktCbF function in pInst is called, if the TxUserQueueExitFcPkt callback is enabled.
  // TxUserQueueExitFcPktCbF function description: Callback when the Fc packet has exited from the Queue, and now the packet can be modified by the User. 
  // ***************************************************************
  uvm_event TxUserQueueExitFcPktCbEvent;
   
  // ***************************************************************
  // UVM event RxNetworkPktEndedPktCbEvent
  // This event is triggered when the RxNetworkPktEndedPktCbF function in pInst is called, if the RxNetworkPktEndedPkt callback is enabled.
  // RxNetworkPktEndedPktCbF function description: Callback when the Network layer Info is extracted in a received Upper Layer packet, Network fields are available using this Callback. 
  // ***************************************************************
  uvm_event RxNetworkPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxTransportPktEndedPktCbEvent
  // This event is triggered when the RxTransportPktEndedPktCbF function in pInst is called, if the RxTransportPktEndedPkt callback is enabled.
  // RxTransportPktEndedPktCbF function description: Callback when the Transport layer info is extracted in a received Upper Layer packet, Transport fields are available using this Callback 
  // ***************************************************************
  uvm_event RxTransportPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxMplsPktEndedPktCbEvent
  // This event is triggered when the RxMplsPktEndedPktCbF function in pInst is called, if the RxMplsPktEndedPkt callback is enabled.
  // RxMplsPktEndedPktCbF function description: Callback when Mpls stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_MPLS is detected. Mpls fields are availble using this Callback. 
  // ***************************************************************
  uvm_event RxMplsPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxSnapPktEndedPktCbEvent
  // This event is triggered when the RxSnapPktEndedPktCbF function in pInst is called, if the RxSnapPktEndedPkt callback is enabled.
  // RxSnapPktEndedPktCbF function description: Callback when the Snap stage is completed while extraction of received Upper Layer packet. Callback triggers even if NO_SNAP is detected. Snap fields are available using this Callback. 
  // ***************************************************************
  uvm_event RxSnapPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event RxPtpPktEndedPktCbEvent
  // This event is triggered when the RxPtpPktEndedPktCbF function in pInst is called, if the RxPtpPktEndedPkt callback is enabled.
  // RxPtpPktEndedPktCbF function description: Callback when the Ptp packet is found while extraction, Ptp fields are available using this Callback. 
  // ***************************************************************
  uvm_event RxPtpPktEndedPktCbEvent;
   
  // ***************************************************************
  // UVM event ResetAssertedCbEvent
  // This event is triggered when the ResetAssertedCbF function in pInst is called, if the ResetAsserted callback is enabled.
  // ResetAssertedCbF function description: Callback when Reset is Asserted. 
  // ***************************************************************
  uvm_event ResetAssertedCbEvent;
   
  // ***************************************************************
  // UVM event ResetDeassertedCbEvent
  // This event is triggered when the ResetDeassertedCbF function in pInst is called, if the ResetDeasserted callback is enabled.
  // ResetDeassertedCbF function description: Callback when Reset is Deasserted. 
  // ***************************************************************
  uvm_event ResetDeassertedCbEvent;
   
  // ***************************************************************
  // UVM event AlignStatusUpCbEvent
  // This event is triggered when the AlignStatusUpCbF function in pInst is called, if the AlignStatusUp callback is enabled.
  // AlignStatusUpCbF function description: Callback when Alignment is Up. 
  // ***************************************************************
  uvm_event AlignStatusUpCbEvent;
   
  // ***************************************************************
  // UVM event AlignStatusDownCbEvent
  // This event is triggered when the AlignStatusDownCbF function in pInst is called, if the AlignStatusDown callback is enabled.
  // AlignStatusDownCbF function description: Callback when Alignment is Down. 
  // ***************************************************************
  uvm_event AlignStatusDownCbEvent;
   
  // ***************************************************************
  // UVM event BlockLockUpCbEvent
  // This event is triggered when the BlockLockUpCbF function in pInst is called, if the BlockLockUp callback is enabled.
  // BlockLockUpCbF function description: Callback when Block Lock is Up. 
  // ***************************************************************
  uvm_event BlockLockUpCbEvent;
   
  // ***************************************************************
  // UVM event BlockLockDownCbEvent
  // This event is triggered when the BlockLockDownCbF function in pInst is called, if the BlockLockDown callback is enabled.
  // BlockLockDownCbF function description: Callback when Block Lock is Down. 
  // ***************************************************************
  uvm_event BlockLockDownCbEvent;
   
  // ***************************************************************
  // UVM event LocalFaultEndedCbEvent
  // This event is triggered when the LocalFaultEndedCbF function in pInst is called, if the LocalFaultEnded callback is enabled.
  // LocalFaultEndedCbF function description: Callback when Local Fault Ended. 
  // ***************************************************************
  uvm_event LocalFaultEndedCbEvent;
   
  // ***************************************************************
  // UVM event RemoteFaultEndedCbEvent
  // This event is triggered when the RemoteFaultEndedCbF function in pInst is called, if the RemoteFaultEnded callback is enabled.
  // RemoteFaultEndedCbF function description: Callback when Remote Fault Ended. 
  // ***************************************************************
  uvm_event RemoteFaultEndedCbEvent;
   
  // ***************************************************************
  // UVM event TrainingFrameTransmittedCbEvent
  // This event is triggered when the TrainingFrameTransmittedCbF function in pInst is called, if the TrainingFrameTransmitted callback is enabled.
  // TrainingFrameTransmittedCbF function description: Callback when a Training Frame is transmitted. 
  // ***************************************************************
  uvm_event TrainingFrameTransmittedCbEvent;
   
  // ***************************************************************
  // UVM event TrainingFrameReceivedCbEvent
  // This event is triggered when the TrainingFrameReceivedCbF function in pInst is called, if the TrainingFrameReceived callback is enabled.
  // TrainingFrameReceivedCbF function description: Callback when a Training Frame is received. 
  // ***************************************************************
  uvm_event TrainingFrameReceivedCbEvent;
   
  // ***************************************************************
  // UVM event Cl37ANStateChangedCbEvent
  // This event is triggered when the Cl37ANStateChangedCbF function in pInst is called, if the Cl37ANStateChanged callback is enabled.
  // Cl37ANStateChangedCbF function description: Callback when Cl37 State changed. 
  // ***************************************************************
  uvm_event Cl37ANStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event TengkrPmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the TengkrPmdLinkTrainingStateChangedCbF function in pInst is called, if the TengkrPmdLinkTrainingStateChanged callback is enabled.
  // TengkrPmdLinkTrainingStateChangedCbF function description: Callback when TENGKR PMD Link Training FSM's state changes. 
  // ***************************************************************
  uvm_event TengkrPmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane0PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane0PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane0PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-0. 
  // ***************************************************************
  uvm_event Cg100gbaserLane0PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane1PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane1PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane1PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-1. 
  // ***************************************************************
  uvm_event Cg100gbaserLane1PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane2PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane2PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane2PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-2. 
  // ***************************************************************
  uvm_event Cg100gbaserLane2PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane3PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane3PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane3PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-3. 
  // ***************************************************************
  uvm_event Cg100gbaserLane3PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane4PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane4PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane4PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-4. 
  // ***************************************************************
  uvm_event Cg100gbaserLane4PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane5PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane5PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane5PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-5. 
  // ***************************************************************
  uvm_event Cg100gbaserLane5PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane6PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane6PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane6PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-6. 
  // ***************************************************************
  uvm_event Cg100gbaserLane6PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane7PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane7PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane7PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-7. 
  // ***************************************************************
  uvm_event Cg100gbaserLane7PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane8PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane8PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane8PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-8. 
  // ***************************************************************
  uvm_event Cg100gbaserLane8PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cg100gbaserLane9PmdLinkTrainingStateChangedCbEvent
  // This event is triggered when the Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function in pInst is called, if the Cg100gbaserLane9PmdLinkTrainingStateChanged callback is enabled.
  // Cg100gbaserLane9PmdLinkTrainingStateChangedCbF function description: Callback when CG_100GBASER PMD Link Training FSM's state changes for Lane-9. 
  // ***************************************************************
  uvm_event Cg100gbaserLane9PmdLinkTrainingStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event Cl73ArbitrationStateChangedCbEvent
  // This event is triggered when the Cl73ArbitrationStateChangedCbF function in pInst is called, if the Cl73ArbitrationStateChanged callback is enabled.
  // Cl73ArbitrationStateChangedCbF function description: Callback when Cl73 Arbitration State changed. 
  // ***************************************************************
  uvm_event Cl73ArbitrationStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event SyncStatusUpCbEvent
  // This event is triggered when the SyncStatusUpCbF function in pInst is called, if the SyncStatusUp callback is enabled.
  // SyncStatusUpCbF function description: Callback when Cl36 PCS Code Group Synchronization is achieved. 
  // ***************************************************************
  uvm_event SyncStatusUpCbEvent;
   
  // ***************************************************************
  // UVM event SyncStatusDownCbEvent
  // This event is triggered when the SyncStatusDownCbF function in pInst is called, if the SyncStatusDown callback is enabled.
  // SyncStatusDownCbF function description: Callback when Cl36 PCS Code Group Synchronization is lost. 
  // ***************************************************************
  uvm_event SyncStatusDownCbEvent;
   
  // ***************************************************************
  // UVM event Cl73AnDmePageReadyToBeXmittedCbEvent
  // This event is triggered when the Cl73AnDmePageReadyToBeXmittedCbF function in pInst is called, if the Cl73AnDmePageReadyToBeXmitted callback is enabled.
  // Cl73AnDmePageReadyToBeXmittedCbF function description: Callback when a DME Page is ready to be transmitted by the Clause-73 AN FSM for Backplane Interfaces. For Error Injection, this page can now be modified using Cl73AnDmePageToBeXmittedLow(Lower 32-bits) and Cl73AnDmePageToBeXmittedHigh(Upper 17-bits) registers. 
  // ***************************************************************
  uvm_event Cl73AnDmePageReadyToBeXmittedCbEvent;
   
  // ***************************************************************
  // UVM event Cl73AnDmePageXmittedCbEvent
  // This event is triggered when the Cl73AnDmePageXmittedCbF function in pInst is called, if the Cl73AnDmePageXmitted callback is enabled.
  // Cl73AnDmePageXmittedCbF function description: Callback when a DME Page is transmitted by the Clause-73 AN FSM for Backplane Interfaces. 
  // ***************************************************************
  uvm_event Cl73AnDmePageXmittedCbEvent;
   
  // ***************************************************************
  // UVM event Cl73AnDmePageRcvdCbEvent
  // This event is triggered when the Cl73AnDmePageRcvdCbF function in pInst is called, if the Cl73AnDmePageRcvd callback is enabled.
  // Cl73AnDmePageRcvdCbF function description: Callback when a DME Page is received by the Clause-73 AN FSM for Backplane Interfaces. 
  // ***************************************************************
  uvm_event Cl73AnDmePageRcvdCbEvent;
   
  // ***************************************************************
  // UVM event Cl37AnConfigRegXmittedCbEvent
  // This event is triggered when the Cl37AnConfigRegXmittedCbF function in pInst is called, if the Cl37AnConfigRegXmitted callback is enabled.
  // Cl37AnConfigRegXmittedCbF function description: Callback when a ConfigReg is transmitted by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX. 
  // ***************************************************************
  uvm_event Cl37AnConfigRegXmittedCbEvent;
   
  // ***************************************************************
  // UVM event Cl37AnConfigRegRcvdCbEvent
  // This event is triggered when the Cl37AnConfigRegRcvdCbF function in pInst is called, if the Cl37AnConfigRegRcvd callback is enabled.
  // Cl37AnConfigRegRcvdCbF function description: Callback when a ConfigReg is received by the Clause-37 AN FSM for Interfaces TBI,RTBI,SGMII,QSGMII,ONEGKX. 
  // ***************************************************************
  uvm_event Cl37AnConfigRegRcvdCbEvent;
   
  // ***************************************************************
  // UVM event EeeStateChangedCbEvent
  // This event is triggered when the EeeStateChangedCbF function in pInst is called, if the EeeStateChanged callback is enabled.
  // EeeStateChangedCbF function description: Callback when EEE QUIET STATE is started. 
  // ***************************************************************
  uvm_event EeeStateChangedCbEvent;
   
  // ***************************************************************
  // UVM event LpiTxTqTimerDoneCbEvent
  // This event is triggered when the LpiTxTqTimerDoneCbF function in pInst is called, if the LpiTxTqTimerDone callback is enabled.
  // LpiTxTqTimerDoneCbF function description: Callback when Lpi Tx Tq timer is done. 
  // ***************************************************************
  uvm_event LpiTxTqTimerDoneCbEvent;
   
  // ***************************************************************
  // UVM event TxPktRawDataBeforeTransmissionCbEvent
  // This event is triggered when the TxPktRawDataBeforeTransmissionCbF function in pInst is called, if the TxPktRawDataBeforeTransmission callback is enabled.
  // TxPktRawDataBeforeTransmissionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is packed before transmission and the packed raw data list can be modified by the User. This callback is fired after the TxUserQueueExitPkt callback and before TxPktStartedPkt callback. 
  // ***************************************************************
  uvm_event TxPktRawDataBeforeTransmissionCbEvent;
   
  // ***************************************************************
  // UVM event RxPktRawDataAfterReceptionCbEvent
  // This event is triggered when the RxPktRawDataAfterReceptionCbF function in pInst is called, if the RxPktRawDataAfterReception callback is enabled.
  // RxPktRawDataAfterReceptionCbF function description: This callback can only be used when AccessEthPackedArray register is written to 1. Callback when Ethernet packet is received through the interface and after reception, the packed raw data list can be modified by the User before the list is unpacked into an Ethernet packet. This callback is fired after the RxPktStartedPkt callback and before RxPktEndedPkt callback. 
  // ***************************************************************
  uvm_event RxPktRawDataAfterReceptionCbEvent;
   
  // ***************************************************************
  // UVM event AvipNotifyOkToSendCbEvent
  // This event is triggered when the AvipNotifyOkToSendCbF function in pInst is called, if the AvipNotifyOkToSend callback is enabled.
  // AvipNotifyOkToSendCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipNotifyOkToSendCbEvent;
   
  // ***************************************************************
  // UVM event AvipFlushAllBuffersCbEvent
  // This event is triggered when the AvipFlushAllBuffersCbF function in pInst is called, if the AvipFlushAllBuffers callback is enabled.
  // AvipFlushAllBuffersCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipFlushAllBuffersCbEvent;
   
  // ***************************************************************
  // UVM event AvipRegWriteDoneCbEvent
  // This event is triggered when the AvipRegWriteDoneCbF function in pInst is called, if the AvipRegWriteDone callback is enabled.
  // AvipRegWriteDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipRegWriteDoneCbEvent;
   
  // ***************************************************************
  // UVM event AvipRegReadDoneCbEvent
  // This event is triggered when the AvipRegReadDoneCbF function in pInst is called, if the AvipRegReadDone callback is enabled.
  // AvipRegReadDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipRegReadDoneCbEvent;
   
  // ***************************************************************
  // UVM event AvipRegOpDoneCbEvent
  // This event is triggered when the AvipRegOpDoneCbF function in pInst is called, if the AvipRegOpDone callback is enabled.
  // AvipRegOpDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipRegOpDoneCbEvent;
   
  // ***************************************************************
  // UVM event AvipMdioWriteDoneCbEvent
  // This event is triggered when the AvipMdioWriteDoneCbF function in pInst is called, if the AvipMdioWriteDone callback is enabled.
  // AvipMdioWriteDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipMdioWriteDoneCbEvent;
   
  // ***************************************************************
  // UVM event AvipMdioReadDoneCbEvent
  // This event is triggered when the AvipMdioReadDoneCbF function in pInst is called, if the AvipMdioReadDone callback is enabled.
  // AvipMdioReadDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipMdioReadDoneCbEvent;
   
  // ***************************************************************
  // UVM event AvipMdioOpDoneCbEvent
  // This event is triggered when the AvipMdioOpDoneCbF function in pInst is called, if the AvipMdioOpDone callback is enabled.
  // AvipMdioOpDoneCbF function description: Callback for AVIP use only. 
  // ***************************************************************
  uvm_event AvipMdioOpDoneCbEvent;
   
  // ***************************************************************
  // UVM event CoverageSampleCbEvent
  // This event is triggered when the CoverageSampleCbF function in pInst is called, if the CoverageSample callback is enabled.
  // CoverageSampleCbF function description: An internal callback for coverage collection this callback is only for internal use. 
  // ***************************************************************
  uvm_event CoverageSampleCbEvent;

  
  // ***************************************************************
  // UVM Imp port ErrorImp: triggered when the ErrorCbPort is written.
  // ***************************************************************
  uvm_analysis_imp_enet_monitor_Error #(denaliEnetTransaction,cdnEnetUvmMonitor) ErrorImp;    


  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmMonitor", uvm_component parent = null);
    super.new(name, parent);
    
    DefaultCbPort = new("DefaultCbPort", this);
    ErrorCbPort = new("ErrorCbPort", this);
    TxUserQueueExitPktCbPort = new("TxUserQueueExitPktCbPort", this);
    TxPktStartedPktCbPort = new("TxPktStartedPktCbPort", this);
    TxPktEndedPktCbPort = new("TxPktEndedPktCbPort", this);
    RxPktStartedPktCbPort = new("RxPktStartedPktCbPort", this);
    RxPktEndedPktCbPort = new("RxPktEndedPktCbPort", this);
    TxUserQueueExitMgmtPktCbPort = new("TxUserQueueExitMgmtPktCbPort", this);
    TxPktStartedMgmtPktCbPort = new("TxPktStartedMgmtPktCbPort", this);
    TxPktEndedMgmtPktCbPort = new("TxPktEndedMgmtPktCbPort", this);
    RxPktEndedMgmtPktCbPort = new("RxPktEndedMgmtPktCbPort", this);
    TxUserQueueExitTransportPktCbPort = new("TxUserQueueExitTransportPktCbPort", this);
    TxUserQueueExitNetworkPktCbPort = new("TxUserQueueExitNetworkPktCbPort", this);
    TxUserQueueExitMplsPktCbPort = new("TxUserQueueExitMplsPktCbPort", this);
    TxUserQueueExitSnapPktCbPort = new("TxUserQueueExitSnapPktCbPort", this);
    TxUserQueueExitPtpPktCbPort = new("TxUserQueueExitPtpPktCbPort", this);
    TxUserQueueExitFcoePktCbPort = new("TxUserQueueExitFcoePktCbPort", this);
    TxUserQueueExitFcPktCbPort = new("TxUserQueueExitFcPktCbPort", this);
    RxNetworkPktEndedPktCbPort = new("RxNetworkPktEndedPktCbPort", this);
    RxTransportPktEndedPktCbPort = new("RxTransportPktEndedPktCbPort", this);
    RxMplsPktEndedPktCbPort = new("RxMplsPktEndedPktCbPort", this);
    RxSnapPktEndedPktCbPort = new("RxSnapPktEndedPktCbPort", this);
    RxPtpPktEndedPktCbPort = new("RxPtpPktEndedPktCbPort", this);
    ResetAssertedCbPort = new("ResetAssertedCbPort", this);
    ResetDeassertedCbPort = new("ResetDeassertedCbPort", this);
    AlignStatusUpCbPort = new("AlignStatusUpCbPort", this);
    AlignStatusDownCbPort = new("AlignStatusDownCbPort", this);
    BlockLockUpCbPort = new("BlockLockUpCbPort", this);
    BlockLockDownCbPort = new("BlockLockDownCbPort", this);
    LocalFaultEndedCbPort = new("LocalFaultEndedCbPort", this);
    RemoteFaultEndedCbPort = new("RemoteFaultEndedCbPort", this);
    TrainingFrameTransmittedCbPort = new("TrainingFrameTransmittedCbPort", this);
    TrainingFrameReceivedCbPort = new("TrainingFrameReceivedCbPort", this);
    Cl37ANStateChangedCbPort = new("Cl37ANStateChangedCbPort", this);
    TengkrPmdLinkTrainingStateChangedCbPort = new("TengkrPmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane0PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane0PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane1PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane1PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane2PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane2PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane3PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane3PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane4PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane4PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane5PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane5PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane6PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane6PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane7PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane7PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane8PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane8PmdLinkTrainingStateChangedCbPort", this);
    Cg100gbaserLane9PmdLinkTrainingStateChangedCbPort = new("Cg100gbaserLane9PmdLinkTrainingStateChangedCbPort", this);
    Cl73ArbitrationStateChangedCbPort = new("Cl73ArbitrationStateChangedCbPort", this);
    SyncStatusUpCbPort = new("SyncStatusUpCbPort", this);
    SyncStatusDownCbPort = new("SyncStatusDownCbPort", this);
    Cl73AnDmePageReadyToBeXmittedCbPort = new("Cl73AnDmePageReadyToBeXmittedCbPort", this);
    Cl73AnDmePageXmittedCbPort = new("Cl73AnDmePageXmittedCbPort", this);
    Cl73AnDmePageRcvdCbPort = new("Cl73AnDmePageRcvdCbPort", this);
    Cl37AnConfigRegXmittedCbPort = new("Cl37AnConfigRegXmittedCbPort", this);
    Cl37AnConfigRegRcvdCbPort = new("Cl37AnConfigRegRcvdCbPort", this);
    EeeStateChangedCbPort = new("EeeStateChangedCbPort", this);
    LpiTxTqTimerDoneCbPort = new("LpiTxTqTimerDoneCbPort", this);
    TxPktRawDataBeforeTransmissionCbPort = new("TxPktRawDataBeforeTransmissionCbPort", this);
    RxPktRawDataAfterReceptionCbPort = new("RxPktRawDataAfterReceptionCbPort", this);
    AvipNotifyOkToSendCbPort = new("AvipNotifyOkToSendCbPort", this);
    AvipFlushAllBuffersCbPort = new("AvipFlushAllBuffersCbPort", this);
    AvipRegWriteDoneCbPort = new("AvipRegWriteDoneCbPort", this);
    AvipRegReadDoneCbPort = new("AvipRegReadDoneCbPort", this);
    AvipRegOpDoneCbPort = new("AvipRegOpDoneCbPort", this);
    AvipMdioWriteDoneCbPort = new("AvipMdioWriteDoneCbPort", this);
    AvipMdioReadDoneCbPort = new("AvipMdioReadDoneCbPort", this);
    AvipMdioOpDoneCbPort = new("AvipMdioOpDoneCbPort", this);
    CoverageSampleCbPort = new("CoverageSampleCbPort", this);

    DefaultCbEvent = new("DefaultCbEvent");
    ErrorCbEvent = new("ErrorCbEvent");
    TxUserQueueExitPktCbEvent = new("TxUserQueueExitPktCbEvent");
    TxPktStartedPktCbEvent = new("TxPktStartedPktCbEvent");
    TxPktEndedPktCbEvent = new("TxPktEndedPktCbEvent");
    RxPktStartedPktCbEvent = new("RxPktStartedPktCbEvent");
    RxPktEndedPktCbEvent = new("RxPktEndedPktCbEvent");
    TxUserQueueExitMgmtPktCbEvent = new("TxUserQueueExitMgmtPktCbEvent");
    TxPktStartedMgmtPktCbEvent = new("TxPktStartedMgmtPktCbEvent");
    TxPktEndedMgmtPktCbEvent = new("TxPktEndedMgmtPktCbEvent");
    RxPktEndedMgmtPktCbEvent = new("RxPktEndedMgmtPktCbEvent");
    TxUserQueueExitTransportPktCbEvent = new("TxUserQueueExitTransportPktCbEvent");
    TxUserQueueExitNetworkPktCbEvent = new("TxUserQueueExitNetworkPktCbEvent");
    TxUserQueueExitMplsPktCbEvent = new("TxUserQueueExitMplsPktCbEvent");
    TxUserQueueExitSnapPktCbEvent = new("TxUserQueueExitSnapPktCbEvent");
    TxUserQueueExitPtpPktCbEvent = new("TxUserQueueExitPtpPktCbEvent");
    TxUserQueueExitFcoePktCbEvent = new("TxUserQueueExitFcoePktCbEvent");
    TxUserQueueExitFcPktCbEvent = new("TxUserQueueExitFcPktCbEvent");
    RxNetworkPktEndedPktCbEvent = new("RxNetworkPktEndedPktCbEvent");
    RxTransportPktEndedPktCbEvent = new("RxTransportPktEndedPktCbEvent");
    RxMplsPktEndedPktCbEvent = new("RxMplsPktEndedPktCbEvent");
    RxSnapPktEndedPktCbEvent = new("RxSnapPktEndedPktCbEvent");
    RxPtpPktEndedPktCbEvent = new("RxPtpPktEndedPktCbEvent");
    ResetAssertedCbEvent = new("ResetAssertedCbEvent");
    ResetDeassertedCbEvent = new("ResetDeassertedCbEvent");
    AlignStatusUpCbEvent = new("AlignStatusUpCbEvent");
    AlignStatusDownCbEvent = new("AlignStatusDownCbEvent");
    BlockLockUpCbEvent = new("BlockLockUpCbEvent");
    BlockLockDownCbEvent = new("BlockLockDownCbEvent");
    LocalFaultEndedCbEvent = new("LocalFaultEndedCbEvent");
    RemoteFaultEndedCbEvent = new("RemoteFaultEndedCbEvent");
    TrainingFrameTransmittedCbEvent = new("TrainingFrameTransmittedCbEvent");
    TrainingFrameReceivedCbEvent = new("TrainingFrameReceivedCbEvent");
    Cl37ANStateChangedCbEvent = new("Cl37ANStateChangedCbEvent");
    TengkrPmdLinkTrainingStateChangedCbEvent = new("TengkrPmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane0PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane0PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane1PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane1PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane2PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane2PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane3PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane3PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane4PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane4PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane5PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane5PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane6PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane6PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane7PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane7PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane8PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane8PmdLinkTrainingStateChangedCbEvent");
    Cg100gbaserLane9PmdLinkTrainingStateChangedCbEvent = new("Cg100gbaserLane9PmdLinkTrainingStateChangedCbEvent");
    Cl73ArbitrationStateChangedCbEvent = new("Cl73ArbitrationStateChangedCbEvent");
    SyncStatusUpCbEvent = new("SyncStatusUpCbEvent");
    SyncStatusDownCbEvent = new("SyncStatusDownCbEvent");
    Cl73AnDmePageReadyToBeXmittedCbEvent = new("Cl73AnDmePageReadyToBeXmittedCbEvent");
    Cl73AnDmePageXmittedCbEvent = new("Cl73AnDmePageXmittedCbEvent");
    Cl73AnDmePageRcvdCbEvent = new("Cl73AnDmePageRcvdCbEvent");
    Cl37AnConfigRegXmittedCbEvent = new("Cl37AnConfigRegXmittedCbEvent");
    Cl37AnConfigRegRcvdCbEvent = new("Cl37AnConfigRegRcvdCbEvent");
    EeeStateChangedCbEvent = new("EeeStateChangedCbEvent");
    LpiTxTqTimerDoneCbEvent = new("LpiTxTqTimerDoneCbEvent");
    TxPktRawDataBeforeTransmissionCbEvent = new("TxPktRawDataBeforeTransmissionCbEvent");
    RxPktRawDataAfterReceptionCbEvent = new("RxPktRawDataAfterReceptionCbEvent");
    AvipNotifyOkToSendCbEvent = new("AvipNotifyOkToSendCbEvent");
    AvipFlushAllBuffersCbEvent = new("AvipFlushAllBuffersCbEvent");
    AvipRegWriteDoneCbEvent = new("AvipRegWriteDoneCbEvent");
    AvipRegReadDoneCbEvent = new("AvipRegReadDoneCbEvent");
    AvipRegOpDoneCbEvent = new("AvipRegOpDoneCbEvent");
    AvipMdioWriteDoneCbEvent = new("AvipMdioWriteDoneCbEvent");
    AvipMdioReadDoneCbEvent = new("AvipMdioReadDoneCbEvent");
    AvipMdioOpDoneCbEvent = new("AvipMdioOpDoneCbEvent");
    CoverageSampleCbEvent = new("CoverageSampleCbEvent");
    ErrorImp = new("ErrorImp",this);

  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create coverage model
    if (coverageEnable == 1) begin
      set_config_object("coverModel", "pInst", pInst, 0);
      coverModel = cdnEnetUvmCoverage::type_id::create("coverModel", this);
      coverModel.pAgent = pAgent;
    end
  endfunction : build_phase

  // ***************************************************************
  // Method : end_of_elaboration/end_of_elaboration_phase.
  // Desc.  : Apply configuration settings in this phase.
  // ***************************************************************
  virtual function void end_of_elaboration_phase ( uvm_phase phase );
    super.end_of_elaboration_phase(phase);
    turnOffCoreErrorPrinting();

    // Enable the coverage callback
    if (coverageEnable == 1) begin
      pInst.create_cover();
    end
  endfunction : end_of_elaboration_phase
  
  // ***************************************************************
  // Method : turnOffCoreErrorPrinting
  // Desc. : Turn off core error printing.
  //         Errors will be printed in uvm layer wheen error callbacks is issued by core.
  // ***************************************************************        
  virtual function void turnOffCoreErrorPrinting();
    pAgent.regInst.writeReg(DENALI_ENET_REG_ErrCtrl, 32'b0000_0000_0000_0000_0000_0100_0000_0000);
  endfunction : turnOffCoreErrorPrinting  

  // ***************************************************************
  // Method : connect/connect_phase
  // Desc. : Connects the analysis ports to the instance.
  // ***************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ErrorCbPort.connect(this.ErrorImp);

    // Connect coverage model pointers and create coverage groups
    if (coverageEnable == 1) begin
      pInst.coverInst = coverModel;
    end    
  endfunction : connect_phase

  virtual function void write_enet_monitor_Error(denaliEnetTransaction trans);
    reportError(trans);
  endfunction : write_enet_monitor_Error

  virtual function void reportError(denaliEnetTransaction trans);
    case (trans.ErrorInfo & DENALI_ENET_Rmask__ErrCtrl_severity)
      integer'(DENALI_ENET_ERR_CONFIG_SEVERITY_Fatal) : begin
        `uvm_fatal(trans.ErrorId.name(), trans.ErrorString);
      end
      integer'(DENALI_ENET_ERR_CONFIG_SEVERITY_Error) : begin
        `uvm_error(trans.ErrorId.name(), trans.ErrorString);
      end
      integer'(DENALI_ENET_ERR_CONFIG_SEVERITY_Warn) : begin
        `uvm_warning(trans.ErrorId.name(), trans.ErrorString);
      end
      integer'(DENALI_ENET_ERR_CONFIG_SEVERITY_Info) : begin
        `uvm_info(trans.ErrorId.name(), trans.ErrorString, UVM_LOW);
      end
      default : begin
        `uvm_error(trans.ErrorId.name(), trans.ErrorString);
      end
    endcase
  endfunction : reportError


endclass : cdnEnetUvmMonitor

`endif // CDN_ENET_UVM_MONITOR_SV
