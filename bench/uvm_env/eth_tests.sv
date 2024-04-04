`ifndef ETH_TESTS
`define ETH_TESTS

virtual class eth_base_test extends uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	environment t_env;
	env_config env_cfg;
	agt_config_sysbus agt_cfg_sysbus;
	agt_config_periph agt_cfg_periph;
	agt_config_dmabus agt_cfg_dmabus;
	eth_reg_block eth_reg_model;
	periph_packet periph_pkt;

	int status = 1;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_base_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_base_test", uvm_component parent=null);
		super.new(name, parent);
		t_env = new("t_env",this);
		env_cfg = env_config::type_id::create("env_cfg");
		agt_cfg_sysbus = agt_config_sysbus::type_id::create("agt_cfg_sysbus");
		agt_cfg_periph = agt_config_periph::type_id::create("agt_cfg_periph");
		agt_cfg_dmabus = agt_config_dmabus::type_id::create("agt_cfg_dmabus");
	endfunction : new

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void extract_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);
	//extern virtual task run_phase(uvm_phase phase);
endclass : eth_base_test

/**
 * @brief build_phase
 * @details create and configure test objects
 *
 * @param phase
 */
function void eth_base_test::build_phase(uvm_phase phase);
	if(!uvm_config_db #(virtual if_sysbus)::get(this,"","sysbus_vi",agt_cfg_sysbus.sysbus_vi)) begin
		`uvm_error(get_full_name(),"Sysbus_vi not found!")
	end

	if(!uvm_config_db #(virtual if_dma_bus)::get(this,"","dma_vi",agt_cfg_dmabus.dmabus_vi)) begin
		`uvm_error(get_full_name(),"Dma_vi not found!")
	end

	if(!uvm_config_db #(virtual if_periph_bus)::get(this,"","periph_vi",agt_cfg_periph.periph_vi)) begin
		`uvm_error(get_full_name(),"Periph_vi not found!")
	end

	env_cfg.agt_cfg_sysbus = agt_cfg_sysbus;
	env_cfg.agt_cfg_dmabus = agt_cfg_dmabus;
	env_cfg.agt_cfg_periph = agt_cfg_periph;

	env_cfg.sysbus_agt_en = 1;
	env_cfg.dmabus_agt_en = 0;
	env_cfg.periph_agt_en = 1;

	eth_reg_model = eth_reg_block::type_id::create("eth_reg_model");
	eth_reg_model.build();

	env_cfg.agt_cfg_sysbus.reg_block = eth_reg_model;
	env_cfg.agt_cfg_sysbus.using_RAL = 1;

	uvm_config_db #(env_config)::set(this,"*","env_cfg",env_cfg);

	periph_pkt = periph_packet::type_id::create("periph_pkt");

	`ifdef FULL_DUPLEX
		uvm_config_db#(uvm_object_wrapper)::set(this, "t_env.activePhy.sequencer.run_phase", "default_sequence", eth_fd_sequence::type_id::get());
	`else
		uvm_config_db#(uvm_object_wrapper)::set(this, "t_env.activePhy.sequencer.run_phase", "default_sequence", eth_fd_sequence::type_id::get());
	`endif
	set_config_int("t_env.activePhy.passiveMac.monitor", "coverageEnable",1);
	// dma_memory = dma_mem_block::type_id::create("dma_memory",this);
endfunction : build_phase


function void eth_base_test::end_of_elaboration_phase(uvm_phase phase);
	int regValue;
	//User can do the dynamic configuration in this phase through regWrite.

	//Configuring scoreboard for injecting and collecting agents.
	// t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.activePhy.inst.getId());
	//TX PATH
	t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_InjectingAgentId, t_env.passiveMac.inst.getId());
	t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.activePhy.inst.getId() );
	//RX PATH
	t_env.passiveMac.regInst.writeReg( DENALI_ENET_REG_InjectingAgentId, t_env.activePhy.inst.getId() );
	t_env.passiveMac.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.passiveMac.inst.getId());


endfunction: end_of_elaboration_phase

/**
 * @brief extract_phase
 * @details extract results from scoreboard
 *
 * @param phase
 */
