`ifndef ETH_SCOREBOARD
`define ETH_SCOREBOARD

class scoreboard extends uvm_scoreboard;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_imp#(sysbus_item, scoreboard) item_collected_export;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(scoreboard)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);
	extern function void write(sysbus_item t);
	extern function void write_analys(sysbus_item t);
	extern function void read_analys(sysbus_item t);
endclass : scoreboard

function void scoreboard::build_phase(uvm_phase phase);
	item_collected_export = new("item_collected_export", this);
endfunction : build_phase

function void scoreboard::report_phase(uvm_phase phase);

endfunction : report_phase

function void scoreboard::write(sysbus_item t);
	// `uvm_info("mg", $psprintf("Subscriber received tx %s", t.convert2string()), UVM_NONE);
	return;
endfunction : write

function void scoreboard::write_analys(sysbus_item t);
	return;
endfunction : write_analys


function void scoreboard::read_analys(sysbus_item t);
	return;
endfunction : read_analys

`endif //ETH_SCOREBOARD
