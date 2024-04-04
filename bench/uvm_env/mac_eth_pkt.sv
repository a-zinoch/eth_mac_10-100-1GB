`ifndef MAC_ETH_PKT
`define MAC_ETH_PKT


typedef struct
{
	int size;
	int unsigned byte_size;
	int unsigned status;
	int unsigned pkt_type;
	bit [47:0] src_adr;
	bit [47:0] dst_adr;
	int data[];
}mac_eth_pkt_t;

class mac_eth_fifo extends uvm_object;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mac_eth_pkt_t fifo[];
	int unsigned size;
	int unsigned head; 
	int unsigned tail;
	bit full;
	bit non_empty;

	semaphore sema; 
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(mac_eth_fifo)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mac_eth_fifo");
		super.new(name);
	endfunction : new

	extern function void init(int unsigned sz);
	extern function bit push_pkt(mac_eth_pkt_t pkt);
	extern function mac_eth_pkt_t pop_pkt();
endclass : mac_eth_fifo


function void mac_eth_fifo::init(int unsigned sz);
	full = 0;
	non_empty = 0;
	size = sz;
	fifo = new[sz];
	head = 0;
	tail = 0;
	sema = new(1);
endfunction : init

function bit mac_eth_fifo::push_pkt(mac_eth_pkt_t pkt);
	sema.get(1);
	if(!full) begin
		fifo[head] = pkt;

		head = head + 1;

		if(head == size)
			head = 0;

		if(head == tail) begin
			//tail = tail + 1;
			//if(tail == size)
			//	tail = 0;
			full = 1;
		end

		non_empty = 1;
		`uvm_info("fifo_push",$psprintf("Fifo head = %d tail = %d size = %d full %d non_empty %d type %x",head,tail,size,full,non_empty, pkt.pkt_type),UVM_NONE);
		sema.put(1);
		return 1;
	end else begin
		sema.put(1);
		return 0;
	end
endfunction : push_pkt

function mac_eth_pkt_t mac_eth_fifo::pop_pkt();
	mac_eth_pkt_t pkt;
	sema.get(1);
	if(non_empty) begin
		pkt = fifo[tail];

		tail = tail + 1;

		if(tail == size)
			tail = 0;

		if(tail == head) begin
			non_empty = 0;
		end else begin
			non_empty = 1;
		end

		full = 0;

		`uvm_info("fifo_pop",$psprintf("Fifo head = %d tail = %d size = %d full %d non_empty %d type %x",head,tail,size,full,non_empty,pkt.pkt_type),UVM_NONE);
		sema.put(1);
		return pkt;
	end else begin
		pkt.status = 'hFFFF_FFFF;

		sema.put(1);
		return pkt;
	end
endfunction : pop_pkt

function int little2big(int world);
	int result = 0;
	result = {world[23:16],world[31:24],world[7:0],world[15:8]};
	return result;
endfunction : little2big

function int big2little(int world);
	int result = 0;
	result = {world[23:16],world[31:24],world[7:0],world[15:8]};
	return result;
endfunction : big2little

function int check_pkt(mac_eth_pkt_t pkt);

	int packet_type = 0;

	packet_type = pkt.pkt_type;

	if(pkt.pkt_type == 'h0081) begin //VLAN_TAGED
		packet_type = (pkt.data[0] & 'hFFFF_0000) >> 16;
		`uvm_info("Packet checker",$psprintf("Packet type: %x", packet_type), UVM_MEDIUM);
	end

	if(pkt.pkt_type == 'hA888) begin //VLAN_D_TAGED
		packet_type = (pkt.data[1] & 'hFFFF_0000) >> 16;
		`uvm_info("Packet checker",$psprintf("Packet type: %x", packet_type), UVM_MEDIUM);
	end

	// `uvm_warning("Packet checker",$psprintf("Packet type: %x", packet_type));

	if(packet_type == 'h7088 || pkt.pkt_type == 'h7088) begin //JUMBO
		if(pkt.byte_size < 60 || pkt.byte_size > 9000) begin
			return -1;
		end else begin
			return 0;
		end
	end
	if(pkt.byte_size < 60 || pkt.byte_size > 1514) begin
		`uvm_warning("Packet checker",$psprintf("Incorrect size of packet: %x", pkt.byte_size));
		return -1;
	end

	return 0;
endfunction : check_eth_pkt


`endif //MAC_ETH_PKT
