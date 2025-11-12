<<<<<<< HEAD
`include "./include/AXI_define.svh"


// connect with AXI BUS and DMA
module DMA_wrapper(
    input ACLK,
    input ARESETn,
	output DMA_interrupt,

    /* Master Interface*/
    output logic 							ARVALID_M,
    output logic 	[`AXI_ADDR_BITS-1:0] 	ARADDR_M,
	output logic 	[`AXI_ID_BITS-1:0]		ARID_M,
	output logic	[`AXI_LEN_BITS-1:0]		ARLEN_M,
	output logic 	[`AXI_SIZE_BITS-1:0] 	ARSIZE_M,
	output logic 	[1:0]					ARBURST_M,
	input ARREADY_M,

	input 									RID_M,
	input 			[`AXI_DATA_BITS-1:0] 	RDATA_M,
	input 			[1:0]					RRESP_M,
	input 									RLAST_M,
	input									RVALID_M,
	output RREADY_M,

	output logic 							AWVALID_M,
	output logic 	[`AXI_ADDR_BITS-1:0] 	AWADDR_M,
	output logic 	[`AXI_ID_BITS-1:0] 		AWID_M,
	output logic 	[`AXI_LEN_BITS-1:0] 	AWLEN_M,
	output logic 	[`AXI_SIZE_BITS-1:0] 	AWSIZE_M,
	output logic 	[1:0]					AWBURST_M,
	input AWREADY_M,

	output logic 							WVALID_M,
	output logic 	[`AXI_DATA_BITS-1:0] 	WDATA_M,
	output logic 	[`AXI_STRB_BITS-1:0] 	WSTRB_M,
	output logic							WLAST_M,
	input WREADY_M,
						
	input			[`AXI_ID_BITS-1:0] 		BID_M,
	input 			[1:0]					BRESP_M,
	input 									BVALID_M,
	output BREADY_M,

	/* Slave Interface*/
	input 		 							ARVALID_S,
    input 		 	[`AXI_ADDR_BITS-1:0] 	ARADDR_S,
	input 		 	[`AXI_ID_BITS-1:0]		ARID_S,
	input 			[`AXI_LEN_BITS-1:0]		ARLEN_S,
	input 		 	[`AXI_SIZE_BITS-1:0] 	ARSIZE_S,
	input 		 	[1:0]					ARBURST_S,
	output ARREADY_S,

	output logic							RID_S,
	output logic	[`AXI_DATA_BITS-1:0] 	RDATA_S,
	output logic	[1:0]					RRESP_S,
	output logic							RLAST_S,
	output logic							RVALID_S,
	input RREADY_S,

	input		 							AWVALID_S,
	input		 	[`AXI_ADDR_BITS-1:0] 	AWADDR_S,
	input		 	[`AXI_ID_BITS-1:0] 		AWID_S,
	input		 	[`AXI_LEN_BITS-1:0] 	AWLEN_S,
	input		 	[`AXI_SIZE_BITS-1:0] 	AWSIZE_S,
	input		 	[1:0]					AWBURST_S,
	output logic AWREADY_S,

	input		 							WVALID_S,
	input		 	[`AXI_DATA_BITS-1:0] 	WDATA_S,
	input		 	[`AXI_STRB_BITS-1:0] 	WSTRB_S,
	input									WLAST_S,
	output logic WREADY_S,
						
	output logic	[`AXI_ID_BITS-1:0] 		BID_S,
	output logic	[1:0]					BRESP_S,
	output logic							BVALID_S,
	input BREADY_S

);


wire 				R_req;
wire 	[31:0]		AR_ADDR;
wire 	[31:0]		R_DATA;
wire 				R_valid;

wire 				W_req;
wire 	[31:0]		AW_ADDR;
wire 	[31:0] 		W_DATA;
wire				W_done;

wire				CEB;
wire				WEB;
wire	[6:0]		A;
wire	[31:0]		DI;
wire 	[31:0]		DO;


DMA_M Master(
    .ACLK(ACLK),
    .ARESETn(ARESETn),


    .ARVALID_M(ARVALID_M),
    .ARADDR_M(ARADDR_M),
	.ARID_M(ARID_M),
	.ARLEN_M(ARLEN_M),
	.ARSIZE_M(ARSIZE_M),
	.ARBURST_M(ARBURST_M),
	.ARREADY_M(ARREADY_M),


	.RID_M(RID_M),
	.RDATA_M(RDATA_M),
	.RRESP_M(RRESP_M),
	.RLAST_M(RLAST_M),
	.RVALID_M(RVALID_M),
	.RREADY_M(RREADY_M),


	.AWVALID_M(AWVALID_M),
	.AWADDR_M(AWADDR_M),
	.AWID_M(AWID_M),
	.AWLEN_M(AWLEN_M),
	.AWSIZE_M(AWSIZE_M),
	.AWBURST_M(AWBURST_M),
	.AWREADY_M(AWREADY_M),


	.WVALID_M(WVALID_M),
	.WDATA_M(WDATA_M),
	.WSTRB_M(WSTRB_M),
	.WLAST_M(WLAST_M),
	.WREADY_M(WREADY_M),


	.BID_M(BID_M),
	.BRESP_M(BRESP_M),
	.BVALID_M(BVALID_M),
	.BREADY_M(BREADY_M),


    .R_req(R_req),
	.DMA_R_ADDR(AR_ADDR),
	.DMA_R_DATA(R_DATA),
	.R_valid(R_valid),

	.W_req(W_req),
	.DMA_W_ADDR(AW_ADDR),
	.DMA_W_DATA(W_DATA),
	.W_done(W_done)

);

DMA_S Slave(
    .ACLK(ACLK),
    .ARESETn(ARESETn),

	/* Slave Interface*/
	.ARVALID_S(ARVALID_S),
    .ARADDR_S(ARADDR_S),
	.ARID_S(ARID_S),
	.ARLEN_S(ARLEN_S),
	.ARSIZE_S(ARSIZE_S),
	.ARBURST_S(ARBURST_S),
	.ARREADY_S(ARREADY_S),

	.RID_S(RID_S),
	.RDATA_S(RDATA_S),
	.RRESP_S(RRESP_S),
	.RLAST_S(RLAST_S),
	.RVALID_S(RVALID_S),
	.RREADY_S(RREADY_S),

	.AWVALID_S(AWVALID_S),
	.AWADDR_S(AWADDR_S),
	.AWID_S(AWID_S),
	.AWLEN_S(AWLEN_S),
	.AWSIZE_S(AWSIZE_S),
	.AWBURST_S(AWBURST_S),
	.AWREADY_S(AWREADY_S),

	.WVALID_S(WVALID_S),
	.WDATA_S(WDATA_S),
	.WSTRB_S(WSTRB_S),
	.WLAST_S(WLAST_S),
	.WREADY_S(WREADY_S),
						
	.BID_S(BID_S),
	.BRESP_S(BRESP_S),
	.BVALID_S(BVALID_S),
	.BREADY_S(BREADY_S),

	.CEB(CEB),
	.WEB(WEB),
	.A(A),
	.DI(DI),
	.DO(DO)

);


DMA DMA(
	.clk(ACLK),
	.rst(~ARESETn),
	.DMA_interrupt(DMA_interrupt),

	.R_req(R_req),
	.AR_ADDR(AR_ADDR),
	.R_DATA(R_DATA),
	.R_valid(R_valid),

	.W_req(W_req),
	.AW_ADDR(AW_ADDR),
	.W_DATA(W_DATA),
	.W_done(W_done),

	.CEB(CEB),
	.WEB(WEB),
	.A(A),
	.DI(DI),
	.DO(DO)

);

=======
`include "./include/AXI_define.svh"


// connect with AXI BUS and DMA
module DMA_wrapper(
    input ACLK,
    input ARESETn,
	output DMA_interrupt,

    /* Master Interface*/
    output logic 							ARVALID_M,
    output logic 	[`AXI_ADDR_BITS-1:0] 	ARADDR_M,
	output logic 	[`AXI_ID_BITS-1:0]		ARID_M,
	output logic	[`AXI_LEN_BITS-1:0]		ARLEN_M,
	output logic 	[`AXI_SIZE_BITS-1:0] 	ARSIZE_M,
	output logic 	[1:0]					ARBURST_M,
	input ARREADY_M,

	input 									RID_M,
	input 			[`AXI_DATA_BITS-1:0] 	RDATA_M,
	input 			[1:0]					RRESP_M,
	input 									RLAST_M,
	input									RVALID_M,
	output RREADY_M,

	output logic 							AWVALID_M,
	output logic 	[`AXI_ADDR_BITS-1:0] 	AWADDR_M,
	output logic 	[`AXI_ID_BITS-1:0] 		AWID_M,
	output logic 	[`AXI_LEN_BITS-1:0] 	AWLEN_M,
	output logic 	[`AXI_SIZE_BITS-1:0] 	AWSIZE_M,
	output logic 	[1:0]					AWBURST_M,
	input AWREADY_M,

	output logic 							WVALID_M,
	output logic 	[`AXI_DATA_BITS-1:0] 	WDATA_M,
	output logic 	[`AXI_STRB_BITS-1:0] 	WSTRB_M,
	output logic							WLAST_M,
	input WREADY_M,
						
	input			[`AXI_ID_BITS-1:0] 		BID_M,
	input 			[1:0]					BRESP_M,
	input 									BVALID_M,
	output BREADY_M,

	/* Slave Interface*/
	input 		 							ARVALID_S,
    input 		 	[`AXI_ADDR_BITS-1:0] 	ARADDR_S,
	input 		 	[`AXI_ID_BITS-1:0]		ARID_S,
	input 			[`AXI_LEN_BITS-1:0]		ARLEN_S,
	input 		 	[`AXI_SIZE_BITS-1:0] 	ARSIZE_S,
	input 		 	[1:0]					ARBURST_S,
	output ARREADY_S,

	output logic							RID_S,
	output logic	[`AXI_DATA_BITS-1:0] 	RDATA_S,
	output logic	[1:0]					RRESP_S,
	output logic							RLAST_S,
	output logic							RVALID_S,
	input RREADY_S,

	input		 							AWVALID_S,
	input		 	[`AXI_ADDR_BITS-1:0] 	AWADDR_S,
	input		 	[`AXI_ID_BITS-1:0] 		AWID_S,
	input		 	[`AXI_LEN_BITS-1:0] 	AWLEN_S,
	input		 	[`AXI_SIZE_BITS-1:0] 	AWSIZE_S,
	input		 	[1:0]					AWBURST_S,
	output logic AWREADY_S,

	input		 							WVALID_S,
	input		 	[`AXI_DATA_BITS-1:0] 	WDATA_S,
	input		 	[`AXI_STRB_BITS-1:0] 	WSTRB_S,
	input									WLAST_S,
	output logic WREADY_S,
						
	output logic	[`AXI_ID_BITS-1:0] 		BID_S,
	output logic	[1:0]					BRESP_S,
	output logic							BVALID_S,
	input BREADY_S

);


wire 				R_req;
wire 	[31:0]		AR_ADDR;
wire 	[31:0]		R_DATA;
wire 				R_valid;

wire 				W_req;
wire 	[31:0]		AW_ADDR;
wire 	[31:0] 		W_DATA;
wire				W_done;

wire				CEB;
wire				WEB;
wire	[6:0]		A;
wire	[31:0]		DI;
wire 	[31:0]		DO;


DMA_M Master(
    .ACLK(ACLK),
    .ARESETn(ARESETn),


    .ARVALID_M(ARVALID_M),
    .ARADDR_M(ARADDR_M),
	.ARID_M(ARID_M),
	.ARLEN_M(ARLEN_M),
	.ARSIZE_M(ARSIZE_M),
	.ARBURST_M(ARBURST_M),
	.ARREADY_M(ARREADY_M),


	.RID_M(RID_M),
	.RDATA_M(RDATA_M),
	.RRESP_M(RRESP_M),
	.RLAST_M(RLAST_M),
	.RVALID_M(RVALID_M),
	.RREADY_M(RREADY_M),


	.AWVALID_M(AWVALID_M),
	.AWADDR_M(AWADDR_M),
	.AWID_M(AWID_M),
	.AWLEN_M(AWLEN_M),
	.AWSIZE_M(AWSIZE_M),
	.AWBURST_M(AWBURST_M),
	.AWREADY_M(AWREADY_M),


	.WVALID_M(WVALID_M),
	.WDATA_M(WDATA_M),
	.WSTRB_M(WSTRB_M),
	.WLAST_M(WLAST_M),
	.WREADY_M(WREADY_M),


	.BID_M(BID_M),
	.BRESP_M(BRESP_M),
	.BVALID_M(BVALID_M),
	.BREADY_M(BREADY_M),


    .R_req(R_req),
	.DMA_R_ADDR(AR_ADDR),
	.DMA_R_DATA(R_DATA),
	.R_valid(R_valid),

	.W_req(W_req),
	.DMA_W_ADDR(AW_ADDR),
	.DMA_W_DATA(W_DATA),
	.W_done(W_done)

);

DMA_S Slave(
    .ACLK(ACLK),
    .ARESETn(ARESETn),

	/* Slave Interface*/
	.ARVALID_S(ARVALID_S),
    .ARADDR_S(ARADDR_S),
	.ARID_S(ARID_S),
	.ARLEN_S(ARLEN_S),
	.ARSIZE_S(ARSIZE_S),
	.ARBURST_S(ARBURST_S),
	.ARREADY_S(ARREADY_S),

	.RID_S(RID_S),
	.RDATA_S(RDATA_S),
	.RRESP_S(RRESP_S),
	.RLAST_S(RLAST_S),
	.RVALID_S(RVALID_S),
	.RREADY_S(RREADY_S),

	.AWVALID_S(AWVALID_S),
	.AWADDR_S(AWADDR_S),
	.AWID_S(AWID_S),
	.AWLEN_S(AWLEN_S),
	.AWSIZE_S(AWSIZE_S),
	.AWBURST_S(AWBURST_S),
	.AWREADY_S(AWREADY_S),

	.WVALID_S(WVALID_S),
	.WDATA_S(WDATA_S),
	.WSTRB_S(WSTRB_S),
	.WLAST_S(WLAST_S),
	.WREADY_S(WREADY_S),
						
	.BID_S(BID_S),
	.BRESP_S(BRESP_S),
	.BVALID_S(BVALID_S),
	.BREADY_S(BREADY_S),

	.CEB(CEB),
	.WEB(WEB),
	.A(A),
	.DI(DI),
	.DO(DO)

);


DMA DMA(
	.clk(ACLK),
	.rst(~ARESETn),
	.DMA_interrupt(DMA_interrupt),

	.R_req(R_req),
	.AR_ADDR(AR_ADDR),
	.R_DATA(R_DATA),
	.R_valid(R_valid),

	.W_req(W_req),
	.AW_ADDR(AW_ADDR),
	.W_DATA(W_DATA),
	.W_done(W_done),

	.CEB(CEB),
	.WEB(WEB),
	.A(A),
	.DI(DI),
	.DO(DO)

);

>>>>>>> 1db5785 (Initial commit)
endmodule