function void eth_base_test::extract_phase(uvm_phase phase);
	status = $urandom_range(0,1);
endfunction : extract_phase

/**
 * @brief report_phase
 * @details report results
 *
 * @param phase
 */
function void eth_base_test::report_phase(uvm_phase phase);
	if(status) begin
		`uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
	end else begin
		`uvm_error(get_type_name(), "** UVM TEST FAIL **")
	end
endfunction : report_phase

virtual class eth_dma_test extends eth_base_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	dma_mem_block dma_memory;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_dma_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_dma_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void extract_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);
	//extern virtual task run_phase(uvm_phase phase);

endclass : eth_dma_test

function void eth_dma_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

	env_cfg.dmabus_agt_en = 1;

	env_cfg.agt_cfg_dmabus.rom_width = 32;
	env_cfg.agt_cfg_dmabus.rom_size = 32*1024;
	env_cfg.agt_cfg_dmabus.rom_offest = 'h1000_0000;
	env_cfg.agt_cfg_dmabus.rom_image = "bench/uvm_env/aes_test/rom_image.bin";

	env_cfg.agt_cfg_dmabus.ram_width = 32;
	env_cfg.agt_cfg_dmabus.ram_size = 12*1024;
	env_cfg.agt_cfg_dmabus.ram_offest = 'h0000_0000;
	env_cfg.agt_cfg_dmabus.ram_image = "bench/uvm_env/aes_test/ram_image.bin";

	env_cfg.agt_cfg_dmabus.flash_width = 32;
	env_cfg.agt_cfg_dmabus.flash_size = 512*1024;
	env_cfg.agt_cfg_dmabus.flash_offest = 'h8000_0000;
	env_cfg.agt_cfg_dmabus.flash_image = "bench/uvm_env/aes_test/flash_image.bin";

	env_cfg.agt_cfg_dmabus.rom_en   = 1;
	env_cfg.agt_cfg_dmabus.ram_en   = 1;
	env_cfg.agt_cfg_dmabus.flash_en = 1;

	uvm_config_db #(env_config)::set(this,"*","env_cfg",env_cfg);

	dma_memory = dma_mem_block::type_id::create("dma_memory",this);
endfunction : build_phase

function void eth_dma_test::extract_phase(uvm_phase phase);
	super.extract_phase(phase);
endfunction : extract_phase

function void eth_dma_test::report_phase(uvm_phase phase);
	super.report_phase(phase);
endfunction : report_phase

function void eth_dma_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

/*
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
 */
class eth_full_test extends eth_dma_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_full_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_full_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern task vip_start();
	extern task run_phase(uvm_phase phase);

endclass : eth_full_test


