module	memory_contol_unit 	(reset, sysck, address_cpu,
				 write_address_cpu_tran, int_mem_tran_adr, transmit_ce, cpu_we,
				 write_address_cpu_rec, int_mem_rec_adr, receive_we, cpu_ce,
				 ERR_RAM_REC,
				 adr_mem_tran, adr_mem_rec,
				 ce_mem_rec, ce_mem_tran, rec_OK,
				 clime_read, clime_read_rst_reg,
				 adr_bcp_rec, reset_hard
				 );
input		reset, sysck, reset_hard;
input		write_address_cpu_tran, write_address_cpu_rec;
input		transmit_ce, cpu_we;
input		receive_we, cpu_ce;
input		rec_OK;
input	[8:0]	address_cpu, int_mem_tran_adr, int_mem_rec_adr, adr_bcp_rec;
output		ERR_RAM_REC;
output		ce_mem_rec, ce_mem_tran;
output		clime_read, clime_read_rst_reg;
output	[8:0]	adr_mem_tran, adr_mem_rec;

reg	[8:0]	cpu_adr_rec, cpu_adr_tran;
reg		ERR_RAM_REC;
reg		clime_read_rst_reg, clime_read;
// ***** Form Error RAM signal ***** \\
//wire	[9:0] sum_rec_clime = cpu_adr_rec + 2;
//wire	clime_read_rst_en = (cpu_ce && adr_bcp_rec == sum_rec_clime[8:0])? 1'b1 : 1'b0;
//always @ (posedge reset or posedge sysck)
//	if(reset) clime_read_rst_reg <= 1'b0;
//		else clime_read_rst_reg <= clime_read_rst_en;
//
//wire	clime_read_rst = reset | clime_read_rst_reg;
//always @ (posedge clime_read_rst or posedge rec_OK)
//	if(clime_read_rst) clime_read <= 1'b0;
//		else clime_read <= 1'b1;

//wire	[9:0] sum_rec_clime = cpu_adr_rec + 2;
wire	[9:0] sum_rec_clime = cpu_adr_rec + 1;
wire	clime_read_rst_en = (cpu_ce && adr_bcp_rec == sum_rec_clime[8:0])? 1'b1 : 1'b0;
always @ (negedge reset_hard or posedge sysck)
	if(!reset_hard) clime_read_rst_reg <= 1'b0;
		else clime_read_rst_reg <= clime_read_rst_en;

//wire	clime_read_rst = reset_hard | clime_read_rst_reg;
wire	clime_read_rst = !reset | clime_read_rst_reg;
always @ (posedge clime_read_rst or negedge rec_OK)
	if(clime_read_rst) clime_read <= 1'b0;
		else clime_read <= 1'b1;


// ***** End Form Error RAM signal ***** \\

// ***** Form Error RAM signal ***** \\
wire	[9:0] test_sum_adr = int_mem_rec_adr + 1;
wire	[9:0] test_sum_adr1 = int_mem_rec_adr + 2;
//wire	[9:0] test_sum_adr2 = int_mem_rec_adr + 3;
//wire	test_wire_err_ram = (cpu_adr_rec == int_mem_rec_adr + 1)? 1'b1 : 1'b0;
wire	err_rec_ram_en = (receive_we && ((test_sum_adr[8:0] == cpu_adr_rec) || (test_sum_adr1[8:0] == cpu_adr_rec)))? 1'b1 : 1'b0;
//wire	err_rec_ram_en = (receive_we && int_mem_rec_adr == cpu_adr_rec - 1)? 1'b1 : 1'b0;
//wire	err_rec_ram_en = (receive_we && test_wire_err_ram)? 1'b1 : 1'b0;
always @ (negedge reset_hard or posedge sysck)
	if(!reset_hard) ERR_RAM_REC <= 1'b0;
		else ERR_RAM_REC <= err_rec_ram_en;
//wire	err_rec_ram_en = (cpu_ce && cpu_adr_rec == int_mem_rec_adr)? 1'b1 : 1'b0;
//always @ (posedge reset_hard or posedge sysck)
//	if(reset_hard) ERR_RAM_REC <= 1'b0;
//		else ERR_RAM_REC <= err_rec_ram_en;
// ***** End Form Error RAM signal ***** \\


// ****** Form control Signal for memory ***** \\
wire	[9:0] cpu_adr_rec_inc1 = cpu_adr_rec + 1'b1;
//assign  #0.3 adr_mem_rec = (receive_we)?  int_mem_rec_adr : (rec_OK)? cpu_adr_rec : cpu_adr_rec_inc1[8:0];
assign  #0.3 adr_mem_rec = (receive_we)?  int_mem_rec_adr : (write_address_cpu_rec)? address_cpu : (rec_OK && !clime_read)? cpu_adr_rec : cpu_adr_rec_inc1[8:0];
assign	#0.3 adr_mem_tran = (transmit_ce)?  int_mem_tran_adr : cpu_adr_tran;
assign 	     ce_mem_rec = receive_we | cpu_ce | (rec_OK && !clime_read) | write_address_cpu_rec;
assign 	     ce_mem_tran = transmit_ce | cpu_we;
// ****** End Form control Signal for memory ***** \\


// ***** Form internal address for memory ***** \\
wire 	address_rec0_en = (write_address_cpu_rec)? address_cpu[0] :
		   (cpu_ce)? !cpu_adr_rec[0] : cpu_adr_rec[0];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[0] <= 1'b0;
		else cpu_adr_rec[0] <= address_rec0_en;

wire 	address_rec1_en =   (write_address_cpu_rec)? address_cpu[1] :
			(cpu_ce & cpu_adr_rec[0])? !cpu_adr_rec[1] : cpu_adr_rec[1];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[1] <= 1'b0;
		else cpu_adr_rec[1] <= address_rec1_en;

