`ifndef ENVIRONMENT
`define ENVIRONMENT

class environment #(type reg_adapter_t = uni_reg_adapter) extends uvm_env;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	UVM_FILE file_h;
	env_config env_cfg;

	/*Sysbus*/
	sysbus_agent sb_agt;
	sysbus_subscriber sb_sbscr;
	uni_reg_predictor reg_predictor;
	scoreboard scrb;

	/*Dma bus*/
	dma_agent dma_agt;
	dma_subscriber dma_sbscr;

	/*Periph bus*/
	periph_agent prph_agt;
	periph_subscriber prph_sbscr;

	/*VIP ETH*/
    eth_agent	activePhy;   
    eth_agent	passiveMac;
    // eth_agent	passivePhy;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(environment)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "environment", uvm_component parent=null);
		super.new(name, parent);
		factory.set_type_override_by_type(cdnEnetUvmInstance::get_type(), eth_instance::get_type());
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : environment


/**
 * @brief Build phase
 * @details create and configure enviroment objects
 *
 * @param phase
 */
function void environment::build_phase(uvm_phase phase);
	uvm_report_info(get_full_name(),"START of build phase!",UVM_LOW);

	if(!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) begin
		`uvm_error(get_full_name(),"Env config not found!")
	end

	if(env_cfg.sysbus_agt_en) begin
		sb_agt = sysbus_agent::type_id::create("sb_agt", this);
		sb_sbscr = sysbus_subscriber::type_id::create("sb_sbscr", this);
		scrb = scoreboard::type_id::create("scrb",this);

		uvm_config_db #(agt_config_sysbus)::set(this, "*", "sysbus_agt_cfg", env_cfg.agt_cfg_sysbus);
		if(env_cfg.agt_cfg_sysbus.using_RAL) begin
			reg_predictor = uni_reg_predictor::type_id::create("reg_predictor",this);
		end
	end

	if(env_cfg.agt_cfg_dmabus) begin
		dma_agt = dma_agent::type_id::create("dma_agt",this);
		dma_sbscr = dma_subscriber::type_id::create("dma_sbscr",this);

		uvm_config_db #(agt_config_dmabus)::set(this, "*", "dmabus_agt_cfg", env_cfg.agt_cfg_dmabus);
	end

	if(env_cfg.agt_cfg_periph) begin
		prph_agt = periph_agent::type_id::create("prph_agt",this);
		prph_sbscr = periph_subscriber::type_id::create("prph_sbscr",this);

		uvm_config_db #(agt_config_periph)::set(this, "*", "periph_agt_cfg", env_cfg.agt_cfg_periph);
	end

	// Active PHY
	set_config_int("activePhy", "is_active", UVM_ACTIVE);
	activePhy = eth_agent::type_id::create("activePhy", this);

	// Passive MAC
	set_config_int("passiveMac", "is_active", UVM_PASSIVE);
	passiveMac = eth_agent::type_id::create("passiveMac", this);

	//set the full hdl path of the agent wrapper - this setting is mandatory.
	set_config_string("activePhy","hdlPath", "eth_tb_top.phy");
	set_config_string("passiveMac","hdlPath", "eth_tb_top.mac_passive");

	uvm_report_info(get_full_name(),"END of build phase!",UVM_LOW);
endfunction : build_phase

/**
 * @brief Connect phase
 * @details connect uvm objects
 *
 * @param phase
 */
function void environment::connect_phase(uvm_phase phase);
	uvm_report_info(get_full_name(),"START of connect phase!",UVM_LOW);

	if(env_cfg.sysbus_agt_en) begin
		sb_agt.aport.connect( sb_sbscr.analysis_export );
		sb_agt.aport.connect( scrb.item_collected_export );
		if(env_cfg.agt_cfg_sysbus.using_RAL) begin
			env_cfg.agt_cfg_sysbus.reg_block.default_map.set_sequencer(
				.sequencer(sb_agt.sb_sequencer_h),
				.adapter(sb_agt.reg_adapter)
			);
			reg_predictor.map     = env_cfg.agt_cfg_sysbus.reg_block.default_map;
			reg_predictor.adapter = sb_agt.reg_adapter;
			env_cfg.agt_cfg_sysbus.reg_block.default_map.set_auto_predict(1);

			sb_agt.aport.connect( reg_predictor.bus_in );
		end
	end

	if(env_cfg.agt_cfg_dmabus) begin
		dma_agt.aport.connect( dma_sbscr.analysis_export );
	end

	if(env_cfg.agt_cfg_periph) begin
		prph_agt.aport.connect( prph_sbscr.analysis_export );
	end

	uvm_report_info(get_full_name(),"END of connect phase!",UVM_LOW);
endfunction : connect_phase

/**
 * @brief Start of simulation
 * @details create log file
 *
 * @param phase
 */
function void environment::start_of_simulation_phase(uvm_phase phase);
	uvm_report_info(get_full_name(),"START of simulation phase!",UVM_LOW);
	uvm_top.set_report_verbosity_level_hier(UVM_NONE);

	file_h = $fopen("uvm_basics_complete.log", "w");
	uvm_top.set_report_default_file_hier(file_h);
	uvm_top.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY + UVM_LOG);

	uvm_report_info(get_full_name(),"END of simulation phase!",UVM_LOW);
endfunction : start_of_simulation_phase


function void environment::end_of_elaboration_phase(uvm_phase phase);

	super.end_of_elaboration_phase(phase);

	`uvm_info(get_full_name(), "Setting callbacks", UVM_LOW);

	// Enable callbacks. Uncomment as necessary
	// Refer to the User  Guide for callbacks description

	//***************************************************************************************
	// Active MAC
	//***************************************************************************************
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_Error));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitPkt));
	// 	 void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxPktStartedPkt));
	// void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxPktEndedPkt));
	// void'(activeMac.inst.setCallback( DENALI_ENET_CB_RxPktEndedPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitMgmtPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxPktStartedMgmtPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxPktEndedMgmtPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_RxPktEndedMgmtPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitTransportPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitNetworkPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitMplsPkt));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitSnapPkt));
	// void'(activeMac.inst.setCallback( DENALI_ENET_CB_ResetAsserted));
	// void'(activeMac.inst.setCallback( DENALI_ENET_CB_ResetDeasserted));
	//   void'(activeMac.inst.setCallback( DENALI_ENET_CB_AlignStatusUp));
	//   void'(activeMac.inst.setCallback(DENALI_ENET_CB_AlignStatusDown));
	 
	//***************************************************************************************
	// Active PHY
	//***************************************************************************************
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_Error));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitPkt));
	void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxPktStartedPkt));
	void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxPktEndedPkt));
	void'(activePhy.inst.setCallback( DENALI_ENET_CB_RxPktEndedPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitMgmtPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxPktStartedMgmtPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxPktEndedMgmtPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_RxPktEndedMgmtPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitTransportPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitNetworkPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitMplsPkt));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_TxUserQueueExitSnapPkt));
	void'(activePhy.inst.setCallback( DENALI_ENET_CB_ResetAsserted));
	void'(activePhy.inst.setCallback( DENALI_ENET_CB_ResetDeasserted));
	//   void'(activePhy.inst.setCallback( DENALI_ENET_CB_AlignStatusUp));
	//   void'(activePhy.inst.setCallback(DENALI_ENET_CB_AlignStatusDown));
	//
	//***************************************************************************************
	// Passive MAC
	//***************************************************************************************
	//   void'(passiveMac.inst.setCallback( DENALI_ENET_CB_Error));
	void'(passiveMac.inst.setCallback( DENALI_ENET_CB_RxPktEndedPkt));
	//   void'(passiveMac.inst.setCallback( DENALI_ENET_CB_RxPktEndedMgmtPkt));
	void'(passiveMac.inst.setCallback( DENALI_ENET_CB_ResetAsserted));
	void'(passiveMac.inst.setCallback( DENALI_ENET_CB_ResetDeasserted));
	//   void'(passiveMac.inst.setCallback( DENALI_ENET_CB_AlignStatusUp));
	//   void'(passiveMac.inst.setCallback(DENALI_ENET_CB_AlignStatusDown));
	//
	//***************************************************************************************
	// Passive PHY
	//***************************************************************************************
	//   void'(passivePhy.inst.setCallback( DENALI_ENET_CB_Error));
	// void'(passivePhy.inst.setCallback( DENALI_ENET_CB_RxPktEndedPkt));
	// //   void'(passivePhy.inst.setCallback( DENALI_ENET_CB_RxPktEndedMgmtPkt));
	// void'(passivePhy.inst.setCallback( DENALI_ENET_CB_ResetAsserted));
	// void'(passivePhy.inst.setCallback( DENALI_ENET_CB_ResetDeasserted));
	//   void'(passivePhy.inst.setCallback( DENALI_ENET_CB_AlignStatusUp));
	//   void'(passivePhy.inst.setCallback(DENALI_ENET_CB_AlignStatusDown));



	`uvm_info(get_full_name(), "Setting callbacks ... DONE", UVM_LOW);

endfunction : end_of_elaboration_phase

`endif //ENVIRONMENT