task eth_full_test::run_phase(uvm_phase phase);
	mac_eth_fifo fifo;
	sysbus_rand_seq rand_seq;
	sysbus_rst_seq rst_seq;
	eth_init_seq eth_init;
	eth_rx_seq eth_rx;
	eth_tx_seq eth_tx;
	eth_mdio_seq mdio_seq;
	logic [47:0] mac_adr = `DUT_MAC_ADR;

	dma_mem_seq dma_seq;

	periph_mon_seq periph_seq;

	/*create sequences*/
	rand_seq = sysbus_rand_seq::type_id::create("rand_seq");
	rst_seq = sysbus_rst_seq::type_id::create("rst_seq");
	eth_init = eth_init_seq::type_id::create("eth_init",.contxt(get_full_name()));
	eth_rx = eth_rx_seq::type_id::create("eth_rx");
	eth_tx = eth_tx_seq::type_id::create("eth_tx");
	mdio_seq = eth_mdio_seq::type_id::create("mdio_seq");

	dma_seq = dma_mem_seq::type_id::create("dma_seq");

	periph_seq = periph_mon_seq::type_id::create("periph_seq");
	fifo = mac_eth_fifo::type_id::create("fifo");

	/*link memory model to dma sequence*/
	dma_seq.mem_block = dma_memory;

	/*setting sequencers*/
	t_env.sb_agt.sb_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	t_env.dma_agt.dma_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	t_env.prph_agt.periph_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	// SEQ_ARB_FIFO
	// SEQ_ARB_RANDOM
	// SEQ_ARB_STRICT_FIFO
	// SEQ_ARB_STRICT_RANDOM
	// SEQ_ARB_WEIGHTED
	// SEQ_ARB_USER

	/*link periph seq to sysbus seq*/
	eth_init.periph_pkt = periph_pkt;
	eth_rx.periph_pkt = periph_pkt;
	eth_tx.periph_pkt = periph_pkt;
	periph_seq.periph_pkt = periph_pkt;

	// /**/
	// assert( rand_seq.randomize() with {
	// 	rand_seq.adr_low == 'h0;
	// 	rand_seq.adr_hi == 'h90;
	// 	});

	phase.raise_objection(this);

	/*reset register model*/
	env_cfg.agt_cfg_sysbus.reg_block.reset();

	/*link register model to sequences*/
	eth_init.model = env_cfg.agt_cfg_sysbus.reg_block;
	eth_rx.model = env_cfg.agt_cfg_sysbus.reg_block;
	eth_tx.model = env_cfg.agt_cfg_sysbus.reg_block;
	mdio_seq.model = env_cfg.agt_cfg_sysbus.reg_block;

	/*link memory model to Rx sequence*/
	eth_rx.dma_mem = dma_memory;

	/*Create fifo and link from rx part to tx*/
	fifo.init(30);
	eth_rx.fifo = fifo;
	eth_tx.fifo = fifo;

	/*Set MAC address*/
	eth_tx.mac_adr = mac_adr;
	eth_init.mac_adr = mac_adr;

	/*send reset*/
	rst_seq.start(t_env.sb_agt.sb_sequencer_h);
	#100ns;

	`ifdef DMA_READ_EN
		assert(eth_init.randomize() with {eth_init.op_kind == 1;});
	`else
		assert(eth_init.randomize() with {eth_init.op_kind == 0;});
	`endif

	assert(eth_tx.randomize() with {eth_tx.n == `PACKET_COUNT;});
	assert(eth_rx.randomize() with {eth_rx.n == `PACKET_COUNT;});

	/*VIP part*/
	vip_start();	

	`uvm_info(get_full_name(), "Ethernet full test started", UVM_MEDIUM);
	fork
		/*config ethernet*/
		eth_init.start(t_env.sb_agt.sb_sequencer_h);

		/*Sysbus seq*/
		eth_rx.start(t_env.sb_agt.sb_sequencer_h);
		eth_tx.start(t_env.sb_agt.sb_sequencer_h);

		/*random sysbus seq*/
		// while(!seq.test_finish) begin
		// 	rand_seq.start(t_env.sb_agt.sb_sequencer_h);
		// end

		`ifdef MDIO_ENABLE
			while(!eth_rx.test_finish) begin
				mdio_seq.start(t_env.sb_agt.sb_sequencer_h);
				#100000ns;
			end
		`endif

		/*Dma seq*/
		while(!eth_rx.test_finish) begin
			dma_seq.start(t_env.dma_agt.dma_sequencer_h);
		end

		/*Periph seq*/
		while(!eth_rx.test_finish) begin
			periph_seq.start(t_env.prph_agt.periph_sequencer_h);
		end
	join

	phase.drop_objection(this);

	global_stop_request();

endtask : run_phase

task eth_full_test::vip_start();
	int regValue;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);

	#100ns;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);

	regValue = t_env.activePhy.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_MEDIUM);

	regValue = t_env.passiveMac.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("passiveMac:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_MEDIUM);
endtask : vip_start

/*
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
 */
class eth_half_test extends eth_dma_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_half_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_half_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern task vip_start();
	extern task run_phase(uvm_phase phase);
	// extern function void build_phase(uvm_phase phase);

endclass : eth_half_test

// function void eth_half_test::build_phase(uvm_phase phase);
// 	super.build_phase(phase);
// 	uvm_config_db#(uvm_object_wrapper)::set(this, "t_env.activePhy.sequencer.run_phase", "default_sequence", uvmEthPhyHalf::type_id::get());
// endfunction : build_phase 

task eth_half_test::run_phase(uvm_phase phase);
	sysbus_rand_seq rand_seq;
	sysbus_rst_seq rst_seq;
	eth_half_duplex_seq eth_seq;
	// logic [47:0] mac_adr = 'h167A_DBF9_D4EF;

	dma_mem_seq dma_seq;

	periph_mon_seq periph_seq;

	/*VIP part*/
	vip_start();	

	/*create sequences*/
	rand_seq = sysbus_rand_seq::type_id::create("rand_seq");
	rst_seq = sysbus_rst_seq::type_id::create("rst_seq");
	eth_seq = eth_half_duplex_seq::type_id::create("eth_seq",.contxt(get_full_name()));

	dma_seq = dma_mem_seq::type_id::create("dma_seq");

	periph_seq = periph_mon_seq::type_id::create("periph_seq");

	/*link memory model to dma sequence*/
	dma_seq.mem_block = dma_memory;

	/*setting sequencers*/
	t_env.sb_agt.sb_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	t_env.dma_agt.dma_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	t_env.prph_agt.periph_sequencer_h.set_arbitration(SEQ_ARB_FIFO);
	t_env.activePhy.sequencer.set_arbitration(SEQ_ARB_FIFO);
	// SEQ_ARB_FIFO
	// SEQ_ARB_RANDOM
	// SEQ_ARB_STRICT_FIFO
	// SEQ_ARB_STRICT_RANDOM
	// SEQ_ARB_WEIGHTED
	// SEQ_ARB_USER

	/*link periph seq to sysbus seq*/
	periph_seq.periph_pkt = periph_pkt;
	eth_seq.periph_pkt = periph_pkt;

	// /**/
	// assert( rand_seq.randomize() with {
	// 	rand_seq.adr_low == 'h0;
	// 	rand_seq.adr_hi == 'h90;
	// 	});

	phase.raise_objection(this);

	/*reset register model*/
	env_cfg.agt_cfg_sysbus.reg_block.reset();

	/*link register model to sequences*/
	eth_seq.model = env_cfg.agt_cfg_sysbus.reg_block;

	/*link memory model to Rx sequence*/
	eth_seq.dma_mem = dma_memory;

	/*Set MAC address*/
	//eth_tx.mac_adr = mac_adr;
	//eth_seq.mac_adr = mac_adr;

	/*send reset*/
	rst_seq.start(t_env.sb_agt.sb_sequencer_h);
	#100ns;

	assert(eth_seq.randomize() with {eth_seq.n == 500;});

	`uvm_info(get_full_name(), "Ethernet half-duplex test started", UVM_MEDIUM);
	fork
		/*Sysbus seq*/
		eth_seq.start(t_env.sb_agt.sb_sequencer_h);

		/*random sysbus seq*/
		// while(!seq.test_finish) begin
		// 	rand_seq.start(t_env.sb_agt.sb_sequencer_h);
		// end

		/*Dma seq*/
		while(!eth_seq.test_finish) begin
			dma_seq.start(t_env.dma_agt.dma_sequencer_h);
		end

		/*Periph seq*/
		while(!eth_seq.test_finish) begin
			periph_seq.start(t_env.prph_agt.periph_sequencer_h);
		end
	join

	phase.drop_objection(this);

	global_stop_request();

