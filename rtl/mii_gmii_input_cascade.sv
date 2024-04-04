module mii_gmii_input_cascade
	(
		input	 logic				reset_i
	,	input	 logic				rx_clk_i
	,	input	 logic				rx_dv_i
	,	input	 logic				rx_en_i
	,	input	 logic [7:0]	rxd_i
	,	input	 logic				rx_er_i

	,	input	 logic				tx_clk_i

	,	input	 logic				col_i
	,	input	 logic				crs_i

	, output logic				rx_dv_o 
	, output logic				rx_en_o
	, output logic [7:0]	rxd_o
	, output logic				rx_er_o
	, output logic				col_rx_o

	, output logic				col_tx_o

	, output logic				crs_o
);

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) rx_dv_o <= 1'b0;
			else	 			 rx_dv_o <= rx_dv_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) rx_en_o <= 1'b0;
			else	 			 rx_en_o <= rx_en_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) rxd_o <= 8'h00;
			else	       rxd_o <= rxd_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) rx_er_o <= 1'b0;
			else	       rx_er_o <= rx_er_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) col_rx_o <= 1'b0;
			else	       col_rx_o <= col_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) col_tx_o <= 1'b0;
			else	       col_tx_o <= col_i;

always_ff @ (posedge rx_clk_i or negedge reset_i)
			if(~reset_i) crs_o <= 1'b0;
			else	       crs_o <= crs_i;

endmodule