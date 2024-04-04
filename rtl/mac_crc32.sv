`timescale 1 ps/ 1 ps
module mac_crc32
  (
      input  logic          clk_i
    , input  logic          reset_i
    , input  logic          crc_en_i  
    , input  logic [ 7:0 ]  data_i
    , output logic [31:0 ]  crc_out_o

  );

logic   [31:0 ] dcd;
logic   [31:0 ] mux_crc;    
logic   [31:0 ] mux_crc_XO;      // XOR OUT
logic   [31:0 ] crc_reg;
// logic   [31:0 ] mux_crc_RO_XO;   // Reverse out and Xor out
// logic   [31:0 ] crc_out_o;

assign dcd = 
{
  
// LE -> 

/*dcd[31] */    crc_reg[1] ^ crc_reg[7] ^ data_i[1] ^ data_i[7]
/*dcd[30] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[6] ^ crc_reg[7] ^ data_i[0] ^ data_i[1] ^ data_i[6] ^ data_i[7]
/*dcd[29] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ data_i[0] ^ data_i[1] ^ data_i[5] ^ data_i[6] ^ data_i[7]
/*dcd[28] */ ,  crc_reg[0] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ data_i[0] ^ data_i[4] ^ data_i[5] ^ data_i[6]
/*dcd[27] */ ,  crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ data_i[1] ^ data_i[3] ^ data_i[4] ^ data_i[5] ^ data_i[7]
/*dcd[26] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ data_i[0] ^ data_i[1] ^ data_i[2] ^ data_i[3] ^ data_i[4] ^ data_i[6] ^ data_i[7]
/*dcd[25] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ data_i[0] ^ data_i[1] ^ data_i[2] ^ data_i[3] ^ data_i[5] ^ data_i[6]
/*dcd[24] */ ,  crc_reg[0] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ data_i[0] ^ data_i[2] ^ data_i[4] ^ data_i[5] ^ data_i[7]
/*dcd[23] */ ,  crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[31] ^ data_i[3] ^ data_i[4] ^ data_i[6] ^ data_i[7]
/*dcd[22] */ ,  crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[30] ^ data_i[2] ^ data_i[3] ^ data_i[5] ^ data_i[6]
/*dcd[21] */ ,  crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[29] ^ data_i[2] ^ data_i[4] ^ data_i[5] ^ data_i[7]
/*dcd[20] */ ,  crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[28] ^ data_i[3] ^ data_i[4] ^ data_i[6] ^ data_i[7]
/*dcd[19] */ ,  crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[27] ^ data_i[1] ^ data_i[2] ^ data_i[3] ^ data_i[5] ^ data_i[6] ^ data_i[7]
/*dcd[18] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[26] ^ data_i[0] ^ data_i[1] ^ data_i[2] ^ data_i[4] ^ data_i[5] ^ data_i[6]
/*dcd[17] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[25] ^ data_i[0] ^ data_i[1] ^ data_i[3] ^ data_i[4] ^ data_i[5]
/*dcd[16] */ ,  crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[24] ^ data_i[0] ^ data_i[2] ^ data_i[3] ^ data_i[4]
/*dcd[15] */ ,  crc_reg[2] ^ crc_reg[3] ^ crc_reg[7] ^ crc_reg[23] ^ data_i[2] ^ data_i[3] ^ data_i[7]
/*dcd[14] */ ,  crc_reg[1] ^ crc_reg[2] ^ crc_reg[6] ^ crc_reg[22] ^ data_i[1] ^ data_i[2] ^ data_i[6]
/*dcd[13] */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[5] ^ crc_reg[21] ^ data_i[0] ^ data_i[1] ^ data_i[5]
/*dcd[12] */ ,  crc_reg[0] ^ crc_reg[4] ^ crc_reg[20] ^ data_i[0] ^ data_i[4]
/*dcd[11] */ ,  crc_reg[3] ^ crc_reg[19] ^ data_i[3]
/*dcd[10] */ ,  crc_reg[2] ^ crc_reg[18] ^ data_i[2]
/*dcd[9]  */ ,  crc_reg[7] ^ crc_reg[17] ^ data_i[7]
/*dcd[8]  */ ,  crc_reg[1] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[16] ^ data_i[1] ^ data_i[6] ^ data_i[7]
/*dcd[7]  */ ,  crc_reg[0] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[15] ^ data_i[0] ^ data_i[5] ^ data_i[6]
/*dcd[6]  */ ,  crc_reg[4] ^ crc_reg[5] ^ crc_reg[14] ^ data_i[4] ^ data_i[5]
/*dcd[5]  */ ,  crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[7] ^ crc_reg[13] ^ data_i[1] ^ data_i[3] ^ data_i[4] ^ data_i[7]
/*dcd[4]  */ ,  crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[6] ^ crc_reg[12] ^ data_i[0] ^ data_i[2] ^ data_i[3] ^ data_i[6]
/*dcd[3]  */ ,  crc_reg[1] ^ crc_reg[2] ^ crc_reg[5] ^ crc_reg[11] ^ data_i[1] ^ data_i[2] ^ data_i[5]
/*dcd[2]  */ ,  crc_reg[0] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[10] ^ data_i[0] ^ data_i[1] ^ data_i[4]
/*dcd[1]  */ ,  crc_reg[0] ^ crc_reg[3] ^ crc_reg[9] ^ data_i[0] ^ data_i[3]
/*dcd[0]  */ ,  crc_reg[2] ^ crc_reg[8] ^ data_i[2]




// BE ->

  // crc_reg[23] ^ crc_reg[29] ^ data_i[5],
  // crc_reg[22] ^ crc_reg[28] ^ crc_reg[31] ^ data_i[4] ^ data_i[7],
  // crc_reg[21] ^ crc_reg[27] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[3] ^ data_i[6] ^ data_i[7],
  // crc_reg[20] ^ crc_reg[26] ^ crc_reg[29] ^ crc_reg[30] ^ data_i[2] ^ data_i[5] ^ data_i[6],
  // crc_reg[19] ^ crc_reg[25] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31] ^ data_i[1] ^ data_i[4] ^ data_i[5] ^ data_i[7],
  // crc_reg[18] ^ crc_reg[24] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ data_i[0] ^ data_i[3] ^ data_i[4] ^ data_i[6],
  // crc_reg[17] ^ crc_reg[26] ^ crc_reg[27] ^ data_i[2] ^ data_i[3],
  // crc_reg[16] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[31] ^ data_i[1] ^ data_i[2] ^ data_i[7],
  // crc_reg[15] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[30] ^ data_i[0] ^ data_i[1] ^ data_i[6],
  // crc_reg[14] ^ crc_reg[24] ^ data_i[0],
  // crc_reg[13] ^ crc_reg[29] ^ data_i[5],
  // crc_reg[12] ^ crc_reg[28] ^ data_i[4],
  // crc_reg[11] ^ crc_reg[27] ^ crc_reg[31] ^ data_i[3] ^ data_i[7],
  // crc_reg[10] ^ crc_reg[26] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[2] ^ data_i[6] ^ data_i[7],
  // crc_reg[9] ^ crc_reg[25] ^ crc_reg[29] ^ crc_reg[30] ^ data_i[1] ^ data_i[5] ^ data_i[6],
  // crc_reg[8] ^ crc_reg[24] ^ crc_reg[28] ^ crc_reg[29] ^ data_i[0] ^ data_i[4] ^ data_i[5],
  // crc_reg[7] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31] ^ data_i[3] ^ data_i[4] ^ data_i[5] ^ data_i[7],
  // crc_reg[6] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[2] ^ data_i[3] ^ data_i[4] ^ data_i[6] ^ data_i[7],
  // crc_reg[5] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[1] ^ data_i[2] ^ data_i[3] ^ data_i[5] ^ data_i[6] ^ data_i[7],
  // crc_reg[4] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ data_i[0] ^ data_i[1] ^ data_i[2] ^ data_i[4] ^ data_i[5] ^ data_i[6],
  // crc_reg[3] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ data_i[0] ^ data_i[1] ^ data_i[3] ^ data_i[4],
  // crc_reg[2] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ data_i[0] ^ data_i[2] ^ data_i[3] ^ data_i[5],
  // crc_reg[1] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ data_i[1] ^ data_i[2] ^ data_i[4] ^ data_i[5],
  // crc_reg[0] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ data_i[0] ^ data_i[1] ^ data_i[3] ^ data_i[4],
  // crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[31] ^ data_i[0] ^ data_i[2] ^ data_i[3] ^ data_i[5] ^ data_i[7],
  // crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[1] ^ data_i[2] ^ data_i[4] ^ data_i[5] ^ data_i[6] ^ data_i[7],
  // crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[0] ^ data_i[1] ^ data_i[3] ^ data_i[4] ^ data_i[5] ^ data_i[6] ^ data_i[7],
  // crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ data_i[0] ^ data_i[2] ^ data_i[3] ^ data_i[4] ^ data_i[6],
  // crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[31] ^ data_i[1] ^ data_i[2] ^ data_i[3] ^ data_i[7],
  // crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[0] ^ data_i[1] ^ data_i[2] ^ data_i[6] ^ data_i[7],
  // crc_reg[24] ^ crc_reg[25] ^ crc_reg[30] ^ crc_reg[31] ^ data_i[0] ^ data_i[1] ^ data_i[6] ^ data_i[7],
  // crc_reg[24] ^ crc_reg[30] ^ data_i[0] ^ data_i[6]
  
  }; 


// assign mux_crc = (crc_en_i) ? {dcd[0],dcd[1],dcd[2],dcd[3],dcd[4],dcd[5],dcd[6],dcd[7]
//                               ,dcd[8],dcd[9],dcd[10],dcd[11],dcd[12],dcd[13],dcd[14],dcd[15]
//                               ,dcd[16],dcd[17],dcd[18],dcd[19],dcd[20],dcd[21],dcd[22],dcd[23]
//                               ,dcd[24],dcd[25],dcd[26],dcd[27],dcd[28],dcd[29],dcd[30],dcd[31]} ^ 32'hFFFF_FFFF  : crc_out_o;

// assign mux_crc = (crc_en_i) ? dcd ^ 32'hFFFF_FFFF : crc_out_o;

assign mux_crc         = (crc_en_i) ? dcd : crc_out_o;

assign mux_crc_XO      = (crc_en_i) ? dcd ^ 32'hFFFF_FFFF : crc_out_o; // YEEEEES

// assign mux_crc_RO_XO   = (crc_en_i) ? {dcd[0],dcd[1],dcd[2],dcd[3],dcd[4],dcd[5],dcd[6],dcd[7]
//                                       ,dcd[8],dcd[9],dcd[10],dcd[11],dcd[12],dcd[13],dcd[14],dcd[15]
//                                       ,dcd[16],dcd[17],dcd[18],dcd[19],dcd[20],dcd[21],dcd[22],dcd[23]
//                                       ,dcd[24],dcd[25],dcd[26],dcd[27],dcd[28],dcd[29],dcd[30],dcd[31]} ^ 32'hFFFF_FFFF  : crc_out_o;



always_ff @ (posedge clk_i or negedge reset_i) 
    // if(!reset_i) crc_out_o <= 32'hFFFF_FFFF;
    // else crc_out_o <= mux_crc;

    // else crc_out_o <= {mux_crc[0],mux_crc[1],mux_crc[2],mux_crc[3],mux_crc[4],mux_crc[5],mux_crc[6],mux_crc[7]
                      // ,mux_crc[8],mux_crc[9],mux_crc[10],mux_crc[11],mux_crc[12],mux_crc[13],mux_crc[14],mux_crc[15]
                      // ,mux_crc[16],mux_crc[17],mux_crc[18],mux_crc[19],mux_crc[20],mux_crc[21],mux_crc[22],mux_crc[23]
                      // ,mux_crc[24],mux_crc[25],mux_crc[26],mux_crc[27],mux_crc[28],mux_crc[29],mux_crc[30],mux_crc[31]} ^ 32'hFFFF_FFFF;
    // if(!reset_i) begin crc_out_RO_XO_o <= 32'hFFFF_FFFF; crc_out_XO_o <= 32'hFFFF_FFFF; crc_out_o <= 32'hFFFF_FFFF; end
    // else begin crc_out_RO_XO_o <= mux_crc_RO_XO; crc_out_XO_o <= mux_crc_XO; crc_out_o <= mux_crc; end

    if (!reset_i) crc_out_o <= 32'hFFFF_FFFF;
    else begin    crc_out_o <= mux_crc_XO; crc_reg <= mux_crc; end
endmodule
