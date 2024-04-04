`ifndef SYSBUS_SEQUENCE_LIB
`define SYSBUS_SEQUENCE_LIB

typedef enum
{
	MAC_DMA_EN		=	'h100,
	MAC_COL_DIS		=	'h80,
	MAC_PHY_IE		=	'h40,
	MAC_IRQ_TX		=	'h20,
	MAC_IRQ_RX		=	'h10,
	MAC_RST			=	'h08,
	MAC_PROMISC		=	'h04,
	MAC_RX_START	= 	'h02
}eth_mcom_e;

typedef enum
{
	MAC_PKG_BUF			=	'h400,
	MAC_BCAST			=	'h200,
	MAC_MCAST			=	'h100,
	MAC_PHY_IRQ			=	'h80,
	MAC_RX_BUFFER_ERR 	=	'h40,
	MAC_TX_ERR			=	'h20,
	MAC_RX_COL_ERR		=	'h10,
	MAC_REC_CRC_ERR		= 	'h08,
	MAC_RX_DATA_ERR		= 	'h04,
	MAC_PKG_READY		=	'h02,
	MAC_TX_STATUS		=	'h01
}eth_stat_e;

typedef enum
{
	ETH_IP4_FRAME			=	'h0800, //Internet Protocol version 4 (IPv4)
	ETH_ARP_FRAME			=	'h0806, //Address Resolution Protocol (ARP)
	ETH_WAKE_FRAME			=	'h0842, //Wake-on-LAN[3]
	ETH_AUDIO_VIDEO_FRAME	=	'h22F0, //Audio Video Transport Protocol as defined in IEEE Std 1722-2011
	ETH_IETF_FRAME			=	'h22F3, //IETF TRILL Protocol
	ETH_DECNET_FRAME		=	'h6003, //DECnet Phase IV
	ETH_RAR_FRAME			=	'h8035, //Reverse Address Resolution Protocol
	ETH_APPLE_FRAME			=	'h809B, //AppleTalk (Ethertalk)
	ETH_APPLE_ARP_FRAME		=	'h80F3, //AppleTalk Address Resolution Protocol (AARP)
	ETH_VLAN_FRAME			=	'h8100, //VLAN-tagged frame (IEEE 802.1Q) & Shortest Path Bridging IEEE 802.1aq[4]
	ETH_IPX_FRAME			=	'h8137, //IPX
	ETH_IPX2_FRAME			=	'h8138, //IPX
	ETH_QNX_FRAME			=	'h8204, //QNX Qnet
	ETH_IP6_FRAME			=	'h86DD, //Internet Protocol Version 6 (IPv6)
	ETH_FLOW_CTL_FRAME		=	'h8808, //Ethernet flow control
	ETH_SLOW_FRAME			=	'h8809, //Slow Protocols (IEEE 802.3)
	ETH_COBRANET_FRAME		=	'h8819, //CobraNet
	ETH_MPLS_UNI_FRAME		=	'h8847, //MPLS unicast
	ETH_MPLS_MULTI_FRAME	=	'h8848, //MPLS multicast
	ETH_PPPOE_DISC_FRAME	=	'h8863, //PPPoE Discovery Stage
	ETH_PPPOE_SESS_FRAME	=	'h8864, //PPPoE Session Stage
	ETH_JUMBO_FRAME			=	'h8870, //Jumbo Frames[2]
	ETH_HOMEPLUG_FRAME		=	'h887B, //HomePlug 1.0 MME
	ETH_EAP_FRAME			=	'h888E, //EAP over LAN (IEEE 802.1X)
	ETH_PROFINET_FRAME		=	'h8892, //PROFINET Protocol
	ETH_SCSI_FRAME			=	'h889A, //HyperSCSI (SCSI over Ethernet)
	ETH_ATA_FRAME			=	'h88A2, //ATA over Ethernet
	ETH_ETHERCAT_FRAME		=	'h88A4, //EtherCAT Protocol
	ETH_SPB_FRAME			=	'h88A8, //Provider Bridging (IEEE 802.1ad) & Shortest Path Bridging IEEE 802.1aq[5]
	ETH_POWERLINK_FRAME		=	'h88AB, //Ethernet Powerlink[citation needed]
	ETH_LLD_FRAME			=	'h88CC, //Link Layer Discovery Protocol (LLDP)
	ETH_SERCOS_FRAME		=	'h88CD, //SERCOS III
	ETH_MME_FRAME			=	'h88E1, //HomePlug AV MME[citation needed]
	ETH_MRP_FRAME			=	'h88E3, //Media Redundancy Protocol (IEC62439-2)
	ETH_MAC_SEC_FRAME		=	'h88E5, //MAC security (IEEE 802.1AE)
	ETH_PBB_FRAME			=	'h88E7, //Provider Backbone Bridges (PBB) (IEEE 802.1ah)
	ETH_PTP_FRAME			=	'h88F7, //Precision Time Protocol (PTP) over Ethernet (IEEE 1588)
	ETH_CFM_FRAME			=	'h8902, //IEEE 802.1ag Connectivity Fault Management (CFM) Protocol / ITU-T Recommendation Y.1731 (OAM)
	ETH_FCOE_FRAME			=	'h8906, //Fibre Channel over Ethernet (FCoE)
	ETH_FCOE_INIT_FRAME		=	'h8914, //FCoE Initialization Protocol
	ETH_ROCE_FRAME			=	'h8915, //RDMA over Converged Ethernet (RoCE)
	ETH_HSR_FRAME			=	'h892F, //High-availability Seamless Redundancy (HSR)
	ETH_ECT_FRAME			=	'h9000, //Ethernet Configuration Testing Protocol[6]
	ETH_LLT_FRAME			=	'hCAFE  //Veritas Low Latency Transport (LLT)[7] for Veritas Cluster Server
}eth_pkt_type_e;

