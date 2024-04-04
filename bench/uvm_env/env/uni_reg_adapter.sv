`ifndef UNI_REG_ADAPTER
`define UNI_REG_ADAPTER

class uni_reg_adapter extends uvm_reg_adapter;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(uni_reg_adapter)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "uni_reg_adapter");
		super.new(name);
		provides_responses = 1;
	endfunction : new

	extern function uvm_sequence_item reg2bus( const ref uvm_reg_bus_op rw );
	extern function void bus2reg( uvm_sequence_item bus_item,ref uvm_reg_bus_op rw );
endclass : uni_reg_adapter

function uvm_sequence_item uni_reg_adapter::reg2bus( const ref uvm_reg_bus_op rw );
	sysbus_item tx_item = sysbus_item::type_id::create("tx_item");

	if ( rw.kind == UVM_READ )
		tx_item.bus_op = BUS_READ;
	else if(rw.kind == UVM_WRITE)
		tx_item.bus_op = BUS_WRITE;
	else
		tx_item.bus_op = BUS_IDLE;

	if ( rw.kind == UVM_WRITE ) begin
		tx_item.addr = rw.addr;
		tx_item.data = rw.data;
	end else begin
		tx_item.addr = rw.addr;
		tx_item.data = '0;
	end

	tx_item.rst = '0;

	//`uvm_info(get_full_name(),tx_item.convert2string(),UVM_NONE)
	return tx_item;
endfunction : reg2bus

function void uni_reg_adapter::bus2reg( uvm_sequence_item bus_item,ref uvm_reg_bus_op rw );
	sysbus_item rx_item;

	if ( ! $cast( rx_item, bus_item ) ) begin
		`uvm_fatal( get_name(), "bus_item is not of the sysbus_item type." )
		return;
	end

	if(rx_item.bus_op == BUS_READ) begin
		//`uvm_info(get_full_name(),rx_item.convert2string(),UVM_NONE)
		rw.kind = UVM_READ;
		rw.addr = rx_item.addr;
		rw.data = rx_item.rx_data;
	end else if(rx_item.bus_op == BUS_WRITE) begin
		//`uvm_info(get_full_name(),rx_item.convert2string(),UVM_NONE)
		rw.kind = UVM_WRITE;
		rw.addr = rx_item.addr;
		rw.data = rx_item.data;
	end

	rw.status = UVM_IS_OK;
endfunction : bus2reg

`endif //UNI_REG_ADAPTER