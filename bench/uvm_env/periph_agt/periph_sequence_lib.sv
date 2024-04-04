`ifndef PERIPH_SEQUENCE_LIB
`define PERIPH_SEQUENCE_LIB

class periph_mon_seq extends uvm_sequence #(periph_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	periph_packet periph_pkt;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(periph_mon_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "periph_mon_seq");
		super.new(name);
	endfunction : new


	task body;
		periph_item tx,rx;

		tx = periph_item::type_id::create("tx");
		
		if(periph_pkt.mdio_int) begin
			tx.mdio_int = '0;
		end else begin
			tx.mdio_int = '1;
		end

		start_item(tx);
		finish_item(tx);
		get_response(rx);

		periph_pkt.eth_interrupt = rx.interrupt;
	endtask: body

endclass : periph_mon_seq

`endif //PERIPH_SEQUENCE_LIB