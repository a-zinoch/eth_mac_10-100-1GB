`ifndef SYSBUS_SUBSCRIBER
`define SYSBUS_SUBSCRIBER

class sysbus_subscriber extends uvm_subscriber #(sysbus_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/

	logic [`PAW-1:0] addr;
	logic [31:0] data;
	bus_op_t op;

	covergroup crc_cg();
		option.name         = "sysbus_cov";
		option.comment      = "UVM Subscriber";
		option.per_instance = 1;
		coverpoint_op : coverpoint op;
		coverpoint_addr : coverpoint addr;
		coverpoint_data : coverpoint data;
	endgroup : crc_cg

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(sysbus_subscriber)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_subscriber", uvm_component parent=null);
		super.new(name, parent);
		crc_cg = new;
	endfunction : new

	extern function void write(sysbus_item t);

endclass : sysbus_subscriber

function void sysbus_subscriber::write(sysbus_item t);
	// `uvm_info("mg", $psprintf("Subscriber received tx %s", t.convert2string()), UVM_NONE);
	op  = t.bus_op;
	addr = t.addr;
	data = t.data;
	crc_cg.sample();
endfunction : write

`endif //SYSBUS_SUBSCRIBER
