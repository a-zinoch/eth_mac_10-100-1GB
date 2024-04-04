`ifndef DMA_MEM_TYPES
`define DMA_MEM_TYPES

typedef enum
{
	DMA_MEM_OK,
	DMA_MEM_FAIL
}dma_mem_status_t;

typedef enum
{
	DMA_MEM_WRITE,
	DMA_MEM_READ
}dma_mem_op_t;

typedef struct
{
	dma_mem_op_t mem_op;
	dma_mem_status_t st;
	int adr;
	int unsigned data;
}dma_mem_t;


`endif //DMA_MEM_TYPES