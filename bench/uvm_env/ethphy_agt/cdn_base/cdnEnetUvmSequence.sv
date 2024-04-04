
`ifndef CDN_ENET_UVM_SEQUENCE_SV
`define CDN_ENET_UVM_SEQUENCE_SV

// ***************************************************************
// class: cdnEnetUvmSequence
// A sequence is a stream of data items generated and sent to the DUT. 
// The sequence represents a scenario.
// ***************************************************************
class cdnEnetUvmSequence extends uvm_sequence#(denaliEnetTransaction,denaliEnetTransaction);

    
  // ***************************************************************
  // The response_queue will overflow if more responses are sent to this sequence
  // from the driver than get_response calls are made. 
  // By default, if the response_queue overflows, an error is reported.
  // Setting value to 1 disables these errors. Setting it to 0 enables them.
  // ***************************************************************
  bit responseQueueErrorReportDisabled = 1;
  
  `uvm_object_utils_begin(cdnEnetUvmSequence)
    `uvm_field_int(responseQueueErrorReportDisabled, UVM_ALL_ON)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(cdnEnetUvmSequencer)


  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmSequence");
    super.new(name);
    set_response_queue_error_report_disabled(responseQueueErrorReportDisabled);
  endfunction : new

endclass : cdnEnetUvmSequence

typedef class cdnEnetUvmSequence;
typedef class cdnEnetUvmModifyTransactionSequence;

// ***************************************************************
// Class: cdnEnetUvmDriverCb
// This class is been triggered when a relevant transaction can be modified before it's been sent. 
// ***************************************************************
class cdnEnetUvmDriverCb extends uvm_callback;

  
  cdnEnetUvmSequencer p_sequencer;
  
  // ***************************************************************
  // The sequence associated with this callback.
  // When the callback is triggered, the sequences modifyTransaction function will be called for the relevant transactions.
  // ***************************************************************
  cdnEnetUvmModifyTransactionSequence seq; 
  
  // ***************************************************************
  // Determines if the associated sequence's modifyTransaction function will be called for all transactions or only the ones that hold the same sequence id.
  // Default is not to affect transactions from other sequences.
  // ***************************************************************
  bit affectOtherSequences = 0;

  // ***************************************************************
  // Calls seq.modifyTransaction for the appropriate transactions.
  // ***************************************************************
  virtual function void transExecuted( cdnEnetUvmDriver driver, denaliEnetTransaction tr);
    if (affectOtherSequences == 0 && tr.get_sequence_id() != seq.get_sequence_id())
      return; 
    seq.modifyTransaction(tr);
  endfunction

  function new(string name="cdnEnetUvmDriverCb");
    super.new(name);
  endfunction

endclass

typedef uvm_callbacks #(cdnEnetUvmDriver,cdnEnetUvmDriverCb) cdnEnetUvmDriverCbsT;

// ***************************************************************
// Class: cdnEnetUvmModifyTransactionSequence 
// This sequence enables you to modify transaction that is already in process. It is very useful specially
// for error injection and responses modification. The cdnEnetUvmModifyTransactionSequence encapsulates the logic of the scenario and the
// logic of the modification in one class. The scenario logic is available in the sequence body() task.
// The modification logic is available in the sequence modifyTransaction function.
// ***************************************************************
class cdnEnetUvmModifyTransactionSequence extends cdnEnetUvmSequence;

  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_object_utils(cdnEnetUvmModifyTransactionSequence)
  `uvm_declare_p_sequencer(cdnEnetUvmSequencer)

  // ***************************************************************
  // The pointer to the associated callback
  // ***************************************************************
  cdnEnetUvmDriverCb cb;
  
  // ***************************************************************
  // Enables setting of the model callbacks automatically
  // When this field is set to '0' the model will not call the relevant transaction callback automatically and the associated UVM Callback will not be triggered
  // Default value for this field is '1'
  // ***************************************************************
  integer enableSetInstanceCallbacks = 1;
  
  // ***************************************************************
  // When set ot '1' this field enables the seuqence to be registered for the relevant model callbacks
  // and enables modifying transaction that is already in process
  // Default value for this field is '1'
  // ***************************************************************
  integer enableRegisterDriverCallback = 1;

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmModifyTransactionSequence");
    super.new(name);        
  endfunction : new

  // ***************************************************************
  // Set the relevant model callback that in turn trigger the sequence associated UVM callback
  // ***************************************************************
  virtual function void setInstanceCallbacks();    
    void'(p_sequencer.pAgent.inst.setCallback(DENALI_ENET_CB_TxUserQueueExitPkt));
    void'(p_sequencer.pAgent.inst.setCallback(DENALI_ENET_CB_TxUserQueueExitMgmtPkt));
  endfunction

  // ***************************************************************
  // This function registers the sequence associated callback to the driver. When the relevant model callbacks occur the cb will be invoked.
  // This function can be called from any place in the sequence, by default its called from the pre_start task, in this case it means
  // that the transaction modification is enabled before the sequencer requested an item from this sequence
  // and potentially effect other transactions in the testbench
  // ***************************************************************
  function void registerDriverCallback();
    cb = new;
    cb.seq = this;
    cdnEnetUvmDriverCbsT::add(p_sequencer.pAgent.driver,cb);
  endfunction

  // ***************************************************************
  // This function removes callback registration from the driver
  // Once the callback is not registered to the driver, it will not be triggered and transactions will not be modified. 
  // ***************************************************************
  function void unregisterDriverCallback();
    cdnEnetUvmDriverCbsT::delete(p_sequencer.pAgent.driver,cb);
  endfunction      
  // ***************************************************************
  // Enables the transaction modification capability.
  // ***************************************************************
  virtual task pre_start();
    super.pre_start();
    if (enableSetInstanceCallbacks == 1)
      setInstanceCallbacks();
    if (enableRegisterDriverCallback == 1)
      registerDriverCallback();    
  endtask

  // ***************************************************************
  // Disable the transaction modification capability.
  // ***************************************************************
  virtual task post_start();
    super.post_start();      
    if (enableRegisterDriverCallback == 1)
      unregisterDriverCallback();    
  endtask
  
  // ***************************************************************
  // Unregister the callback when sequence is terminated by using either sequence.kill() or sequencer.stop_sequences().
  // ***************************************************************
  virtual function void do_kill();
    super.do_kill();      
    if (enableRegisterDriverCallback == 1)
      unregisterDriverCallback();
  endfunction
  // ***************************************************************
  // User-callback function for implementation of the transaction modification logic
  // ***************************************************************
  virtual function void modifyTransaction(denaliEnetTransaction tr);

  endfunction


endclass


`endif // CDN_ENET_UVM_SEQUENCE_SV