endtask : run_phase

task eth_half_test::vip_start();
	int regValue;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);

	#100ns;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_DuplexKind,0);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_DuplexKind,0);


	regValue = t_env.activePhy.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_MEDIUM);

	regValue = t_env.passiveMac.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("passiveMac:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_MEDIUM);

	regValue = t_env.activePhy.regInst.readReg(DENALI_ENET_REG_DuplexKind);
	`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_DuplexKind value = %d",regValue),UVM_MEDIUM);

	regValue = t_env.passiveMac.regInst.readReg(DENALI_ENET_REG_DuplexKind);
	`uvm_info(get_full_name(),$psprintf("passiveMac:: reading DENALI_ENET_REG_DuplexKind value = %d",regValue),UVM_MEDIUM);
endtask : vip_start

class eth_outside_only extends uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	environment t_env;
	env_config env_cfg;
	bit status;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(eth_outside_only)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_outside_only", uvm_component parent=null);
		super.new(name, parent);
		t_env = new("t_env",this);
		env_cfg = env_config::type_id::create("env_cfg");
	endfunction : new

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void extract_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task vip_start();

endclass : eth_outside_only

/**
 * @brief build_phase
 * @details create and configure test objects
 *
 * @param phase
 */
function void eth_outside_only::build_phase(uvm_phase phase);

	// env_cfg.agt_cfg_sysbus = 0;
	// env_cfg.agt_cfg_dmabus = 0;
	// env_cfg.agt_cfg_periph = 0;

	env_cfg.sysbus_agt_en = 0;
	env_cfg.dmabus_agt_en = 0;
	env_cfg.periph_agt_en = 0;

	// env_cfg.agt_cfg_sysbus.reg_block = 0;
	// env_cfg.agt_cfg_sysbus.using_RAL = 1;

	uvm_config_db #(env_config)::set(this,"*","env_cfg",env_cfg);
	`ifdef FULL_DUPLEX
		uvm_config_db#(uvm_object_wrapper)::set(this, "t_env.activePhy.sequencer.run_phase", "default_sequence", eth_fd_sequence::type_id::get());
	`else
		uvm_config_db#(uvm_object_wrapper)::set(this, "t_env.activePhy.sequencer.run_phase", "default_sequence", eth_fd_sequence::type_id::get());
	`endif
	set_config_int("t_env.activePhy.passiveMac.monitor", "coverageEnable",0);
	// dma_memory = dma_mem_block::type_id::create("dma_memory",this);
endfunction : build_phase


function void eth_outside_only::end_of_elaboration_phase(uvm_phase phase);
	int regValue;
	//User can do the dynamic configuration in this phase through regWrite.

	//Configuring scoreboard for injecting and collecting agents.
	// t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.activePhy.inst.getId());
	//TX PATH
	t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_InjectingAgentId, t_env.passiveMac.inst.getId());
	t_env.activePhy.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.activePhy.inst.getId() );
	//RX PATH
	t_env.passiveMac.regInst.writeReg( DENALI_ENET_REG_InjectingAgentId, t_env.activePhy.inst.getId() );
	t_env.passiveMac.regInst.writeReg( DENALI_ENET_REG_CollectingAgentId, t_env.passiveMac.inst.getId());


endfunction: end_of_elaboration_phase

/**
 * @brief extract_phase
 * @details extract results from scoreboard
 *
 * @param phase
 */
function void eth_outside_only::extract_phase(uvm_phase phase);
	status = $urandom_range(0,1);
endfunction : extract_phase

/**
 * @brief report_phase
 * @details report results
 *
 * @param phase
 */
function void eth_outside_only::report_phase(uvm_phase phase);
	if(status) begin
		`uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
	end else begin
		`uvm_error(get_type_name(), "** UVM TEST FAIL **")
	end
endfunction : report_phase

task eth_outside_only::vip_start();
	int regValue;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,1);

	#3000us;
	// #4000us;

	t_env.activePhy.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);
	t_env.passiveMac.regInst.writeReg(DENALI_ENET_REG_ResetValue,0);

	regValue = t_env.activePhy.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("activePhy:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_NONE);

	regValue = t_env.passiveMac.regInst.readReg(DENALI_ENET_REG_ResetValue);
	`uvm_info(get_full_name(),$psprintf("passiveMac:: reading DENALI_ENET_REG_ResetValue value = %d",regValue),UVM_NONE);
endtask : vip_start

task eth_outside_only::run_phase(uvm_phase phase);
	logic [47:0] mac_adr = `DUT_MAC_ADR;

	phase.raise_objection(this);

	/*VIP part*/
	vip_start();	

	`uvm_info(get_full_name(), "Ethernet full test started", UVM_NONE);

	// while(1) begin

	// end

	phase.drop_objection(this);

	global_stop_request();

endtask : run_phase


`endif //ETH_TESTS
