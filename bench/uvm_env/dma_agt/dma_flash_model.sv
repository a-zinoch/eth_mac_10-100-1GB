`ifndef DMA_FLASH_MODEL
`define DMA_FLASH_MODEL

class dma_flash_model extends uvm_component;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	env_config env_cfg;
	agt_config_dmabus agt_cfg;
	dma_mem_status_t status;
	logic [15:0] mem [];
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_flash_model)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_flash_model", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function dma_mem_status_t init_mem();
	extern function dma_mem_t mem_op(dma_mem_t rw);
endclass : dma_flash_model

function void dma_flash_model::build_phase(uvm_phase phase);

	if(!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) begin
		`uvm_error(get_full_name(),"ENV config not found!")
	end
	agt_cfg = env_cfg.agt_cfg_dmabus;
	status = init_mem();
endfunction : build_phase

function dma_mem_status_t dma_flash_model::init_mem();
	mem = new[agt_cfg.flash_size];
	$readmemb(agt_cfg.flash_image, mem, 0, agt_cfg.flash_size);
	return DMA_MEM_OK;
endfunction : init_mem

function dma_mem_t dma_flash_model::mem_op(dma_mem_t rw);
	if(rw.mem_op == DMA_MEM_WRITE) begin
		rw.st = DMA_MEM_FAIL;
	end else if(rw.mem_op == DMA_MEM_READ) begin
		rw.data = mem[rw.adr - agt_cfg.flash_offest];
		rw.st = DMA_MEM_OK;
	end else begin
		rw.st = DMA_MEM_FAIL;
	end
	return rw;
endfunction : mem_op

`endif //DMA_FLASH_MODEL