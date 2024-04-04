`ifndef SYSBUS_MONITOR
`define SYSBUS_MONITOR

class sysbus_monitor extends uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	agt_config_sysbus agt_cfg;
	uvm_analysis_port #(sysbus_item) aport;
	virtual if_sys_bus dut_vi;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(sysbus_monitor)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass : sysbus_monitor

function void sysbus_monitor::build_phase(uvm_phase phase);

	aport = new("aport", this);
	if(!uvm_config_db #(agt_config_sysbus)::get(this, "", "sysbus_agt_cfg", agt_cfg)) begin
		`uvm_error(get_full_name(),"Sysbus agt config not found!")
	end
	dut_vi = agt_cfg.sysbus_vi;

endfunction : build_phase

task sysbus_monitor::run_phase(uvm_phase phase);

	sysbus_item tx;
	tx = sysbus_item::type_id::create("tx");

	forever begin
		@(negedge dut_vi.clk);
		if(dut_vi.rst_n) begin
			tx.addr = dut_vi.pr_adr;
			tx.data = dut_vi.src;

			case ({dut_vi.sedrd_n, dut_vi.edwrh_n, dut_vi.edwrl_n})
				3'b111: begin
					tx.bus_op = BUS_IDLE;
				end
				3'b110: begin
					tx.bus_op = BUS_LOW_WRITE;
				end
				3'b101: begin
					tx.bus_op = BUS_HI_WRITE;
				end
				3'b011: begin
					tx.bus_op = BUS_READ;
					tx.rx_data = dut_vi.pr_src;
				end
				3'b100: begin
					tx.bus_op = BUS_WRITE;
				end
				default : begin
					tx.bus_op = BUS_IDLE;
				end
			endcase

			aport.write(tx);
		end
	end

endtask : run_phase

`endif //SYSBUS_MONITOR