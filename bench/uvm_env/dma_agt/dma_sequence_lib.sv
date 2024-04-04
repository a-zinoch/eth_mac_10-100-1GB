`ifndef DMA_SEQUENCE_LIB
`define DMA_SEQUENCE_LIB

class dma_mem_seq extends uvm_sequence #(dma_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	dma_mem_block mem_block;
	int unsigned data = 0;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(dma_mem_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "dma_mem_seq");
		super.new(name);
	endfunction : new

	task body;
		dma_item tx,rx;
		dma_mem_t rw;
		uvm_tlm_time delay = new;

		tx = dma_item::type_id::create("tx");
		start_item(tx);
		assert( tx.randomize() with {grant == 0; wr_data == data;});
		finish_item(tx);
		get_response(rx);
		while (rx.rqst) begin
			start_item(tx);
			if(rx.en_clk && !rx.ce) begin
				if(!rx.we && !$isunknown(rx.we)) begin //write
					rw.mem_op = DMA_MEM_WRITE;
					rw.adr = rx.addr;
					rw.data = rx.rd_data;
					rw = mem_block.memory(rw);
					assert( tx.randomize() with {grant == 1; wr_data == data;});
					//get_response(rx);
				end else if(!rx.oe && !$isunknown(rx.oe)) begin //read
					rw.mem_op = DMA_MEM_READ;
					rw.adr = rx.addr;
					rw = mem_block.memory(rw);
					data = rw.data;
					assert( tx.randomize() with {grant == 1; wr_data == data;});
				end else begin
					assert( tx.randomize() with {grant == 1; wr_data == data;});
				end
			end else begin
				// assert( tx.randomize() with {grant dist { 0 := 1, 1 := 3}; wr_data == 0;});
				assert( tx.randomize() with {grant == 1; wr_data == data;});
			end
			finish_item(tx);
			get_response(rx);
		end

	endtask: body

endclass : dma_mem_seq

`endif //DMA_SEQUENCE_LIB