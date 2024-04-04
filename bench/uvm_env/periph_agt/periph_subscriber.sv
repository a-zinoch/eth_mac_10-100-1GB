`ifndef PERIPH_SUBSCRIBER
`define PERIPH_SUBSCRIBER

class periph_subscriber extends uvm_subscriber #(periph_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/

	logic interrupt;

	covergroup eth_periph_cg();
		option.name         = "sysbus_cov";
		option.comment      = "UVM Subscriber";
		option.per_instance = 1;
		coverpoint_int : coverpoint interrupt;
	endgroup : eth_periph_cg

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(periph_subscriber)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_subscriber", uvm_component parent=null);
		super.new(name, parent);
		eth_periph_cg = new;
	endfunction : new

	extern function void write(periph_item t);

endclass : periph_subscriber

function void periph_subscriber::write(periph_item t);
	// `uvm_info("mg", $psprintf("Subscriber received tx %s", t.convert2string()), UVM_NONE);
	interrupt = t.interrupt;
	eth_periph_cg.sample();
endfunction : write

`endif //PERIPH_SUBSCRIBER