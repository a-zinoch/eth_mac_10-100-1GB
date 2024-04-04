package pkg_uvm_top;
	import uvm_pkg::*;

	//Import the DDVAPI Enet SV interface and the generic Mem interface
	import DenaliSvEnet::*;
	import DenaliSvMem::*;
	import cdnEnetUvm::*;

	/*General*/
	`include "bench/uvm_env/mac_eth_pkt.sv"
	
	/*Register Abstraction Layer*/
	`include "bench/uvm_env/RAL/eth_cadr_l_reg.sv"
	`include "bench/uvm_env/RAL/eth_card_h_reg.sv"
	`include "bench/uvm_env/RAL/eth_dma_adr_reg.sv"
	`include "bench/uvm_env/RAL/eth_mcom_reg.sv"
	`include "bench/uvm_env/RAL/eth_phy_reg.sv"
	`include "bench/uvm_env/RAL/eth_qnt_reg.sv"
	`include "bench/uvm_env/RAL/eth_ram_adr_rx9_reg.sv"
	`include "bench/uvm_env/RAL/eth_ram_adr_tx9_reg.sv"
	`include "bench/uvm_env/RAL/eth_ram_d32_reg.sv"
	`include "bench/uvm_env/RAL/eth_start_tx_reg.sv"
	`include "bench/uvm_env/RAL/eth_stat_reg.sv"
	`include "bench/uvm_env/RAL/eth_reg_block.sv"

	/*Configurations*/
	`include "kmx32/cfg/agt_cfg_sysbus.sv"
	`include "bench/uvm_env/periph_agt/periph_packet.sv"
	`include "kmx32/cfg/agt_cfg_periph.sv"
	`include "kmx32/cfg/agt_cfg_dmabus.sv"
	`include "kmx32/cfg/env_cfg.sv"

	/*Extended from ETH Phy*/
	`include "bench/uvm_env/ethphy_agt/eth_instance.sv"
	`include "bench/uvm_env/ethphy_agt/eth_sequencer.sv"

	/*Sequence lib*/
	`include "bench/uvm_env/ethphy_agt/eth_sequence_lib.sv"
	`include "bench/uvm_env/ethphy_agt/eth_fd_seq.sv"
	`include "bench/uvm_env/ethphy_agt/eth_hd_seq.sv"
	// `include "bench/uvm_env/ethphy_agt/eth_major_seq.sv"
	// `include "bench/uvm_env/ethphy_agt/eth_err_seq.sv"
	/*End Sequence lib*/

	`include "bench/uvm_env/ethphy_agt/eth_driver.sv"
	`include "bench/uvm_env/ethphy_agt/eth_coverage.sv"
	`include "bench/uvm_env/ethphy_agt/eth_monitor.sv"
	`include "bench/uvm_env/ethphy_agt/eth_agent.sv"

	/*Periph agent*/
	`include "bench/uvm_env/periph_agt/periph_item.sv"
	`include "bench/uvm_env/periph_agt/periph_sequencer.sv"
	`include "bench/uvm_env/periph_agt/periph_sequence_lib.sv"
	`include "bench/uvm_env/periph_agt/periph_driver.sv"
	`include "bench/uvm_env/periph_agt/periph_monitor.sv"
	`include "bench/uvm_env/periph_agt/periph_subscriber.sv"
	`include "bench/uvm_env/periph_agt/periph_agent.sv"

	/*DMA agent*/
	`include "kmx32/dma_agt/dma_mem_types.sv"
	`include "kmx32/dma_agt/dma_rom_model.sv"
	`include "kmx32/dma_agt/dma_flash_model.sv"
	`include "kmx32/dma_agt/dma_ram_model.sv"
	`include "kmx32/dma_agt/dma_mem_block.sv"
	`include "kmx32/dma_agt/dma_item.sv"
	`include "kmx32/dma_agt/dma_sequencer.sv"
	`include "kmx32/dma_agt/dma_sequence_lib.sv"
	`include "kmx32/dma_agt/dma_driver.sv"
	`include "kmx32/dma_agt/dma_monitor.sv"
	`include "kmx32/dma_agt/dma_subscriber.sv"
	`include "kmx32/dma_agt/dma_agent.sv"

	/*SysBus agent*/
	`include "kmx32/sysbus_agt/sysbus_item.sv"
	`include "kmx32/sysbus_agt/sysbus_reg_predictor.sv"	//RAL <---> DRV
	`include "kmx32/sysbus_agt/sysbus_reg_adapter.sv"	//RAL <---> DRV
	`include "kmx32/sysbus_agt/sysbus_sequencer.sv"
	// `include "kmx32_sysbus_agt/sysbus_sequence_lib.sv"
	`include "bench/uvm_env/sysbus_agt/sysbus_sequence_lib.sv"
	`include "kmx32/sysbus_agt/sysbus_driver.sv"
	`include "kmx32/sysbus_agt/sysbus_monitor.sv"
	`include "kmx32/sysbus_agt/sysbus_subscriber.sv"
	`include "kmx32/sysbus_agt/sysbus_agent.sv"

	/*Enviroment*/
	`include "kmx32/env/scoreboard_template.sv"
	`include "bench/uvm_env/env/env.sv"
	`include "bench/uvm_env/eth_tests.sv"

endpackage