typedef struct{
	bit MRC; //31
	bit MWC; //30
	bit MDCLK_EN; //28 
	bit [4:0] PHYAD; //21
	bit [4:0] ADR; //16
	bit [15:0] DATA; //0
}eth_mdio_pkt_t;

class sysbus_rw_seq extends uvm_sequence #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand int n;
	constraint how_many { n inside {[0:100]}; }
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(sysbus_rw_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_rw_seq");
		super.new(name);
	endfunction : new


	task body;
		sysbus_item tx;

		tx = sysbus_item::type_id::create("tx");

		repeat(n) begin
			start_item(tx);
			assert( tx.randomize() with {rst == 0;});
			finish_item(tx);
		end

	endtask: body

endclass : sysbus_rw_seq

class sysbus_rand_seq extends uvm_sequence #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand int adr_low,adr_hi;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(sysbus_rand_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_rand_seq");
		super.new(name);
	endfunction : new


	task body;
		sysbus_item tx;

		tx = sysbus_item::type_id::create("tx");

		start_item(tx);
		assert( tx.randomize() with {addr >= adr_low; addr <= adr_hi; rst == 0;});
		finish_item(tx);

	endtask: body

endclass : sysbus_rand_seq


class sysbus_rst_seq extends uvm_sequence #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(sysbus_rst_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_rst_seq");
		super.new(name);
	endfunction : new


	task body;
		sysbus_item tx;

		tx = sysbus_item::type_id::create("tx");

		start_item(tx);
		assert( tx.randomize() with {rst == 1;});
		finish_item(tx);

	endtask: body

endclass : sysbus_rst_seq

class eth_init_seq extends uvm_reg_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	periph_packet periph_pkt;
	int unsigned dma_adr = 'h00;
	rand bit op_kind; // 0 - sysbus; 1 - dma
	logic [47:0] mac_adr = `DUT_MAC_ADR;	

	constraint op_kind_c {op_kind inside {[0:1]};}
	// constraint op_kind_c {op_kind == 0;}

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_init_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_init_seq");
		super.new(name);
	endfunction : new

	task body;
		eth_reg_block model;
		uvm_status_e status;
		uvm_reg_data_t value;

		$cast(model, this.model);

		write_reg(model.eth_mcom,status,MAC_RST);

		/*Записать адрес области памяти в регистр MAC_DMA_ADR, в которую будет записан корректно принятый пакет*/
		write_reg(model.eth_dma_adr,status,dma_adr);

		/*Установка MAC адресса*/
		// assert(this.randomize());
		write_reg(model.eth_card_l,status,mac_adr&'hFF_FF_FF);
		write_reg(model.eth_card_h,status,(mac_adr>>24)&'hFF_FF_FF);

		`ifdef FULL_DUPLEX
			if(op_kind == 1)
				write_reg(model.eth_mcom,status, MAC_COL_DIS+MAC_DMA_EN+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);
			else
				write_reg(model.eth_mcom,status,MAC_COL_DIS+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);
		`else 
			if(op_kind == 1)
				write_reg(model.eth_mcom,status,MAC_COL_DIS+MAC_DMA_EN+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);
			else
				write_reg(model.eth_mcom,status,MAC_COL_DIS+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);
		`endif

	endtask: body

endclass : eth_init_seq

class eth_rx_seq extends uvm_reg_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mac_eth_pkt_t mac_eth_pkt;
	periph_packet periph_pkt;
	bit op_kind, test_finish = 0;
	logic [11:0] dma_addr = '0;
	mac_eth_fifo fifo;

	//int unsigned n = 50;
	rand int unsigned n;
	constraint how_many {n >= 0;} // if n == 0 then receiving will be infinity
	dma_mem_block dma_mem;
	dma_mem_t dma_op;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_rx_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_rx_seq");
		super.new(name);
	endfunction : new

	task body;
		eth_reg_block model;

		uvm_status_e status;
		uvm_reg_data_t value;

		int unsigned err_mask = MAC_RX_BUFFER_ERR|MAC_RX_COL_ERR|MAC_REC_CRC_ERR|MAC_RX_DATA_ERR;
		bit new_pkt;
		int unsigned err, dma_pkt_counter;

		$cast(model, this.model);
		#1000ns;

		/*Read mod dma/sysbus*/
		read_reg(model.eth_mcom, status, value);
		op_kind = (value&MAC_DMA_EN) >> 8;
		//op_kind = 1;
		if(op_kind) begin
			`uvm_info(get_full_name(),"Receiving will be in DMA mode.",UVM_MEDIUM);
		end else begin
			`uvm_info(get_full_name(),"Receiving will be in SYSBUS mode.",UVM_MEDIUM);
		end

		if(n == 0)
			n = 'hFFFF_FFFF; //+- infinity 

		repeat(n) begin

			if(dma_pkt_counter == 0) begin
				if(op_kind) begin
					dma_pkt_counter = 1;
				end else begin
					dma_pkt_counter = 0;
				end
				new_pkt = 0;
			end else begin
				new_pkt = 1;
			end

			if(!op_kind) begin
				read_reg(model.eth_stat, status, value);
				if(value&MAC_PKG_BUF) begin
					new_pkt = 1;
				end
			end

			while(!new_pkt) begin
				if(periph_pkt.eth_interrupt)
					@(negedge periph_pkt.eth_interrupt);

				read_reg(model.eth_stat, status, value);
				err = value & (
					MAC_RX_BUFFER_ERR |
					//MAC_TX_ERR |
					MAC_RX_COL_ERR |
					MAC_REC_CRC_ERR |
					MAC_RX_DATA_ERR
					);

				if(err) begin
					write_reg(model.eth_ram_adr_rx9,status,0);
					`uvm_warning(get_full_name(),$psprintf("Hardware error cathed! (%x)", value));
				end else begin
					if(op_kind) begin
						new_pkt = ((value&MAC_PKG_READY)>>1) & !((value&MAC_PKG_BUF)>>10);
						if(((value&MAC_PKG_READY)>>1) & ((value&MAC_PKG_BUF)>>10)) begin
							dma_pkt_counter ++;
							// `uvm_error(get_full_name(), $psprintf("+++++++++++++ %x", dma_pkt_counter));
						end
					end else begin
						new_pkt = ((value&MAC_PKG_READY)>>1) | ((value&MAC_PKG_BUF)>>10);
					end
					@(posedge periph_pkt.eth_interrupt);
				end
			end
			
			`uvm_info(get_full_name(),"New packet recivied.",UVM_MEDIUM);

			if(op_kind) begin
				`uvm_error(get_full_name(), $psprintf("Packet counter %x", dma_pkt_counter));
				dma_pkt_counter--;

				dma_op.mem_op = DMA_MEM_READ;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);

				assert (!$isunknown(dma_op.data[31:16])) 
				if(dma_op.data[31:16] < 4) begin
					write_reg(model.eth_dma_adr, status, 'h0);
					dma_addr = 'h0;
					continue;
				end/*
				end else begin
					`uvm_fatal(get_full_name(),  $psprintf("Hernya kakayato %x   %x", dma_addr, dma_op.data));
				end
				assert ();*/

				mac_eth_pkt.size = dma_op.data[31:16] - 3;
				`uvm_info("DMA", $psprintf("Pkt lenght %x", mac_eth_pkt.size), UVM_MEDIUM);
				mac_eth_pkt.byte_size = dma_op.data[15:0];

				dma_op.mem_op = DMA_MEM_READ;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.status = dma_op.data;
				`uvm_info("DMA", $psprintf("MAC status %x", mac_eth_pkt.status), UVM_MEDIUM);

				mac_eth_pkt.dst_adr = 0;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.dst_adr = mac_eth_pkt.dst_adr | (dma_op.data&'hFFFF_0000)<<16;

				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.dst_adr = (mac_eth_pkt.dst_adr) | (dma_op.data&'hFFFF_FFFF);
				`uvm_info("DMA", $psprintf("DST address %x", mac_eth_pkt.dst_adr), UVM_MEDIUM);

				mac_eth_pkt.src_adr = 0;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (dma_op.data&'hFFFF_FFFF)<<16;

				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (dma_op.data&'hFFFF);
				`uvm_info("DMA", $psprintf("SRC address %x", mac_eth_pkt.src_adr), UVM_MEDIUM);

				mac_eth_pkt.pkt_type = 0;
				mac_eth_pkt.pkt_type = (dma_op.data&'hFFFF_0000) >> 16;
				`uvm_info("DMA", $psprintf("Type %x", mac_eth_pkt.pkt_type), UVM_MEDIUM);

				mac_eth_pkt.data = new[mac_eth_pkt.size];
				assert( mac_eth_pkt.data.size == mac_eth_pkt.size);

				for (int unsigned i = 0; i < (mac_eth_pkt.size); i++) begin
					dma_addr = dma_addr + 1;
					dma_op.adr = dma_addr;
					dma_op = dma_mem.memory(dma_op);
					mac_eth_pkt.data[i] = dma_op.data;
				end

				dma_addr++;

				if(!dma_pkt_counter) begin
					write_reg(model.eth_dma_adr, status, 'h0);
					dma_addr = 'h0;
				end else begin
					`uvm_warning("DMA", $psprintf("dma_addr %x", dma_addr));
				end
			end else begin
				read_reg(model.eth_ram_d32, status, value);
				/*minus dst and src addres*/

				// assert (value[31:16] > 4 && !$isunknown(value[31:16]));

				assert (!$isunknown(value[31:16])) 
				if(value[31:16] < 4) begin
					int unsigned size = value[31:16] + 1;
					// `uvm_error(get_full_name(), $psprintf("Worst packet %x",size));
					for(int z = 0; z <= size; z ++) begin
						read_reg(model.eth_ram_d32, status, value);
					end
					write_reg(model.eth_ram_adr_rx9,status,0);
					continue;
				end

				mac_eth_pkt.size = value[31:16] - 3;
				`uvm_info("sysbus", $psprintf("Pkt lenght %x", mac_eth_pkt.size), UVM_MEDIUM);
				mac_eth_pkt.byte_size = value[15:0];

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.status = value;
				`uvm_info("sysbus", $psprintf("MAC status %x", mac_eth_pkt.status), UVM_MEDIUM);

				mac_eth_pkt.dst_adr = 0;
				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.dst_adr = mac_eth_pkt.dst_adr | (value&'hFFFF_0000)<<16;

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.dst_adr = (mac_eth_pkt.dst_adr) | (value&'hFFFF_FFFF);
				`uvm_info("sysbus", $psprintf("DST address %x", mac_eth_pkt.dst_adr), UVM_MEDIUM);

				mac_eth_pkt.src_adr = 0;
				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (value&'hFFFF_FFFF)<<16;

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (value&'hFFFF);
				`uvm_info("sysbus", $psprintf("SRC address %x", mac_eth_pkt.src_adr), UVM_MEDIUM);

				mac_eth_pkt.pkt_type = 0;
				mac_eth_pkt.pkt_type = (value&'hFFFF_0000) >> 16;
				`uvm_info("sysbus", $psprintf("Type %x", mac_eth_pkt.pkt_type), UVM_MEDIUM);

				mac_eth_pkt.data = new[mac_eth_pkt.size];
				for (int i = 0; i < (mac_eth_pkt.size); i++) begin
					read_reg(model.eth_ram_d32, status, value);
					mac_eth_pkt.data[i] = value;
				end
			end

			if(check_pkt(mac_eth_pkt) == 0) begin
				assert(fifo.push_pkt(mac_eth_pkt));				
			end else begin
				`uvm_warning(get_full_name() ,"Software error cathed");
			end
		end
		test_finish = 1;
	endtask: body

endclass : eth_rx_seq

class eth_tx_seq extends uvm_reg_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	periph_packet periph_pkt;
	mac_eth_pkt_t mac_eth_pkt;
	mac_eth_fifo fifo;
	logic [47:0] mac_adr;
	int err;

	rand int unsigned n;
	constraint how_many {n >= 0;} // if n == 0 then transmitting will be infinity	
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_tx_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_tx_seq");
		super.new(name);
	endfunction : new

	task body;
		eth_reg_block model;
		uvm_status_e status;
		uvm_reg_data_t value;
		bit transfer_cmpl = 0;
		$cast(model, this.model);
		#1000ns;

		if(n == 0)
			n = 'hFFFF_FFFF; //+- infinity

		repeat(n) begin
			//if fifo is empty then wait new recievied pkt 
			if(!fifo.non_empty)
				@(posedge fifo.non_empty);

			mac_eth_pkt = fifo.pop_pkt();
			err = mac_eth_pkt.status & (MAC_RX_BUFFER_ERR |
				MAC_TX_ERR |
				MAC_RX_COL_ERR |
				MAC_REC_CRC_ERR |
				MAC_RX_DATA_ERR);

			/*check error flags. if err = 0 send pkt back*/
			if(!err) begin
				value = mac_eth_pkt.byte_size;
				write_reg(model.eth_ram_d32, status, value);
				`uvm_info("feedback", $psprintf("Pkt Size %x", value), UVM_MEDIUM);

				/*write dst addr*/
				write_reg(model.eth_ram_d32, status, (mac_eth_pkt.src_adr&'hFFFF_0000));
				write_reg(model.eth_ram_d32, status, {mac_eth_pkt.src_adr[15:0], mac_eth_pkt.src_adr[47:32]});
				`uvm_info("feedback", $psprintf("DST adr: %x", mac_eth_pkt.src_adr), UVM_MEDIUM);

				if( mac_adr == 48'hFFFF_FFFF_FFFF) begin
					write_reg(model.eth_ram_d32, status, ('h0>>15)&'hFFFF_FFFF);
					write_reg(model.eth_ram_d32, status, (mac_eth_pkt.pkt_type<<16 | ('h0 & 'hFFFF)));
					`uvm_info("feedback", $psprintf("SRC adr: %x Pkt type: %x", 'h0, mac_eth_pkt.pkt_type), UVM_MEDIUM);
				end else begin
					write_reg(model.eth_ram_d32, status, mac_adr[31:0]);
					write_reg(model.eth_ram_d32, status, (mac_eth_pkt.pkt_type<<16 | (mac_adr[47:32])));
					`uvm_info("feedback", $psprintf("SRC adr: %x Pkt type: %x", mac_adr,mac_eth_pkt.pkt_type), UVM_MEDIUM);
				end

				/*write data*/
				for (int i = 0; i < (mac_eth_pkt.size); i++) begin
					write_reg(model.eth_ram_d32, status, mac_eth_pkt.data[i]);
				end

				/*start transmit*/
				write_reg(model.eth_start_tx, status, 'h01);
				`uvm_info(get_full_name(),"Packet sended!",UVM_MEDIUM);

				/*wait while transmiting not comlite*/
				do begin
					@(negedge periph_pkt.eth_interrupt);
					#20ns;
					read_reg(model.eth_stat, status, value);
					transfer_cmpl = (value&'h01);
				end while(transfer_cmpl); 
			end
		end
	endtask: body

endclass : eth_tx_seq


class eth_half_duplex_seq extends uvm_reg_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	dma_mem_block dma_mem;
	periph_packet periph_pkt;
	mac_eth_pkt_t mac_eth_pkt;
	uvm_status_e status;
	bit test_finish = 0;

	logic [11:0] dma_addr = '0;
	rand bit op_kind; // 0 - sysbus; 1 - dma
	rand logic [23:0] card_l,card_h;
	rand int n;
	dma_mem_t dma_op;

	constraint op_kind_c {op_kind inside {[0:1]};}
	// constraint op_kind_c {op_kind == 0;}
	constraint card_l_c {card_l == 'h167A_DB;}
	constraint card_h_c {card_h == 'hF9_D4EF;}
	//constraint how_many {n == 1;}
	constraint how_many {n > 0;}
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_half_duplex_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_half_duplex_seq");
		super.new(name);
	endfunction : new

	task body;
		eth_reg_block model;
		uvm_status_e status;
		uvm_reg_data_t value;
		bit new_pkt = 0;
		bit transfer_cmpl = 0;
		int unsigned err,data;
		int unsigned pause_time;

		$cast(model, this.model);

		write_reg(model.eth_mcom,status,MAC_RST);

		/*Записать адрес области памяти в регистр MAC_DMA_ADR, в которую будет записан корректно принятый пакет*/
		write_reg(model.eth_dma_adr,status,dma_addr);

		/*Установка MAC адресса*/
		assert(this.randomize());
		write_reg(model.eth_card_l,status,card_l&'hFF_FF_FF);
		write_reg(model.eth_card_h,status,(card_h>>24)&'hFF_FF_FF);

		if(op_kind == 1)
			write_reg(model.eth_mcom,status,MAC_DMA_EN+MAC_COL_DIS+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);
		else
			write_reg(model.eth_mcom,status,MAC_COL_DIS+MAC_IRQ_TX+MAC_IRQ_RX+MAC_RX_START);

		#500ns;

		repeat(n) begin
				do begin
					@(negedge periph_pkt.eth_interrupt);
					#30ns;
					read_reg(model.eth_stat, status, value);
					err = value & (
						MAC_RX_BUFFER_ERR |
						//MAC_TX_ERR |
						MAC_RX_COL_ERR |
						MAC_REC_CRC_ERR |
						MAC_RX_DATA_ERR
						);
					if(err) begin
						write_reg(model.eth_ram_adr_rx9,status,0);
						`uvm_warning(get_full_name(),"Error occured!");
					end
					new_pkt = (value&MAC_PKG_READY)>>1;
				end while(!new_pkt);
			`uvm_info(get_full_name(),"New packet recivied.",UVM_MEDIUM);

			if(op_kind) begin
				dma_op.mem_op = DMA_MEM_READ;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);

				mac_eth_pkt.size = dma_op.data[31:16] - 3;
				`uvm_info("DMA", $psprintf("Pkt lenght %x", mac_eth_pkt.size), UVM_MEDIUM);
				mac_eth_pkt.byte_size = dma_op.data[15:0];

				dma_op.mem_op = DMA_MEM_READ;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.status = dma_op.data;
				`uvm_info("DMA", $psprintf("MAC status %x", mac_eth_pkt.status), UVM_MEDIUM);

				mac_eth_pkt.dst_adr = 0;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.dst_adr = mac_eth_pkt.dst_adr | (dma_op.data&'hFFFF_0000)<<16;

				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.dst_adr = (mac_eth_pkt.dst_adr) | (dma_op.data&'hFFFF_FFFF);
				`uvm_info("DMA", $psprintf("DST address %x", mac_eth_pkt.dst_adr), UVM_MEDIUM);

				mac_eth_pkt.src_adr = 0;
				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (dma_op.data&'hFFFF_FFFF)<<16;

				dma_addr = dma_addr + 1;
				dma_op.adr = dma_addr;
				dma_op = dma_mem.memory(dma_op);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (dma_op.data&'hFFFF);
				`uvm_info("DMA", $psprintf("SRC address %x", mac_eth_pkt.src_adr), UVM_MEDIUM);

				mac_eth_pkt.pkt_type = 0;
				mac_eth_pkt.pkt_type = (dma_op.data&'hFFFF_0000) >> 16;
				`uvm_info("DMA", $psprintf("Type %x", mac_eth_pkt.pkt_type), UVM_MEDIUM);

				mac_eth_pkt.data = new[mac_eth_pkt.size];
				for (int i = 0; i < (mac_eth_pkt.size); i++) begin
					dma_addr = dma_addr + 1;
					dma_op.adr = dma_addr;
					dma_op = dma_mem.memory(dma_op);
					mac_eth_pkt.data[i] = dma_op.data;
				end
				dma_addr = dma_addr + 1;
			end else begin
				read_reg(model.eth_ram_d32, status, value);
				/*minus dst and src addres*/
				mac_eth_pkt.size = value[31:16] - 3;
				`uvm_info("sysbus", $psprintf("Pkt lenght %x", mac_eth_pkt.size), UVM_MEDIUM);
				mac_eth_pkt.byte_size = value[15:0];

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.status = value;
				`uvm_info("sysbus", $psprintf("MAC status %x", mac_eth_pkt.status), UVM_MEDIUM);

				mac_eth_pkt.dst_adr = 0;
				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.dst_adr = mac_eth_pkt.dst_adr | (value&'hFFFF_0000)<<16;

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.dst_adr = (mac_eth_pkt.dst_adr) | (value&'hFFFF_FFFF);
				`uvm_info("sysbus", $psprintf("DST address %x", mac_eth_pkt.dst_adr), UVM_MEDIUM);

				mac_eth_pkt.src_adr = 0;
				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (value&'hFFFF_FFFF)<<16;

				read_reg(model.eth_ram_d32, status, value);
				mac_eth_pkt.src_adr = mac_eth_pkt.src_adr | (value&'hFFFF);
				`uvm_info("sysbus", $psprintf("SRC address %x", mac_eth_pkt.src_adr), UVM_MEDIUM);

				mac_eth_pkt.pkt_type = 0;
				mac_eth_pkt.pkt_type = (value&'hFFFF_0000) >> 16;
				`uvm_info("sysbus", $psprintf("Type %x", mac_eth_pkt.pkt_type), UVM_MEDIUM);

				mac_eth_pkt.data = new[mac_eth_pkt.size];
				for (int i = 0; i < (mac_eth_pkt.size); i++) begin
					read_reg(model.eth_ram_d32, status, value);
					mac_eth_pkt.data[i] = value;
				end
			end

			if(check_pkt(mac_eth_pkt) != 0) begin
				`uvm_warning(get_full_name() ,"Software error cathed");
				continue;
			end

			if(big2little(mac_eth_pkt.pkt_type) ==  ETH_FLOW_CTL_FRAME) begin
				`uvm_info("feedback", "Flow control packet detected!", UVM_MEDIUM);
				data = big2little(mac_eth_pkt.data[0][15:0]);
				if(data == 'h0001) begin //PAUSE PACKET
					pause_time = big2little(mac_eth_pkt.data[0][31:16]);
					`uvm_info("feedback", $psprintf("Pause time is %x", pause_time), UVM_MEDIUM);
					#3000ns; // pause imitation
				end
				continue;
			end

			err = mac_eth_pkt.status & (MAC_RX_BUFFER_ERR |
				MAC_TX_ERR |
				MAC_RX_COL_ERR |
				MAC_REC_CRC_ERR |
				MAC_RX_DATA_ERR);

			/*check error flags. if err = 0 send pkt back*/
			if(!err) begin
				value = mac_eth_pkt.byte_size;
				write_reg(model.eth_ram_d32, status, value);
				`uvm_info("feedback", $psprintf("Pkt Size %x", value), UVM_MEDIUM);

				/*write dst addr*/
				write_reg(model.eth_ram_d32, status, (mac_eth_pkt.dst_adr>>15)&'hFFFF_0000);
				write_reg(model.eth_ram_d32, status, mac_eth_pkt.dst_adr&'hFFFF_FFFF);
				`uvm_info("feedback", $psprintf("DST adr: %x", mac_eth_pkt.dst_adr), UVM_MEDIUM);

				write_reg(model.eth_ram_d32, status, ({card_h,card_l}/*mac_eth_pkt.src_adr*/>>15)&'hFFFF_FFFF);
				write_reg(model.eth_ram_d32, status, (mac_eth_pkt.pkt_type<<16 | ({card_h,card_l}/*mac_eth_pkt.src_adr*/&'hFFFF)));
				`uvm_info("feedback", $psprintf("SRC adr: %x Pkt type: %x", mac_eth_pkt.src_adr,mac_eth_pkt.pkt_type), UVM_MEDIUM);

				/*write data*/
				for (int i = 0; i < (mac_eth_pkt.size); i++) begin
					write_reg(model.eth_ram_d32, status, mac_eth_pkt.data[i]);
					// write_reg(model.eth_ram_d32, status, 'h0);
				end

				/*start transmit*/
				write_reg(model.eth_start_tx, status, 'h01);
				`uvm_info(get_full_name(),"Packet sended!",UVM_MEDIUM);

				/*wait while transmiting not comlite*/
				do begin
					@(negedge periph_pkt.eth_interrupt);
					#90ns;
					read_reg(model.eth_stat, status, value);
					transfer_cmpl = (value&'h01);
				end while(transfer_cmpl); 
			end else begin
				`uvm_warning(get_full_name(),$psprintf("Hardware error cathed! (%x)", value));
			end
		end
		`uvm_info("Half duplex test", "Test is completed!", UVM_MEDIUM);
		test_finish = 1;

	endtask: body

endclass : eth_half_duplex_seq

class eth_mdio_seq extends uvm_reg_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	periph_packet periph_pkt;
	uvm_status_e status;
	bit op_kind; // 1 - write; 0 - read
	rand bit [15:0] phy_regs [32]; 

	// constraint phy_regs_c {phy_regs >= 0;}
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(eth_mdio_seq)
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "eth_mdio_seq");
		super.new(name);
	endfunction : new

	task phy_req(eth_reg_block model,ref eth_mdio_pkt_t mdio_pkt);
		uvm_reg_data_t value;

		bit busy = 1;

		if(mdio_pkt.MRC == mdio_pkt.MWC) begin
			`uvm_info("MDIO SEQ", $psprintf("Invalid operation!"), UVM_MEDIUM);
		end

		value = '0;
		value = (mdio_pkt.MRC << 31) |
				(mdio_pkt.MWC << 30) |
				(mdio_pkt.MDCLK_EN << 28) |
				(mdio_pkt.PHYAD << 21) |
				(mdio_pkt.ADR << 16) |
				(mdio_pkt.DATA);

		write_reg(model.eth_phy,status,value);

		while(busy) begin
			if(mdio_pkt.MRC) begin
				read_reg(model.eth_phy,status,value);
				busy = (value>>31)&'h01; 
			end else begin
				read_reg(model.eth_phy,status,value);
				busy = (value>>30)&'h01; 
			end
			#50000ns;
		end
		
		if(mdio_pkt.MRC) begin
			read_reg(model.eth_phy,status,value);
			mdio_pkt.DATA = value;
		end

	endtask

	task body();
		eth_reg_block model;
		uvm_status_e status;
		uvm_reg_data_t value;
		eth_mdio_pkt_t mdio_pkt;

		$cast(model, this.model);

		#1000ns;

		assert(this.randomize());

		mdio_pkt.MWC = 1;
		mdio_pkt.MRC = 0;
		mdio_pkt.MDCLK_EN = 1;
		mdio_pkt.PHYAD = '0;

		/*init register*/
		for (int i = 2; i < 32; i++) begin
			mdio_pkt.ADR = i;
			mdio_pkt.DATA = phy_regs[i];
			phy_req(model,mdio_pkt);
		end

		mdio_pkt.MWC = 0;
		mdio_pkt.MRC = 1;
		mdio_pkt.MDCLK_EN = 1;
		mdio_pkt.PHYAD = '0;

		for (int i = 2; i < 32; i++) begin
			mdio_pkt.ADR = i;
			phy_req(model,mdio_pkt);
			`uvm_info("MDIO SEQ", $psprintf("Read value from reg %x is %x",mdio_pkt.ADR,mdio_pkt.DATA), UVM_MEDIUM);			
			// assert(mdio_pkt.DATA == 'hA5A5) begin
			// 	`uvm_warning("MDIO SEQ","MDIO Read/Write Error!");
			// end
		end

	endtask : body

endclass : eth_mdio_seq

`endif //SYSBUS_SEQUENCE_LIB
