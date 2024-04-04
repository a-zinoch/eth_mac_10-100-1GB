`ifndef DMA_ROM_MODEL
`define DMA_ROM_MODEL

class dma_rom_model extends uvm_component;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	env_config env_cfg;
	agt_config_dmabus agt_cfg;
	dma_mem_status_t status;
	logic [31:0] mem [];
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_rom_model)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_rom_model", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function dma_mem_status_t init_mem();
	extern function dma_mem_t mem_op(dma_mem_t rw);
endclass : dma_rom_model

function void dma_rom_model::build_phase(uvm_phase phase);

	if(!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) begin
		`uvm_error(get_full_name(),"DMA bus agt config not found!")
	end
	agt_cfg = env_cfg.agt_cfg_dmabus;

	status = init_mem();
endfunction : build_phase

function dma_mem_status_t dma_rom_model::init_mem();
	// int i=0;
	mem = new[agt_cfg.rom_size];
	foreach(mem[i]) begin
		mem[i] = $urandom_range(0,'hFFFF_FFFF);
	end
	// $readmemb(agt_cfg.rom_image, mem, 0, agt_cfg.rom_size);
	return DMA_MEM_OK;
endfunction : init_mem

function dma_mem_t dma_rom_model::mem_op(dma_mem_t rw);
	if(rw.mem_op == DMA_MEM_WRITE) begin
		rw.st = DMA_MEM_FAIL;
	end else if(rw.mem_op == DMA_MEM_READ) begin
		rw.data = mem[rw.adr - agt_cfg.rom_offest];
		rw.st = DMA_MEM_OK;
	end else begin
		rw.st = DMA_MEM_FAIL;
	end
	return rw;
endfunction : mem_op

`endif //DMA_ROM_MODEL