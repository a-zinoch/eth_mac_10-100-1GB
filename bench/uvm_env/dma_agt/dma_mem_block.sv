`ifndef DMA_MEM_BLOCK
`define DMA_MEM_BLOCK

class dma_mem_block extends uvm_component;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	env_config env_cfg;
	agt_config_dmabus agt_cfg;
	dma_mem_status_t status;

	dma_rom_model rom_mem;
	dma_ram_model ram_mem;
	dma_flash_model flash_mem;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_mem_block)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_mem_block", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function dma_mem_t memory(dma_mem_t rw);
endclass : dma_mem_block

function void dma_mem_block::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) begin
		`uvm_error(get_full_name(),"ENV config not found!")
	end

	agt_cfg = env_cfg.agt_cfg_dmabus;

	if(agt_cfg.rom_en)
		rom_mem = dma_rom_model::type_id::create("rom_mem",this);

	if(agt_cfg.ram_en)
		ram_mem = dma_ram_model::type_id::create("ram_mem",this);

	if(agt_cfg.flash_en)
		flash_mem = dma_flash_model::type_id::create("flash_mem",this);

	if(agt_cfg.rom_en && agt_cfg.ram_en)
		if(agt_cfg.rom_offest < agt_cfg.ram_offest) begin
			if(agt_cfg.rom_offest+agt_cfg.rom_size >= agt_cfg.ram_offest + agt_cfg.ram_size)
				`uvm_fatal(get_full_name(),"ROM and RAM memory overlapping!");
		end else begin
			if(agt_cfg.rom_offest+agt_cfg.rom_size <= agt_cfg.ram_offest + agt_cfg.ram_size)
				`uvm_fatal(get_full_name(),"ROM and RAM memory overlapping!");
		end

	if(agt_cfg.rom_en && agt_cfg.flash_en)
		if(agt_cfg.rom_offest < agt_cfg.flash_offest) begin
			if(agt_cfg.rom_offest+agt_cfg.rom_size >= agt_cfg.flash_offest + agt_cfg.flash_size)
				`uvm_fatal(get_full_name(),"ROM and FLASH memory overlapping!");
		end else begin
			if(agt_cfg.rom_offest+agt_cfg.rom_size <= agt_cfg.flash_offest + agt_cfg.flash_size)
				`uvm_fatal(get_full_name(),"ROM and FLASH memory overlapping!");
		end

	if(agt_cfg.ram_en && agt_cfg.flash_en)
		if(agt_cfg.ram_offest < agt_cfg.flash_offest) begin
			if(agt_cfg.ram_offest+agt_cfg.ram_size >= agt_cfg.flash_offest + agt_cfg.flash_size)
				`uvm_fatal(get_full_name(),"RAM and FLASH memory overlapping!");
		end else begin
			if(agt_cfg.ram_offest+agt_cfg.ram_size <= agt_cfg.flash_offest + agt_cfg.flash_size)
				`uvm_fatal(get_full_name(),"RAM and FLASH memory overlapping!");
		end

	if(agt_cfg.rom_en)
		`uvm_info(get_full_name(),$psprintf("ROM memory offset:%x , size:%x",
			agt_cfg.rom_offest,agt_cfg.rom_size),UVM_LOW);

	if(agt_cfg.ram_en)
		`uvm_info(get_full_name(),$psprintf("RAM memory offset:%x , size:%x",
			agt_cfg.ram_offest,agt_cfg.ram_size),UVM_LOW);

	if(agt_cfg.flash_en)
		`uvm_info(get_full_name(),$psprintf("FLASH memory offset:%x , size:%x",
			agt_cfg.flash_offest,agt_cfg.flash_size),UVM_LOW);

	status = DMA_MEM_OK;
endfunction : build_phase

function dma_mem_t dma_mem_block::memory(dma_mem_t rw);
	dma_mem_t result;

	if(agt_cfg.rom_en && rw.adr >= agt_cfg.rom_offest && rw.adr <= agt_cfg.rom_offest + agt_cfg.rom_size) begin
		result = rom_mem.mem_op(rw);
	end else if(agt_cfg.ram_en && rw.adr >= agt_cfg.ram_offest && rw.adr <= agt_cfg.ram_offest + agt_cfg.ram_size) begin
		result = ram_mem.mem_op(rw);
	end else if(agt_cfg.flash_en && rw.adr >= agt_cfg.flash_offest && rw.adr <= agt_cfg.flash_offest + agt_cfg.flash_size) begin
		result = flash_mem.mem_op(rw);
	end else begin
		result.st = DMA_MEM_FAIL;
	end
	`uvm_info("Memory",$psprintf("Memory op: %s addr: %x data: %x status: %s",
		result.mem_op.name(),result.adr,result.data,result.st.name()),UVM_MEDIUM);
	return result;
endfunction : memory

`endif //DMA_MEM_BLOCK
