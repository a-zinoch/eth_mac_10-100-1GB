`ifndef ETH_REG_BLOCK
`define ETH_REG_BLOCK

class eth_reg_block extends uvm_reg_block;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand eth_mcom_reg				eth_mcom;
	rand eth_start_tx_reg			eth_start_tx;
	rand eth_stat_reg				eth_stat;
	rand eth_dma_adr_reg			eth_dma_adr;
	rand eth_qnt_reg				eth_qnt;
	rand eth_card_l_reg				eth_card_l;
	rand eth_card_h_reg				eth_card_h;
	rand eth_ram_d32_reg			eth_ram_d32;
	rand eth_ram_adr_tx9_reg		eth_ram_adr_tx9;
	rand eth_ram_adr_rx9_reg		eth_ram_adr_rx9;
	rand eth_phy_reg 				eth_phy;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_reg_block)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction : new

	extern function void build();

endclass : eth_reg_block

function void eth_reg_block::build();

	eth_mcom = eth_mcom_reg::type_id::create("eth_mcom");
	eth_mcom.configure(this);
	eth_mcom.build();

	eth_start_tx = eth_start_tx_reg::type_id::create("eth_start_tx");
	eth_start_tx.configure(this);
	eth_start_tx.build();

	eth_stat = eth_stat_reg::type_id::create("eth_stat");
	eth_stat.configure(this);
	eth_stat.build();

	eth_dma_adr = eth_dma_adr_reg::type_id::create("eth_dma_adr");
	eth_dma_adr.configure(this);
	eth_dma_adr.build();

	eth_qnt = eth_qnt_reg::type_id::create("eth_qnt");
	eth_qnt.configure(this);
	eth_qnt.build();

	eth_card_l = eth_card_l_reg::type_id::create("eth_card_l");
	eth_card_l.configure(this);
	eth_card_l.build();

	eth_card_h = eth_card_h_reg::type_id::create("eth_card_h");
	eth_card_h.configure(this);
	eth_card_h.build();

	eth_ram_d32 = eth_ram_d32_reg::type_id::create("eth_ram_d32");
	eth_ram_d32.configure(this);
	eth_ram_d32.build();

	eth_ram_adr_tx9 = eth_ram_adr_tx9_reg::type_id::create("eth_ram_adr_tx9");
	eth_ram_adr_tx9.configure(this);
	eth_ram_adr_tx9.build();

	eth_ram_adr_rx9 = eth_ram_adr_rx9_reg::type_id::create("eth_ram_adr_rx9");
	eth_ram_adr_rx9.configure(this);
	eth_ram_adr_rx9.build();

	eth_phy = eth_phy_reg::type_id::create("eth_phy");
	eth_phy.configure(this);
	eth_phy.build();

	default_map = create_map("default_map",'h0,`PAW,UVM_LITTLE_ENDIAN, 1);

	default_map.add_reg(eth_mcom,`MAC_MCOM_ADDR,"RW");
	default_map.add_reg(eth_start_tx,`MAC_MANADR_ADDR,"RW");
	default_map.add_reg(eth_stat,`MAC_TYPE_ADDR,"RW");
	default_map.add_reg(eth_dma_adr,`MAC_DMA_ADR_ADDR,"RW");
	default_map.add_reg(eth_qnt,`MAC_QNT_ADDR,"RW");
	default_map.add_reg(eth_card_l,`MAC_CARD_L_ADDR,"RW");
	default_map.add_reg(eth_card_h,`MAC_CARD_H_ADDR,"RW");
	default_map.add_reg(eth_ram_d32,`MAC_RAM_ADDR,"RW");
	default_map.add_reg(eth_ram_adr_tx9,`MAC_RAMADR_ADDR,"RW");
	default_map.add_reg(eth_ram_adr_rx9,`MAC_RECADR_ADDR,"RW");
	default_map.add_reg(eth_phy,`MAC_MANCTDAT_ADDR,"RW");

	// add_hdl_path("top.dut.aes");
	lock_model();
endfunction : build

`endif //ETH_REG_BLOCK
