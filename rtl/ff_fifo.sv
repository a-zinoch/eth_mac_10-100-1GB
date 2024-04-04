module ff_fifo

#( parameter  
     width = 8
    ,depth = 32
 )(
     input                clk_i 
    ,input                reset_i
    ,input                push_i
    ,input                pop_i 
    ,input  [width - 1:0] wrd_i       
    ,output [width - 1:0] rdd_o
    ,output               empty_o 
    ,output               full_o
 );

// ==================================================

localparam 
                              ptr_width   = $clog2 (depth)
                             ,cnt_width   = $clog2 (depth + 1);
localparam [cnt_width - 1:0]  max_ptr     = cnt_width' (depth - 1);


logic [ptr_width - 1:0] wr_ptr, rd_ptr;
logic [cnt_width - 1:0] cnt;


reg [width - 1:0] data [depth - 1: 0];

// ==================================================
always @ (posedge clk_i or negedge reset_i) begin
  if (~reset_i)
    wr_ptr <= 'b0;
  else if(push_i)
    wr_ptr <= wr_ptr == max_ptr ? 'b0 : wr_ptr + 1'b1; 
end

// ==================================================

always @ (posedge clk_i or negedge reset_i) begin
  if (~reset_i)
    rd_ptr <= 'b0;
  else if(pop_i)
    rd_ptr <= rd_ptr == max_ptr ? 'b0 : rd_ptr + 1'b1; 
end

always @ (posedge clk_i) begin
  if (push_i)
    data[wr_ptr] <= wrd_i;
end

assign rdd_o = data[rd_ptr];

// ==================================================

always @ (posedge clk_i) begin
  if (~reset_i)
    cnt <= '0;
  else if (push_i & ~ pop_i)
    cnt <= cnt + 1'b1;
  else if (pop_i & ~ push_i)
    cnt <= cnt - 1'b1;
end

// ==================================================

assign empty_o = ~| cnt;

assign full_o = & cnt;

endmodule 