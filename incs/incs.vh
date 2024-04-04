`ifndef INCS
`define INCS
    `include "kmx32/ifaces/if_sys_bus.vh"
    `include "kmx32/ifaces/if_dma_bus.vh"

// ======================= Main Block =============

    `include "rtl/eth_top.sv"

    `include "rtl/MDI_new_.v"
    `include "rtl/mac_top.sv"
    `include "rtl/mac_control_block.sv"
    `include "rtl/interface_mac_kmx.sv"
    `include "rtl/mii_gmii_input_cascade.sv"
    `include "rtl/mac_crc32.sv"
    // `include "rtl/mem_contr.v"
    // `include "rtl/read_block.v"
    `include "rtl/mac_mii_gmii_receiver.sv"
    `include "rtl/mac_mii_gmii_transmitter.sv"
    `include "rtl/ts1ge512x32m4_220a_tc.v"                                                        //library
    `include "rtl/ts1ge3072x32m8_220a_tc.v"                                                        //library
    `include "rtl/ff_fifo.sv"

// ====================== Additional MII==============
    // `include "bench/mii_active_phy.v"
    // `include "bench/mii_passive.v"

// ====================== Additional GMII==============

    `include "bench/gmii_active_phy.v"
    `include "bench/gmii_passive.v"

`endif //INCS

