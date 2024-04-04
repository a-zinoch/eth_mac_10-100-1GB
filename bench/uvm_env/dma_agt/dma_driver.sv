`ifndef DMA_DRIVER
`define DMA_DRIVER

class dma_driver extends uvm_driver #(dma_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	agt_config_dmabus agt_cfg;
	virtual if_dma_bus dut_vi;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(dma_driver)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : dma_driver


function void dma_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(agt_config_dmabus)::get(this, "", "dmabus_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"DMA bus agt config not found!")
	end
	dut_vi = agt_cfg.dmabus_vi;
endfunction : build_phase


task dma_driver::run_phase(uvm_phase phase);
	forever begin
		dma_item tx,rx;

		seq_item_port.get(tx);
		$cast(rx, tx.clone());
		rx.set_id_info(tx);

		dut_vi.wr_data = tx.wr_data;

		@(posedge dut_vi.clk);
		dut_vi.grant = tx.grant;

		@(negedge dut_vi.clk);
		rx.addr = dut_vi.addr;
		rx.rd_data = dut_vi.rd_data;
		rx.en_clk = dut_vi.en_clk;
		rx.rqst = dut_vi.rqst;
		rx.ce = dut_vi.ce;
		rx.we = dut_vi.we;
		rx.oe = dut_vi.oe;

		seq_item_port.put_response(rx);
	end

endtask : run_phase

`endif //DMA_DRIVER