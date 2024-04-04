`ifndef SYSBUS_ITEM
`define SYSBUS_ITEM

typedef enum
{
	BUS_READ,
	BUS_WRITE,
	BUS_HI_WRITE,
	BUS_LOW_WRITE,
	BUS_IDLE
}bus_op_t;

class sysbus_item extends uvm_sequence_item;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand int addr;
	rand int data;
	rand bus_op_t bus_op;
	rand bit rst;

	int rx_data;

	constraint c_addr { addr >= 0; addr <= 1<<`PAW; }
	constraint c_data { data >= 0; data <= 32'hFFFF_FFFF; }
	constraint c_bus_op { bus_op inside {BUS_READ,BUS_HI_WRITE,BUS_LOW_WRITE,BUS_WRITE,BUS_IDLE}; }
	constraint c_rst { rst inside {[0:1]};}
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(sysbus_item)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "sysbus_item");
		super.new(name);
	endfunction : new

	function string convert2string;
		return $psprintf("bus op=%s, addr=%d, t_data=%0d, r_data=%d", bus_op.name(), addr, data, rx_data);
	endfunction: convert2string

endclass : sysbus_item


`endif //SYSBUS_ITEM