`ifndef DEFINES
`define DEFINES

	`define			RAMAW		          		14 				// ширина шины АДРЕСА памяти RAM - байтовая адресация = log2(RAM_SIZE)
	`define			PERIPH_ADDR_WIDTH     9 				// то же самое для периферии
	`define			PAW 			     				9
	`define			DMA_ADR_WIDTH		   		14
	`define			DMA_DAT_WIDTH		   		32

	// MAC ETH
	`define  		MAC_MCOM_ADDR					'h90   //MAC_MCOM 		adr FFFC01A0
	`define  		MAC_TYPE_ADDR  		    'h91   //MAC_TYPE		adr FFFC01A4
	`define  		MAC_QNT_ADDR  		    'h92   //MAC_QNT		adr FFFC01A8
	`define  		MAC_RAM_ADDR					'h93   //MAC_RAM		adr FFFC01AC
	`define  		MAC_CARD_L_ADDR  	    'h94   //MAC_CARD_L 	adr FFFC01B0
	`define  		MAC_CARD_H_ADDR 	    'h95   //MAC_CARD_H		adr FFFC01B4
	`define  		MAC_MANCTDAT_ADDR	    'h96   //MAC_MANCTDAT	adr FFFC01C0
	`define  		MAC_MANADR_ADDR  	    'h97   //MAC_MANADR		adr FFFC01C4
	`define  		MAC_RAMADR_ADDR  	    'h98   //MAC_RAMADR		adr FFFC01C8
	`define  		MAC_RECADR_ADDR  	    'h99   //MAC_RECADR		adr FFFC01CC	
	`define	    MAC_DMA_ADR_ADDR			'h9A


	`define  		TB_SYSCLK_HPER			40ns//10ns
	`define  		TB_PHYTX_HPER				8ns//15.45ns
	`define  		TB_PHYRX_HPER				8ns//15.45ns
	`define  		TB_PHYMD_HPER			100ns

	`ifdef TEST_1

		// `define   		DUT_MAC_ADR    			48'h234F_A35B_8A44
		// `define   		VIP_MAC_ADR    			48'h448A_5BA3_4F23

		`define   	DUT_MAC_ADR    			48'h458A_5BA3_4F23
		`define   	VIP_MAC_ADR    			48'h458A_5BA3_4F23
		`define 		MDIO_ENABLE
		`define 		ERROR_ENABLE
		// `define 		PROT_ERROR_EN
		`define 		ERROR_RATIO				20
		 // `define 		DMA_READ_EN
		// `define 		UPPER_LEVEL_PKT
		`define 		FULL_DUPLEX
		`define 		PACKET_COUNT			50			
	`elsif TEST_2
		
		// `define   		DUT_MAC_ADR    			48'h234F_A35B_8A44
		// `define   		VIP_MAC_ADR    			48'h448A_5BA3_4F23
		
		`define   	DUT_MAC_ADR    			48'h458A_5BA3_4F23
		`define   	VIP_MAC_ADR    			48'h458A_5BA3_4F23
		`define 		MDIO_ENABLE
		`define 		ERROR_ENABLE
		`define 		PROT_ERROR_EN
		`define 		ERROR_RATIO				20
		`define 		DMA_READ_EN
		// `define 		UPPER_LEVEL_PKT
		`define 		FULL_DUPLEX
		`define 		PACKET_COUNT			300				
	`elsif TEST_3
		
		// `define   		DUT_MAC_ADR    			48'h234F_A35B_8A44
		// `define   		VIP_MAC_ADR    			48'h448A_5BA3_4F23
		
		`define   	DUT_MAC_ADR    			48'h458A_5BA3_4F23
		`define   	VIP_MAC_ADR    			48'h458A_5BA3_4F23
		// `define 		MDIO_ENABLE
		`define 		ERROR_ENABLE
		// `define 		PROT_ERROR_EN
		`define 		ERROR_RATIO				20
		// `define 		DMA_READ_EN
		// `define 		UPPER_LEVEL_PKT
		// `define 		FULL_DUPLEX
		`define 		PACKET_COUNT			300				
	`elsif TEST_4
		
		// `define   		DUT_MAC_ADR    			48'h234F_A35B_8A44
		// `define   		VIP_MAC_ADR    			48'h448A_5BA3_4F23
		
		`define   	DUT_MAC_ADR    			48'h458A_5BA3_4F23
		`define   	VIP_MAC_ADR    			48'h458A_5BA3_4F23
		// `define 		MDIO_ENABLE
		`define 		ERROR_ENABLE
		`define 		PROT_ERROR_EN
		`define 		ERROR_RATIO				20
		// `define 		DMA_READ_EN
		// `define 		UPPER_LEVEL_PKT
		// `define 		FULL_DUPLEX
		`define 		PACKET_COUNT			100					
	`endif			
`endif //DEFINES
