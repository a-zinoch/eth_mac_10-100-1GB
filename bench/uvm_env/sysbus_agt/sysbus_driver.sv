`ifndef SYSBUS_DRIVER
`define SYSBUS_DRIVER

class sysbus_driver extends uvm_driver #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	agt_config_sysbus agt_cfg;
	virtual if_sys_bus dut_vi;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(sysbus_driver)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : sysbus_driver


function void sysbus_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(agt_config_sysbus)::get(this, "", "sysbus_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Sysbus agt config not found!")
	end
	dut_vi = agt_cfg.sysbus_vi;
endfunction : build_phase


task sysbus_driver::run_phase(uvm_phase phase);
	forever begin
		sysbus_item tx,rx;

		seq_item_port.get(tx);
		$cast(rx, tx.clone());
		rx.set_id_info(tx);

		if(tx.rst == 1) begin
			dut_vi.sedrd_n = '1;
			dut_vi.edwrh_n = '1;
			dut_vi.edwrl_n = '1;
			dut_vi.pr_adr = '0;
			dut_vi.src = '0;
			dut_vi.rst_n = 0;
			#32ns;
			dut_vi.rst_n = 1;
			continue;
		end

		@(posedge dut_vi.clk);

		case (tx.bus_op)
			BUS_READ: begin
				dut_vi.sedrd_n = '0;
				dut_vi.edwrh_n = '1;
				dut_vi.edwrl_n = '1;
			end
			BUS_LOW_WRITE: begin
				dut_vi.sedrd_n = '1;
				dut_vi.edwrh_n = '1;
				dut_vi.edwrl_n = '0;
				dut_vi.src = tx.data;
			end
			BUS_HI_WRITE: begin
				dut_vi.sedrd_n = '1;
				dut_vi.edwrh_n = '0;
				dut_vi.edwrl_n = '1;
				dut_vi.src = tx.data;
			end
			BUS_WRITE: begin
				dut_vi.sedrd_n = '1;
				dut_vi.edwrh_n = '0;
				dut_vi.edwrl_n = '0;
				dut_vi.src = tx.data;
			end
			BUS_IDLE: begin
				dut_vi.sedrd_n = '1;
				dut_vi.edwrh_n = '1;
				dut_vi.edwrl_n = '1;
			end
			default : begin
				dut_vi.sedrd_n = '1;
				dut_vi.edwrh_n = '1;
				dut_vi.edwrl_n = '1;
			end
		endcase

		dut_vi.pr_adr = tx.addr;

		@(negedge dut_vi.clk);
		rx.addr = dut_vi.pr_adr;
		rx.rx_data = dut_vi.pr_src;
		seq_item_port.put_response(rx);

		@(posedge dut_vi.clk);

		dut_vi.sedrd_n = '1;
		dut_vi.edwrh_n = '1;
		dut_vi.edwrl_n = '1;
		dut_vi.pr_adr = '0;
		dut_vi.src = '0;
	end

endtask : run_phase

`endif //SYSBUS_DRIVER