
`ifndef CDN_ENET_UVM_MEM_INSTANCE_SV
`define CDN_ENET_UVM_MEM_INSTANCE_SV

// ***************************************************************
// class: cdnEnetUvmMemInstance
// This class is a wrapper for the model memory space, and
// provides an API for it.
// ***************************************************************
class cdnEnetUvmMemInstance extends denaliMemInstance;
  
  // ***************************************************************
  // A reference to the agent, as set by the agent.
  // ***************************************************************
  cdnEnetUvmAgent pAgent;
  
  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_component_utils(cdnEnetUvmMemInstance)
  
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnEnetUvmMemInstance", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // ***************************************************************
  // Method : writeReg
  // Desc.  : A convenience method that performs a register write to
  //          the associated model memory space.
  // ***************************************************************
  virtual function void writeReg(denaliEnetRegNumT addr, reg [31:0] data);
    
    denaliMemTransaction trans;
    
    // Instantiate a new Memory Transaction
    trans = new();
    
    // Since the Data in a Memory transaction is an 8-bit array,
    // and we want to write 32-bits of data, size the Data in the
    // Memory transaction to 4.
    trans.Data = new[4];
    
    // Populate the Data in the Memory transaction.  Note the
    // order of the trans.Data bytes to the data bytes.
    trans.Data[0] = data[31:24];
    trans.Data[1] = data[23:16];
    trans.Data[2] = data[15:08];
    trans.Data[3] = data[07:00];
    
    // Populate the address in the Memory transaction
    trans.Address = addr;
    
    // Perform the actual write to the Model's register/memory space.
    void'(write(trans));
    
  endfunction : writeReg
  
  // ***************************************************************
  // Method : readReg
  // Desc.  : A convenience method that performs a register read of
  //          the associated model memory space.
  // ***************************************************************
  virtual function reg [31:0] readReg(denaliEnetRegNumT addr);
    
    denaliMemTransaction trans;
    
    // Instantiate a new Memory Transaction
    trans = new();
    
    // Populate the address in the Memory transaction
    trans.Address = addr;
    
    // Perform the actual read to the Model's memory
    // space.
    void'(read(trans));
    
    // Extract the data from the Memory transaction
    readReg[31:24] = trans.Data[0];
    readReg[23:16] = trans.Data[1];
    readReg[15:08] = trans.Data[2];
    readReg[07:00] = trans.Data[3];
  endfunction : readReg
  
  // ***************************************************************
  // Method : maskedWriteReg
  // Desc.  : A convenience method that performs a masked register
  //          write to the associated model memory space.
  // ***************************************************************
  virtual function void maskedWriteReg(denaliEnetRegNumT addr, reg [31:0] data, reg [31:0] mask);
    reg [31:0] rdData;
    
    rdData = readReg(addr);
    rdData &= (~mask);
    rdData |= data;
    writeReg(addr, rdData);
  endfunction : maskedWriteReg

  // ***************************************************************
  // Method : WriteCbF
  // Desc.  : Invoked when the memory/register space gets written.
  // ***************************************************************
  virtual function int WriteCbF(ref denaliMemTransaction trans) ;
    return super.WriteCbF(trans);
  endfunction : WriteCbF
  
endclass : cdnEnetUvmMemInstance

`endif // CDN_ENET_UVM_MEM_INSTANCE_SV
