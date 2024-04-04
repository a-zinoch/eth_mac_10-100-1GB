
`ifndef CDN_ENET_UVM_AGENT_SV
`define CDN_ENET_UVM_AGENT_SV

// ***************************************************************
// class: cdnEnetUvmAgent
// This class defines the ENET agent.
// ***************************************************************
class cdnEnetUvmAgent extends uvm_agent;
   
  // ***************************************************************
  // Declare the components that comprise the agent : 
  // instance, register space, driver, sequencer, monitor
  // ***************************************************************
  
  // ***************************************************************
  // The reference to the monitor.
  // ***************************************************************
  cdnEnetUvmMonitor monitor;
  

    
  // ***************************************************************
  // The reference to the driver.
  // ***************************************************************
  cdnEnetUvmDriver driver;
  
  // ***************************************************************
  // The reference to the sequencer.
  // ***************************************************************
  cdnEnetUvmSequencer sequencer;

  
  // ***************************************************************
  // The reference to the model instance.
  // The model instance provides a direct interface to the model.
  // ***************************************************************
  cdnEnetUvmInstance inst;  
  
  
  // ***************************************************************
  // Reference to model memory regInst
  // Description:
  // Standard register file for status/control of the model instance.
  // ***************************************************************
  cdnEnetUvmMemInstance regInst;

  
  
  
  // ***************************************************************
  // The full path to the equivalent Verilog wrapper used by the agent.
  // ***************************************************************
  string hdlPath;
  
  
  // \@dvt_no_html_doc
  //Internal field to be used by cadence only
  string __internal__instName;
         

  // ***************************************************************
  // Register some fields.
  // ***************************************************************
  `uvm_component_utils_begin(cdnEnetUvmAgent)
    `uvm_field_string(hdlPath, UVM_ALL_ON)
    `uvm_field_enum(uvm_active_passive_enum,is_active, UVM_ALL_ON)
         
  `uvm_component_utils_end

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmAgent", uvm_component parent = null);
    super.new(name, parent);

  endfunction : new
  
  

  // ***************************************************************
  // Method : build/build_phase
  // Desc.  : Instantiate the required ports.
  // ***************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    begin
      if (hdlPath == "")
        `uvm_error("AGENT","hdlPath was not set, hdlPath is path to the agent wrapper");
       __internal__instName = hdlPath;          
    end
    
    set_config_string("inst", "instName", __internal__instName);
    

    set_config_string("regInst", "instName", $sformatf("%s(registers)", __internal__instName));

    
    // Instantiate the vip core instance handle
    inst = cdnEnetUvmInstance::type_id::create("inst", this);
    
    // Instantiate the register space handle
    regInst = cdnEnetUvmMemInstance::type_id::create("regInst", this); 

    
    // Set coverageEnable default for Passive agent to '1'
    if (is_active == UVM_PASSIVE) begin
      set_config_int("monitor", "coverageEnable", 1);
    end

        
    // Instantiate the monitor
    monitor = cdnEnetUvmMonitor::type_id::create("monitor", this);
    
    if (is_active == UVM_ACTIVE) begin
      sequencer = cdnEnetUvmSequencer::type_id::create("sequencer", this);
      driver = cdnEnetUvmDriver::type_id::create("driver", this);
    end

    
    
    if (!$cast(inst.pAgent, this))
    `uvm_error("AGENT","inst was declared with a pAgent type which is not compatible with agent dynamic type");
    if (!$cast(monitor.pAgent, this))
    `uvm_error("AGENT","monitor was declared with a pAgent type which is not compatible with agent dynamic type");
    
    if (!$cast(regInst.pAgent, this))
    `uvm_error("AGENT","regInst was declared with a pAgent type which is not compatible with agent dynamic type");

    
    if (!$cast(monitor.pInst, inst))
    `uvm_error("AGENT","monitor was declared with a pInst type which is not compatible with inst dynamic type");
    
    
    if (is_active == UVM_ACTIVE) begin
      if (!$cast(driver.pAgent,this))
      `uvm_error("AGENT","driver was declared with a pAgent type which is not compatible with agent dynamic type");
      if (!$cast(driver.pInst,inst))      
      `uvm_error("AGENT","driver was declared with a pInst type which is not compatible with inst dynamic type");
      if (!$cast(sequencer.pAgent,this))
      `uvm_error("AGENT","sequencer was declared with a pAgent type which is not compatible with agent dynamic type");
      if (!$cast(sequencer.pInst,inst))
      `uvm_error("AGENT","sequencer was declared with a pInst type which is not compatible with inst dynamic type");
    end


    
  endfunction : build_phase

  // ***************************************************************
  // Method : connect/connect_phase
  // Desc.  : Connect the analysis ports to the instance.
  // ***************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);    
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      driver.rsp_port.connect(sequencer.rsp_export);
    end
    
  endfunction : connect_phase
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
  endfunction

endclass : cdnEnetUvmAgent

`endif // CDN_ENET_UVM_AGENT_SV