wire 	address_rec2_en =   (write_address_cpu_rec)? address_cpu[2] :
			(cpu_ce & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[2] : cpu_adr_rec[2];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[2] <= 1'b0;
		else cpu_adr_rec[2] <= address_rec2_en;

wire 	address_rec3_en =   (write_address_cpu_rec)? address_cpu[3] :
			(cpu_ce & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[3] : cpu_adr_rec[3];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[3] <= 1'b0;
		else cpu_adr_rec[3] <= address_rec3_en;

wire 	address_rec4_en =   (write_address_cpu_rec)? address_cpu[4] :
			(cpu_ce & cpu_adr_rec[3] & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[4] : cpu_adr_rec[4];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[4] <= 1'b0;
		else cpu_adr_rec[4] <= address_rec4_en;

wire 	address_rec5_en =   (write_address_cpu_rec)? address_cpu[5] :
			(cpu_ce & cpu_adr_rec[4] & cpu_adr_rec[3] & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[5] : cpu_adr_rec[5];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[5] <= 1'b0;
		else cpu_adr_rec[5] <= address_rec5_en;

wire 	address_rec6_en =   (write_address_cpu_rec)? address_cpu[6] :
			(cpu_ce & cpu_adr_rec[5] & cpu_adr_rec[4] & cpu_adr_rec[3] & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[6] : cpu_adr_rec[6];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[6] <= 1'b0;
		else cpu_adr_rec[6] <= address_rec6_en;

wire 	address_rec7_en =   (write_address_cpu_rec)? address_cpu[7] :
			(cpu_ce & cpu_adr_rec[6] & cpu_adr_rec[5] & cpu_adr_rec[4] & cpu_adr_rec[3] & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[7] : cpu_adr_rec[7];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[7] <= 1'b0;
		else cpu_adr_rec[7] <= address_rec7_en;

wire 	address_rec8_en =   (write_address_cpu_rec)? address_cpu[8] :
			(cpu_ce & cpu_adr_rec[7] & cpu_adr_rec[6] & cpu_adr_rec[5] & cpu_adr_rec[4] & cpu_adr_rec[3] & cpu_adr_rec[2] & cpu_adr_rec[1] & cpu_adr_rec[0])? !cpu_adr_rec[8] : cpu_adr_rec[8];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_rec[8] <= 1'b0;
		else cpu_adr_rec[8] <= address_rec8_en;
// ***** End Form internal address for memory ***** \\

// ***** Form internal address for memory ***** \\
wire address_tran0_en = (write_address_cpu_tran)? address_cpu[0] :
		   (cpu_we)? !cpu_adr_tran[0] : cpu_adr_tran[0];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[0] <= 1'b0;
		else cpu_adr_tran[0] <= address_tran0_en;

wire 	address_tran1_en =   (write_address_cpu_tran)? address_cpu[1] :
			(cpu_we & cpu_adr_tran[0])? !cpu_adr_tran[1] : cpu_adr_tran[1];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[1] <= 1'b0;
		else cpu_adr_tran[1] <= address_tran1_en;

wire 	address_tran2_en =   (write_address_cpu_tran)? address_cpu[2] :
			(cpu_we & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[2] : cpu_adr_tran[2];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[2] <= 1'b0;
		else cpu_adr_tran[2] <= address_tran2_en;

wire 	address_tran3_en =   (write_address_cpu_tran)? address_cpu[3] :
			(cpu_we & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[3] : cpu_adr_tran[3];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[3] <= 1'b0;
		else cpu_adr_tran[3] <= address_tran3_en;

wire 	address_tran4_en =   (write_address_cpu_tran)? address_cpu[4] :
			(cpu_we & cpu_adr_tran[3] & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[4] : cpu_adr_tran[4];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[4] <= 1'b0;
		else cpu_adr_tran[4] <= address_tran4_en;

wire 	address_tran5_en =   (write_address_cpu_tran)? address_cpu[5] :
			(cpu_we & cpu_adr_tran[4] & cpu_adr_tran[3] & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[5] : cpu_adr_tran[5];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[5] <= 1'b0;
		else cpu_adr_tran[5] <= address_tran5_en;

wire 	address_tran6_en =   (write_address_cpu_tran)? address_cpu[6] :
			(cpu_we & cpu_adr_tran[5] & cpu_adr_tran[4] & cpu_adr_tran[3] & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[6] : cpu_adr_tran[6];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[6] <= 1'b0;
		else cpu_adr_tran[6] <= address_tran6_en;

wire 	address_tran7_en =   (write_address_cpu_tran)? address_cpu[7] :
			(cpu_we & cpu_adr_tran[6] & cpu_adr_tran[5] & cpu_adr_tran[4] & cpu_adr_tran[3] & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[7] : cpu_adr_tran[7];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[7] <= 1'b0;
		else cpu_adr_tran[7] <= address_tran7_en;

wire 	address_tran8_en =   (write_address_cpu_tran)? address_cpu[8] :
			(cpu_we & cpu_adr_tran[7] & cpu_adr_tran[6] & cpu_adr_tran[5] & cpu_adr_tran[4] & cpu_adr_tran[3] & cpu_adr_tran[2] & cpu_adr_tran[1] & cpu_adr_tran[0])? !cpu_adr_tran[8] : cpu_adr_tran[8];
always @ (negedge reset or posedge sysck)
	if(!reset) cpu_adr_tran[8] <= 1'b0;
		else cpu_adr_tran[8] <= address_tran8_en;
// ***** End Form internal address for memory ***** \\


endmodule