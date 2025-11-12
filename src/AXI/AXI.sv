//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2025 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			TZUNG-JIN, TSAI (Leo)				  	   		//
//	Filename:		 AXI.sv			                            	//
//	Description:	Top module of AXI	 							//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
`include "./include/AXI_define.svh"

module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M2,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M2,
	input [`AXI_LEN_BITS-1:0] ARLEN_M2,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M2,
	input [1:0] ARBURST_M2,
	input ARVALID_M2,
	output logic ARREADY_M2,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M2,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M2,
	output logic [1:0] RRESP_M2,
	output logic RLAST_M2,
	output logic RVALID_M2,
	input RREADY_M2,

	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M2,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M2,
	input [`AXI_LEN_BITS-1:0] AWLEN_M2,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M2,
	input [1:0] AWBURST_M2,
	input AWVALID_M2,
	output logic AWREADY_M2,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M2,
	input [`AXI_STRB_BITS-1:0] WSTRB_M2,
	input WLAST_M2,
	input WVALID_M2,
	output logic WREADY_M2,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M2,
	output logic [1:0] BRESP_M2,
	output logic BVALID_M2,
	input BREADY_M2,

	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,

	//MASTER INTERFACE FOR SLAVES


	/*-------------- Slave0: ROM --------------*/
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	/*----------------------------------------*/


	/*------------- Slave1: IM --------------*/
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1,

	//WRITE ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,
	/*----------------------------------------*/


	/*------------- Slave2: DM --------------*/
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S2,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
	output logic [1:0] ARBURST_S2,
	output logic ARVALID_S2,
	input ARREADY_S2,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S2,
	input [`AXI_DATA_BITS-1:0] RDATA_S2,
	input [1:0] RRESP_S2,
	input RLAST_S2,
	input RVALID_S2,
	output logic RREADY_S2,

	//WRITE ADDRESS2
	output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2,
	/*----------------------------------------*/


	/*------------- Slave3: DMA --------------*/
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S3,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
	output logic [1:0] ARBURST_S3,
	output logic ARVALID_S3,
	input ARREADY_S3,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S3,
	input [`AXI_DATA_BITS-1:0] RDATA_S3,
	input [1:0] RRESP_S3,
	input RLAST_S3,
	input RVALID_S3,
	output logic RREADY_S3,

	//WRITE ADDRESS3
	output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	output logic [1:0] AWBURST_S3,
	output logic AWVALID_S3,
	input AWREADY_S3,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	output logic WLAST_S3,
	output logic WVALID_S3,
	input WREADY_S3,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S3,
	input [1:0] BRESP_S3,
	input BVALID_S3,
	output logic BREADY_S3,
	/*----------------------------------------*/

	/*------------- Slave4: WDT --------------*/
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S4,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
	output logic [1:0] ARBURST_S4,
	output logic ARVALID_S4,
	input ARREADY_S4,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S4,
	input [`AXI_DATA_BITS-1:0] RDATA_S4,
	input [1:0] RRESP_S4,
	input RLAST_S4,
	input RVALID_S4,
	output logic RREADY_S4,

	//WRITE ADDRESS4
	output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	output logic [1:0] AWBURST_S4,
	output logic AWVALID_S4,
	input AWREADY_S4,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	output logic WLAST_S4,
	output logic WVALID_S4,
	input WREADY_S4,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S4,
	input [1:0] BRESP_S4,
	input BVALID_S4,
	output logic BREADY_S4,
	/*----------------------------------------*/

	/*------------- Slave5: DRAM --------------*/

	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S5,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
	output logic [1:0] ARBURST_S5,
	output logic ARVALID_S5,
	input ARREADY_S5,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S5,
	input [`AXI_DATA_BITS-1:0] RDATA_S5,
	input [1:0] RRESP_S5,
	input RLAST_S5,
	input RVALID_S5,
	output logic RREADY_S5,

	//WRITE ADDRESS5
	output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	output logic [1:0] AWBURST_S5,
	output logic AWVALID_S5,
	input AWREADY_S5,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	output logic WLAST_S5,
	output logic WVALID_S5,
	input WREADY_S5,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S5,
	input [1:0] BRESP_S5,
	input BVALID_S5,
	output logic BREADY_S5
	/*----------------------------------------*/
);


    //---------- you should put your design here ----------//

    localparam DECERR = 2'b11;

    //======================================================================
    //== 1. Address Decoding
    //======================================================================
    wire m0_ar_req_s0, m0_ar_req_s1, m0_ar_req_s2, m0_ar_req_s3, m0_ar_req_s4, m0_ar_req_s5, m0_ar_req_err;
    assign m0_ar_req_s0  = ARVALID_M0 && (32'h0000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0000_1fff);
    assign m0_ar_req_s1  = ARVALID_M0 && (32'h0001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0001_ffff);
    assign m0_ar_req_s2  = ARVALID_M0 && (32'h0002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0002_ffff);
    assign m0_ar_req_s3  = ARVALID_M0 && (32'h1002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1002_0200);
    assign m0_ar_req_s4  = ARVALID_M0 && (32'h1001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1001_03ff);
    assign m0_ar_req_s5  = ARVALID_M0 && (32'h2000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h201f_ffff);
	assign m0_ar_req_err = ARVALID_M0 && !m0_ar_req_s0 && !m0_ar_req_s1 && !m0_ar_req_s2 && !m0_ar_req_s3 && !m0_ar_req_s4 && !m0_ar_req_s5;

    wire m1_ar_req_s0, m1_ar_req_s1, m1_ar_req_s2, m1_ar_req_s3, m1_ar_req_s4, m1_ar_req_s5, m1_ar_req_err;
    assign m1_ar_req_s0  = ARVALID_M0 && (32'h0000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0000_1fff);
    assign m1_ar_req_s1  = ARVALID_M0 && (32'h0001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0001_ffff);
    assign m1_ar_req_s2  = ARVALID_M0 && (32'h0002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0002_ffff);
    assign m1_ar_req_s3  = ARVALID_M0 && (32'h1002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1002_0200);
    assign m1_ar_req_s4  = ARVALID_M0 && (32'h1001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1001_03ff);
    assign m1_ar_req_s5  = ARVALID_M0 && (32'h2000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h201f_ffff);
    assign m1_ar_req_err = ARVALID_M1 && !m1_ar_req_s0 && !m1_ar_req_s1 && !m1_ar_req_s2 && !m1_ar_req_s3 && !m1_ar_req_s4 && !m1_ar_req_s5;

	// S0 is ROM
    wire m1_aw_req_s1, m1_aw_req_s2, m1_aw_req_s3, m1_aw_req_s4, m1_aw_req_s5, m1_aw_req_err;
    assign m1_aw_req_s1  = ARVALID_M0 && (32'h0001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0001_ffff);
    assign m1_aw_req_s2  = ARVALID_M0 && (32'h0002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0002_ffff);
    assign m1_aw_req_s3  = ARVALID_M0 && (32'h1002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1002_0200);
    assign m1_aw_req_s4  = ARVALID_M0 && (32'h1001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1001_03ff);
    assign m1_aw_req_s5  = ARVALID_M0 && (32'h2000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h201f_ffff);
    assign m1_aw_req_err = AWVALID_M1 && !m1_aw_req_s1 && !m1_aw_req_s2 && !m1_aw_req_s3 && !m1_aw_req_s4 && !m1_aw_req_s5;

	wire m2_ar_req_s0, m2_ar_req_s1, m2_ar_req_s2, m2_ar_req_s3, m2_ar_req_s4, m2_ar_req_s5, m2_ar_req_err;
    assign m2_ar_req_s0  = ARVALID_M0 && (32'h0000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0000_1fff);
    assign m2_ar_req_s1  = ARVALID_M0 && (32'h0001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0001_ffff);
    assign m2_ar_req_s2  = ARVALID_M0 && (32'h0002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0002_ffff);
    assign m2_ar_req_s3  = ARVALID_M0 && (32'h1002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1002_0200);
    assign m2_ar_req_s4  = ARVALID_M0 && (32'h1001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1001_03ff);
    assign m2_ar_req_s5  = ARVALID_M0 && (32'h2000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h201f_ffff);
	assign m2_ar_req_err = ARVALID_M2 && !m2_ar_req_s0 && !m2_ar_req_s1 && !m2_ar_req_s2 && !m2_ar_req_s3 && !m2_ar_req_s4 && !m2_ar_req_s5;

	// S0 is ROM
	wire m2_aw_req_s1, m2_aw_req_s2, m2_aw_req_s3, m2_aw_req_s4, m2_aw_req_s5, m2_aw_req_err;
    assign m2_aw_req_s1  = ARVALID_M0 && (32'h0001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0001_ffff);
    assign m2_aw_req_s2  = ARVALID_M0 && (32'h0002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h0002_ffff);
    assign m2_aw_req_s3  = ARVALID_M0 && (32'h1002_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1002_0200);
    assign m2_aw_req_s4  = ARVALID_M0 && (32'h1001_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h1001_03ff);
    assign m2_aw_req_s5  = ARVALID_M0 && (32'h2000_0000 <= ARADDR_M0) && (ARADDR_M0 <= 32'h201f_ffff);
	assign m2_aw_req_err = AWVALID_M2 && !m2_aw_req_s1 && !m2_aw_req_s2 && !m2_aw_req_s3 && !m2_aw_req_s4 && !m2_aw_req_s5;


	reg R_err_m0_active, R_err_m1_active, R_err_m2_active; 

	wire ARREADY_ERR_M0, ARREADY_ERR_M1, ARREADY_ERR_M2;
	assign ARREADY_ERR_M0 	= (m0_ar_req_err)? 1'b1 : 1'b0;
	assign ARREADY_ERR_M1 	= (m1_ar_req_err)? 1'b1 : 1'b0;
	assign ARREADY_ERR_M2 	= (m2_ar_req_err)? 1'b1 : 1'b0;

	reg [`AXI_LEN_BITS-1:0] ARLEN_ERR_M0;
	reg [`AXI_ID_BITS-1:0] RID_ERR_M0;
	reg [`AXI_DATA_BITS-1:0] RDATA_ERR_M0; 
	reg [1:0] RRESP_ERR_M0;
	reg RLAST_ERR_M0;
	reg RVALID_ERR_M0;
	reg [`AXI_LEN_BITS-1:0] rctr_m0;

	reg [`AXI_LEN_BITS-1:0] ARLEN_ERR_M1;
	reg [`AXI_ID_BITS-1:0] RID_ERR_M1;
	reg [`AXI_DATA_BITS-1:0] RDATA_ERR_M1; 
	reg [1:0] RRESP_ERR_M1;
	reg RLAST_ERR_M1;
	reg RVALID_ERR_M1;
	reg [`AXI_LEN_BITS-1:0] rctr_m1;

	reg [`AXI_LEN_BITS-1:0] ARLEN_ERR_M2;
	reg [`AXI_ID_BITS-1:0] RID_ERR_M2;
	reg [`AXI_DATA_BITS-1:0] RDATA_ERR_M2; 
	reg [1:0] RRESP_ERR_M2;
	reg RLAST_ERR_M2;
	reg RVALID_ERR_M2;
	reg [`AXI_LEN_BITS-1:0] rctr_m2;

    always @(posedge ACLK or negedge ARESETn) begin
        if(!ARESETn) begin

			R_err_m0_active <= 1'b0;
			R_err_m1_active <= 1'b0;
			R_err_m2_active <= 1'b0;

			ARLEN_ERR_M0 	<= {`AXI_LEN_BITS{1'b0}};
			RID_ERR_M0 		<= {`AXI_ID_BITS{1'b0}};
			RDATA_ERR_M0 	<= {`AXI_DATA_BITS{1'b0}};
			RRESP_ERR_M0 	<= 2'b00;
			RLAST_ERR_M0 	<= 1'b0;
			RVALID_ERR_M0	<= 1'b0;
			rctr_m0 		<= {`AXI_LEN_BITS{1'b0}};
			
			ARLEN_ERR_M1 	<= {`AXI_LEN_BITS{1'b0}};
			RID_ERR_M1 		<= {`AXI_ID_BITS{1'b0}};
			RDATA_ERR_M1 	<= {`AXI_DATA_BITS{1'b0}};
			RRESP_ERR_M1 	<= 2'b00;
			RLAST_ERR_M1 	<= 1'b0;
			RVALID_ERR_M1 	<= 1'b0;
			rctr_m1 		<= {`AXI_LEN_BITS{1'b0}};
		
			ARLEN_ERR_M2 	<= {`AXI_LEN_BITS{1'b0}};
			RID_ERR_M2 		<= {`AXI_ID_BITS{1'b0}};
			RDATA_ERR_M2 	<= {`AXI_DATA_BITS{1'b0}};
			RRESP_ERR_M2 	<= 2'b00;
			RLAST_ERR_M2 	<= 1'b0;
			RVALID_ERR_M2 	<= 1'b0;
			rctr_m2 		<= {`AXI_LEN_BITS{1'b0}};
		end 
		else begin

			if(m0_ar_req_err & !ARLEN_M0)begin // only one beat of data need to be sent

				R_err_m0_active <= 1'b1;

				ARLEN_ERR_M0 	<= ARLEN_M0;

				RID_ERR_M0 		<= ARID_M0;
				RDATA_ERR_M0 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M0	<= DECERR;
				RLAST_ERR_M0 	<= 1'b1;
				RVALID_ERR_M0 	<= 1'b1;

				rctr_m0 		<= rctr_m0 + 4'd1; 
			end
			else if(m0_ar_req_err)begin

				R_err_m0_active <= 1'b1;

				ARLEN_ERR_M0 	<= ARLEN_M0;

				RID_ERR_M0 		<= ARID_M0;
				RDATA_ERR_M0 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M0	<= DECERR;
				RLAST_ERR_M0 	<= 1'b0;
				RVALID_ERR_M0	<= 1'b1;

				rctr_m0 		<= rctr_m0 + 4'd1;
			end
			else if(R_err_m0_active && RREADY_M0 && (rctr_m0 < ARLEN_ERR_M0))begin // sent to master successfully but not last
				rctr_m0 		<= rctr_m0 + 4'd1;
			end
			else if(R_err_m0_active && RREADY_M0 && (rctr_m0 == ARLEN_ERR_M0))begin // sent to master successfully and it is last
				RLAST_ERR_M0 	<= 1'b1;
				rctr_m0 		<= rctr_m0 + 4'd1;
			end
			else if(R_err_m0_active && RREADY_M0)begin
				R_err_m0_active <= 1'b0;

				ARLEN_ERR_M0 	<= {`AXI_LEN_BITS{1'b0}};

				RID_ERR_M0 		<= {`AXI_ID_BITS{1'b1}};
				RDATA_ERR_M0 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M0 	<= 2'b00;
				RLAST_ERR_M0 	<= 1'b0;
				RVALID_ERR_M0 	<= 1'b0;

				rctr_m0 		<= {`AXI_LEN_BITS{1'b0}};
			end

			if(m1_ar_req_err & !ARLEN_M1)begin

				R_err_m1_active <= 1'b1;

				ARLEN_ERR_M1 	<= ARLEN_M1;

				RID_ERR_M1 		<= ARID_M1;
				RDATA_ERR_M1 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M1	<= DECERR;
				RLAST_ERR_M1 	<= 1'b1;
				RVALID_ERR_M1	<= 1'b1;

				rctr_m1 		<= rctr_m1 + 4'd1;
			end
			else if(m1_ar_req_err)begin

				R_err_m1_active <= 1'b1;

				ARLEN_ERR_M1 	<= ARLEN_M1;

				RID_ERR_M1 		<= ARID_M1;
				RDATA_ERR_M1 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M1	<= DECERR;
				RLAST_ERR_M1 	<= 1'b0;
				RVALID_ERR_M1	<= 1'b1;

				rctr_m1 		<= rctr_m1 + 4'd1;
			end
			else if(R_err_m1_active && RREADY_M1 && (rctr_m1 < ARLEN_ERR_M1))begin // sent to master successfully but not last
				rctr_m1 		<= rctr_m1 + 4'd1;
			end
			else if(R_err_m1_active && RREADY_M1 && (rctr_m1 == ARLEN_ERR_M1))begin // sent to master successfully and it is last
				RLAST_ERR_M1 	<= 1'b1;
				rctr_m1 		<= rctr_m1 + 4'd1;
			end
			else if(R_err_m1_active && RREADY_M1)begin // reset

				R_err_m1_active <= 1'b0;

				ARLEN_ERR_M1 	<= {`AXI_LEN_BITS{1'b0}};

				RID_ERR_M1 		<= {`AXI_ID_BITS{1'b0}};
				RDATA_ERR_M1 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M1 	<= 2'b00;
				RLAST_ERR_M1 	<= 1'b0;
				RVALID_ERR_M1 	<= 1'b0;

				rctr_m1 		<= {`AXI_LEN_BITS{1'b0}};
			end

			if(m2_ar_req_err & !ARLEN_M2)begin

				R_err_m2_active <= 1'b1;

				ARLEN_ERR_M2 	<= ARLEN_M2;

				RID_ERR_M2 		<= ARID_M2;
				RDATA_ERR_M2 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M2	<= DECERR;
				RLAST_ERR_M2 	<= 1'b1;
				RVALID_ERR_M2	<= 1'b1;

				rctr_m2 		<= rctr_m2 + 4'd1;
			end
			else if(m2_ar_req_err)begin

				R_err_m2_active <= 1'b1;

				ARLEN_ERR_M2 	<= ARLEN_M2;

				RID_ERR_M2 		<= ARID_M2;
				RDATA_ERR_M2 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M2	<= DECERR;
				RLAST_ERR_M2 	<= 1'b0;
				RVALID_ERR_M2	<= 1'b1;

				rctr_m2 		<= rctr_m2 + 4'd1;
			end
			else if(R_err_m2_active && RREADY_M2 && (rctr_m2 < ARLEN_ERR_M2))begin // sent to master successfully but not last
				rctr_m2 		<= rctr_m2 + 4'd1;
			end
			else if(R_err_m2_active && RREADY_M2 && (rctr_m2 == ARLEN_ERR_M2))begin // sent to master successfully and it is last
				RLAST_ERR_M2 	<= 1'b1;
				rctr_m2 		<= rctr_m2 + 4'd1;
			end
			else if(R_err_m2_active && RREADY_M2)begin // reset

				R_err_m2_active <= 1'b0;

				ARLEN_ERR_M2 	<= {`AXI_LEN_BITS{1'b0}};

				RID_ERR_M2 		<= {`AXI_ID_BITS{1'b0}};
				RDATA_ERR_M2 	<= {`AXI_DATA_BITS{1'b0}};
				RRESP_ERR_M2 	<= 2'b00;
				RLAST_ERR_M2 	<= 1'b0;
				RVALID_ERR_M2 	<= 1'b0;

				rctr_m2 		<= {`AXI_LEN_BITS{1'b0}};
			end
        end
    end

	reg w_err_m1, b_err_m1; // w_err_last is assigned to handle B signals
	reg w_err_m2, b_err_m2;

	reg [`AXI_ID_BITS-1:0] 	BID_ERR;
	reg [1:0] 				BRESP_ERR;
	reg 					BVALID_ERR;

	always @ (posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			w_err_m1	<= 1'b0;
			b_err_m1	<= 1'b0;
			w_err_m2 	<= 1'b0;
			b_err_m2 	<= 1'b0;

			BID_ERR 	<= {`AXI_ID_BITS{1'b0}};
			BRESP_ERR 	<= DECERR;
			BVALID_ERR 	<= 1'b0;
		end
		else begin

			BID_ERR <= (m1_aw_req_err)? AWID_M1 : (m2_aw_req_err)? AWID_M2 : BID_ERR;

			if((w_err_m1 == 1'b1 || m1_aw_req_err) && WLAST_M1 && WVALID_M1)begin
				w_err_m1 		<= 1'b0;
				b_err_m1 		<= 1'b1;
				BVALID_ERR 		<= 1'b1;
			end
			else if(m1_aw_req_err)begin
				w_err_m1 		<= 1'b1;
				b_err_m1 		<= 1'b0;
				BVALID_ERR 		<= 1'b0;
			end
			else if((b_err_m1 == 1'b1) && BREADY_M1)begin
				b_err_m1 		<= 1'b0;
				BVALID_ERR 		<= 1'b0;
			end

			if((w_err_m2 == 1'b1 || m2_aw_req_err) && WLAST_M2 && WVALID_M2)begin
				w_err_m2 		<= 1'b0;
				b_err_m2 		<= 1'b1;
				BVALID_ERR 		<= 1'b1;
			end
			else if(m2_aw_req_err)begin
				w_err_m2 		<= 1'b1;
				b_err_m2 		<= 1'b0;
				BVALID_ERR 		<= 1'b0;
			end
			else if((b_err_m2 == 1'b1) && BREADY_M2)begin
				b_err_m2 		<= 1'b0;
				BVALID_ERR 		<= 1'b0;
			end

		end
	end

    //======================================================================
    //== 2. Round-Robin Arbitration
    //======================================================================
    reg [1:0] 	rr_priority_s0, rr_priority_s1, rr_priority_s2, rr_priority_s3, rr_priority_s4, rr_priority_s5; // 0: M0 has priority, 1: M1 has priority
	reg 		rr_priority_s1_w, rr_priority_s2_w, rr_priority_s3_w, rr_priority_s4_w, rr_priority_s5_w;

    wire m0_ar_grant_s0, m0_ar_grant_s1, m0_ar_grant_s2, m0_ar_grant_s3, m0_ar_grant_s4, m0_ar_grant_s5;
    wire m1_ar_grant_s0, m1_ar_grant_s1, m1_ar_grant_s2, m1_ar_grant_s3, m1_ar_grant_s4, m1_ar_grant_s5;
	wire m2_ar_grant_s0, m2_ar_grant_s1, m2_ar_grant_s2, m2_ar_grant_s3, m2_ar_grant_s4, m2_ar_grant_s5;
    
	assign m0_ar_grant_s0 	= ((m0_ar_req_s0 && !m1_ar_req_s0 && !m2_ar_req_s0) || (m0_ar_req_s0 && (m1_ar_req_s0 || m2_ar_req_s0) && rr_priority_s0 == 2'd0))? 1'b1 : 1'b0;
	assign m0_ar_grant_s1 	= ((m0_ar_req_s1 && !m1_ar_req_s1 && !m2_ar_req_s1) || (m0_ar_req_s1 && (m1_ar_req_s1 || m2_ar_req_s1) && rr_priority_s1 == 2'd0))? 1'b1 : 1'b0;
	assign m0_ar_grant_s2 	= ((m0_ar_req_s2 && !m1_ar_req_s2 && !m2_ar_req_s2) || (m0_ar_req_s2 && (m1_ar_req_s2 || m2_ar_req_s2) && rr_priority_s2 == 2'd0))? 1'b1 : 1'b0;
	assign m0_ar_grant_s3 	= ((m0_ar_req_s3 && !m1_ar_req_s3 && !m2_ar_req_s3) || (m0_ar_req_s3 && (m1_ar_req_s3 || m2_ar_req_s3) && rr_priority_s3 == 2'd0))? 1'b1 : 1'b0;
	assign m0_ar_grant_s4 	= ((m0_ar_req_s4 && !m1_ar_req_s4 && !m2_ar_req_s4) || (m0_ar_req_s4 && (m1_ar_req_s4 || m2_ar_req_s4) && rr_priority_s4 == 2'd0))? 1'b1 : 1'b0;
	assign m0_ar_grant_s5 	= ((m0_ar_req_s5 && !m1_ar_req_s5 && !m2_ar_req_s5) || (m0_ar_req_s5 && (m1_ar_req_s5 || m2_ar_req_s5) && rr_priority_s5 == 2'd0))? 1'b1 : 1'b0;

	assign m1_ar_grant_s0 	= ((m1_ar_req_s0 && !m0_ar_req_s0 && !m2_ar_req_s0) || (m1_ar_req_s0 && (m0_ar_req_s0 || m2_ar_req_s0) && rr_priority_s0 == 2'd1))? 1'b1 : 1'b0;
	assign m1_ar_grant_s1 	= ((m1_ar_req_s1 && !m0_ar_req_s1 && !m2_ar_req_s1) || (m1_ar_req_s1 && (m0_ar_req_s1 || m2_ar_req_s1) && rr_priority_s1 == 2'd1))? 1'b1 : 1'b0;
	assign m1_ar_grant_s2 	= ((m1_ar_req_s2 && !m0_ar_req_s2 && !m2_ar_req_s2) || (m1_ar_req_s2 && (m0_ar_req_s2 || m2_ar_req_s2) && rr_priority_s2 == 2'd1))? 1'b1 : 1'b0;
	assign m1_ar_grant_s3 	= ((m1_ar_req_s3 && !m0_ar_req_s3 && !m2_ar_req_s3) || (m1_ar_req_s3 && (m0_ar_req_s3 || m2_ar_req_s3) && rr_priority_s3 == 2'd1))? 1'b1 : 1'b0;
	assign m1_ar_grant_s4 	= ((m1_ar_req_s4 && !m0_ar_req_s4 && !m2_ar_req_s4) || (m1_ar_req_s4 && (m0_ar_req_s4 || m2_ar_req_s4) && rr_priority_s4 == 2'd1))? 1'b1 : 1'b0;
	assign m1_ar_grant_s5 	= ((m1_ar_req_s5 && !m0_ar_req_s5 && !m2_ar_req_s5) || (m1_ar_req_s5 && (m0_ar_req_s5 || m2_ar_req_s5) && rr_priority_s5 == 2'd1))? 1'b1 : 1'b0;

	assign m2_ar_grant_s0 	= ((m2_ar_req_s0 && !m0_ar_req_s0 && !m1_ar_req_s0) || (m2_ar_req_s0 && (m0_ar_req_s0 || m1_ar_req_s0) && rr_priority_s0 == 2'd2))? 1'b1 : 1'b0;
	assign m2_ar_grant_s1 	= ((m2_ar_req_s1 && !m0_ar_req_s1 && !m1_ar_req_s1) || (m2_ar_req_s1 && (m0_ar_req_s1 || m1_ar_req_s1) && rr_priority_s1 == 2'd2))? 1'b1 : 1'b0;
	assign m2_ar_grant_s2 	= ((m2_ar_req_s2 && !m0_ar_req_s2 && !m1_ar_req_s2) || (m2_ar_req_s2 && (m0_ar_req_s2 || m1_ar_req_s2) && rr_priority_s2 == 2'd2))? 1'b1 : 1'b0;
	assign m2_ar_grant_s3 	= ((m2_ar_req_s3 && !m0_ar_req_s3 && !m1_ar_req_s3) || (m2_ar_req_s3 && (m0_ar_req_s3 || m1_ar_req_s3) && rr_priority_s3 == 2'd2))? 1'b1 : 1'b0;
	assign m2_ar_grant_s4 	= ((m2_ar_req_s4 && !m0_ar_req_s4 && !m1_ar_req_s4) || (m2_ar_req_s4 && (m0_ar_req_s4 || m1_ar_req_s4) && rr_priority_s4 == 2'd2))? 1'b1 : 1'b0;
	assign m2_ar_grant_s5 	= ((m2_ar_req_s5 && !m0_ar_req_s5 && !m1_ar_req_s5) || (m2_ar_req_s5 && (m0_ar_req_s5 || m1_ar_req_s5) && rr_priority_s5 == 2'd2))? 1'b1 : 1'b0;

	reg R_s0_is_m0_active, R_s1_is_m0_active, R_s2_is_m0_active, R_s3_is_m0_active, R_s4_is_m0_active, R_s5_is_m0_active;
	reg R_s0_is_m1_active, R_s1_is_m1_active, R_s2_is_m1_active, R_s3_is_m1_active, R_s4_is_m1_active, R_s5_is_m1_active;
	reg R_s0_is_m2_active, R_s1_is_m2_active, R_s2_is_m2_active, R_s3_is_m2_active, R_s4_is_m2_active, R_s5_is_m2_active;


	wire m1_aw_grant_s1, m1_aw_grant_s2, m1_aw_grant_s3, m1_aw_grant_s4, m1_aw_grant_s5;
	wire m2_aw_grant_s1, m2_aw_grant_s2, m2_aw_grant_s3, m2_aw_grant_s4, m2_aw_grant_s5;

	assign m1_aw_grant_s1 	= ((m1_aw_req_s1 && !m2_aw_req_s1) || (m1_aw_req_s1 && m2_aw_req_s1 && rr_priority_s1_w == 2'd0))? 1'b1 : 1'b0;
	assign m1_aw_grant_s2 	= ((m1_aw_req_s2 && !m2_aw_req_s2) || (m1_aw_req_s2 && m2_aw_req_s2 && rr_priority_s2_w == 2'd0))? 1'b1 : 1'b0;
	assign m1_aw_grant_s3 	= ((m1_aw_req_s3 && !m2_aw_req_s3) || (m1_aw_req_s3 && m2_aw_req_s3 && rr_priority_s3_w == 2'd0))? 1'b1 : 1'b0;
	assign m1_aw_grant_s4 	= ((m1_aw_req_s4 && !m2_aw_req_s4) || (m1_aw_req_s4 && m2_aw_req_s4 && rr_priority_s4_w == 2'd0))? 1'b1 : 1'b0;
	assign m1_aw_grant_s5 	= ((m1_aw_req_s5 && !m2_aw_req_s5) || (m1_aw_req_s5 && m2_aw_req_s5 && rr_priority_s5_w == 2'd0))? 1'b1 : 1'b0;

	assign m2_aw_grant_s1 	= ((m2_aw_req_s1 && !m1_aw_req_s1) || (m2_aw_req_s1 && m1_aw_req_s1 && rr_priority_s1_w == 2'd1))? 1'b1 : 1'b0;
	assign m2_aw_grant_s2 	= ((m2_aw_req_s2 && !m1_aw_req_s2) || (m2_aw_req_s2 && m1_aw_req_s2 && rr_priority_s2_w == 2'd1))? 1'b1 : 1'b0;
	assign m2_aw_grant_s3 	= ((m2_aw_req_s3 && !m1_aw_req_s3) || (m2_aw_req_s3 && m1_aw_req_s3 && rr_priority_s3_w == 2'd1))? 1'b1 : 1'b0;
	assign m2_aw_grant_s4 	= ((m2_aw_req_s4 && !m1_aw_req_s4) || (m2_aw_req_s4 && m1_aw_req_s4 && rr_priority_s4_w == 2'd1))? 1'b1 : 1'b0;
	assign m2_aw_grant_s5 	= ((m2_aw_req_s5 && !m1_aw_req_s5) || (m2_aw_req_s5 && m1_aw_req_s5 && rr_priority_s5_w == 2'd1))? 1'b1 : 1'b0;

	reg W_s1_is_m1_active, W_s2_is_m1_active, W_s3_is_m1_active, W_s4_is_m1_active, W_s5_is_m1_active;
	reg W_s1_is_m2_active, W_s2_is_m2_active, W_s3_is_m2_active, W_s4_is_m2_active, W_s5_is_m2_active;





	// reg R_s0_is_m0_active, R_s0_is_m1_active;
	// reg R_s1_is_m0_active, R_s1_is_m1_active;

	always @ (posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			rr_priority_s0 		<= 2'd0;
			rr_priority_s1 		<= 2'd0;
			rr_priority_s2 		<= 2'd0;
			rr_priority_s3 		<= 2'd0;
			rr_priority_s4 		<= 2'd0;
			rr_priority_s5 		<= 2'd0;

			rr_priority_s1_w 	<= 1'd0;
			rr_priority_s2_w 	<= 1'd0;
			rr_priority_s3_w 	<= 1'd0;
			rr_priority_s4_w 	<= 1'd0;
			rr_priority_s5_w 	<= 1'd0;
		end
		else begin
			// m0 used s0 / m1 used s0
			
			rr_priority_s0 		<= 	((R_s0_is_m0_active && RREADY_M0 && RVALID_S0 && RLAST_S0) || (R_s0_is_m1_active && RREADY_M1 && RVALID_S0 && RLAST_S0) || (R_s0_is_m2_active && RREADY_M2 && RVALID_S0 && RLAST_S0))?
									(rr_priority_s0 == 2'd2)? 2'd0 : (rr_priority_s0 + 2'd1) : (m0_ar_grant_s0)? 2'd0 : (m1_ar_grant_s0)? 2'd1 : (m2_ar_grant_s0)? 2'd2 : rr_priority_s0;

			rr_priority_s1 		<= 	((R_s1_is_m0_active && RREADY_M0 && RVALID_S1 && RLAST_S1) || (R_s1_is_m1_active && RREADY_M1 && RVALID_S1 && RLAST_S1) || (R_s1_is_m2_active && RREADY_M2 && RVALID_S1 && RLAST_S1))?
									(rr_priority_s1 == 2'd2)? 2'd0 : (rr_priority_s1 + 2'd1) : (m0_ar_grant_s1)? 2'd0 : (m1_ar_grant_s1)? 2'd1 : (m2_ar_grant_s1)? 2'd2 : rr_priority_s1;

			rr_priority_s2 		<= 	((R_s2_is_m0_active && RREADY_M0 && RVALID_S2 && RLAST_S2) || (R_s2_is_m1_active && RREADY_M1 && RVALID_S2 && RLAST_S2) || (R_s2_is_m2_active && RREADY_M2 && RVALID_S2 && RLAST_S2))?
									(rr_priority_s2 == 2'd2)? 2'd0 : (rr_priority_s2 + 2'd1) : (m0_ar_grant_s2)? 2'd0 : (m1_ar_grant_s2)? 2'd1 : (m2_ar_grant_s2)? 2'd2 : rr_priority_s2;

			rr_priority_s3 		<= 	((R_s3_is_m0_active && RREADY_M0 && RVALID_S3 && RLAST_S3) || (R_s3_is_m1_active && RREADY_M1 && RVALID_S3 && RLAST_S3) || (R_s3_is_m2_active && RREADY_M2 && RVALID_S3 && RLAST_S3))?
									(rr_priority_s3 == 2'd2)? 2'd0 : (rr_priority_s3 + 2'd1) : (m0_ar_grant_s3)? 2'd0 : (m1_ar_grant_s3)? 2'd1 : (m2_ar_grant_s3)? 2'd2 : rr_priority_s3;

			rr_priority_s4 		<= 	((R_s4_is_m0_active && RREADY_M0 && RVALID_S4 && RLAST_S4) || (R_s4_is_m1_active && RREADY_M1 && RVALID_S4 && RLAST_S4) || (R_s4_is_m2_active && RREADY_M2 && RVALID_S4 && RLAST_S4))?
									(rr_priority_s4 == 2'd2)? 2'd0 : (rr_priority_s4 + 2'd1) : (m0_ar_grant_s4)? 2'd0 : (m1_ar_grant_s4)? 2'd1 : (m2_ar_grant_s4)? 2'd2 : rr_priority_s4;

			rr_priority_s5 		<= 	((R_s5_is_m0_active && RREADY_M0 && RVALID_S5 && RLAST_S5) || (R_s5_is_m1_active && RREADY_M1 && RVALID_S5 && RLAST_S5) || (R_s5_is_m2_active && RREADY_M2 && RVALID_S5 && RLAST_S5))?
									(rr_priority_s5 == 2'd2)? 2'd0 : (rr_priority_s5 + 2'd1) : (m0_ar_grant_s5)? 2'd0 : (m1_ar_grant_s5)? 2'd1 : (m2_ar_grant_s5)? 2'd2 : rr_priority_s5;


			rr_priority_s1_w 	<= 	((B_s1_is_m1_active && BREADY_M1 && BVALID_S1) || (B_s1_is_m2_active && BREADY_M2 && BVALID_S1))?
									~rr_priority_s1_w : (m1_aw_grant_s1)? 1'b0 : (m2_aw_grant_s1)? 1'b1 : rr_priority_s1_w;

			rr_priority_s2_w 	<= 	((B_s2_is_m1_active && BREADY_M1 && BVALID_S2) || (B_s2_is_m2_active && BREADY_M2 && BVALID_S2))?
									~rr_priority_s2_w : (m1_aw_grant_s2)? 1'b0 : (m2_aw_grant_s2)? 1'b1 : rr_priority_s2_w;
									
			rr_priority_s3_w 	<= 	((B_s3_is_m1_active && BREADY_M1 && BVALID_S3) || (B_s3_is_m2_active && BREADY_M2 && BVALID_S3))?
									~rr_priority_s3_w : (m1_aw_grant_s3)? 1'b0 : (m2_aw_grant_s3)? 1'b1 : rr_priority_s1_w;

			rr_priority_s4_w 	<= 	((B_s4_is_m1_active && BREADY_M1 && BVALID_S4) || (B_s4_is_m2_active && BREADY_M2 && BVALID_S4))?
									~rr_priority_s4_w : (m1_aw_grant_s4)? 1'b0 : (m2_aw_grant_s4)? 1'b1 : rr_priority_s4_w;

			rr_priority_s5_w 	<= 	((B_s5_is_m1_active && BREADY_M1 && BVALID_S5) || (B_s5_is_m2_active && BREADY_M2 && BVALID_S5))?
									~rr_priority_s5_w : (m1_aw_grant_s5)? 1'b0 : (m2_aw_grant_s5)? 1'b1 : rr_priority_s5_w;


		end
	end


    //======================================================================
    //== 3. Routing and Path Selection
    //======================================================================
    

    //======================================================================
    //== 3.1 AR & R
    //======================================================================

	always @(*)begin
		if(m0_ar_grant_s0)begin
			ARREADY_M0 = ARREADY_S0;
		end
		else if(m0_ar_grant_s1)begin
			ARREADY_M0 = ARREADY_S1;
		end
		else if(m0_ar_grant_s2)begin
			ARREADY_M0 = ARREADY_S2;
		end
		else if(m0_ar_grant_s3)begin
			ARREADY_M0 = ARREADY_S3;
		end
		else if(m0_ar_grant_s4)begin
			ARREADY_M0 = ARREADY_S4;
		end
		else if(m0_ar_grant_s5)begin
			ARREADY_M0 = ARREADY_S5;
		end
		else if(m0_ar_req_err)begin
			ARREADY_M0 = ARREADY_ERR_M0;
		end
		else begin
			ARREADY_M0 = 1'b0;
		end

		if(m1_ar_grant_s0)begin
			ARREADY_M1 = ARREADY_S0;
		end
		else if(m1_ar_grant_s1)begin
			ARREADY_M1 = ARREADY_S1;
		end
		else if(m1_ar_grant_s2)begin
			ARREADY_M1 = ARREADY_S2;
		end
		else if(m1_ar_grant_s3)begin
			ARREADY_M1 = ARREADY_S3;
		end
		else if(m1_ar_grant_s4)begin
			ARREADY_M1 = ARREADY_S4;
		end
		else if(m1_ar_grant_s5)begin
			ARREADY_M1 = ARREADY_S5;
		end
		else if(m1_ar_req_err)begin
			ARREADY_M1 = ARREADY_ERR_M1;
		end
		else begin
			ARREADY_M1 = 1'b0;
		end

		if(m2_ar_grant_s0)begin
			ARREADY_M2 = ARREADY_S0;
		end
		else if(m2_ar_grant_s1)begin
			ARREADY_M2 = ARREADY_S1;
		end
		else if(m2_ar_grant_s2)begin
			ARREADY_M2 = ARREADY_S2;
		end
		else if(m2_ar_grant_s3)begin
			ARREADY_M2 = ARREADY_S3;
		end
		else if(m2_ar_grant_s4)begin
			ARREADY_M2 = ARREADY_S4;
		end
		else if(m2_ar_grant_s5)begin
			ARREADY_M2 = ARREADY_S5;
		end
		else if(m2_ar_req_err)begin
			ARREADY_M2 = ARREADY_ERR_M2;
		end
		else begin
			ARREADY_M2 = 1'b0;
		end
	end



	// assign ARREADY_M0 = m0_ar_grant_s0? ARREADY_S0 : m0_ar_grant_s1? ARREADY_S1 : m0_ar_req_err? ARREADY_ERR_M0 : 1'b0;
	// assign ARREADY_M1 = m1_ar_grant_s0? ARREADY_S0 : m1_ar_grant_s1? ARREADY_S1 : m1_ar_req_err? ARREADY_ERR_M1 : 1'b0;


	always @(*)begin

		if(R_s0_is_m0_active || R_s0_is_m1_active || R_s0_is_m2_active)begin
			ARVALID_S0 	= 1'd0;
			ARID_S0 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S0 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S0 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S0 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S0 	= 2'd0;
		end
		else if(m0_ar_grant_s0)begin
			ARVALID_S0 	= ARVALID_M0;
			ARID_S0 	= {4'd0, ARID_M0};
			ARADDR_S0 	= ARADDR_M0;
			ARLEN_S0 	= ARLEN_M0;
			ARSIZE_S0 	= ARSIZE_M0;
			ARBURST_S0 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s0)begin
			ARVALID_S0 	= ARVALID_M1;
			ARID_S0 	= {4'd0, ARID_M1};
			ARADDR_S0 	= ARADDR_M1;
			ARLEN_S0 	= ARLEN_M1;
			ARSIZE_S0 	= ARSIZE_M1;
			ARBURST_S0 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s0)begin
			ARVALID_S0 	= ARVALID_M2;
			ARID_S0 	= {4'd0, ARID_M2};
			ARADDR_S0 	= ARADDR_M2;	
			ARLEN_S0 	= ARLEN_M2;
			ARSIZE_S0 	= ARSIZE_M2;
			ARBURST_S0 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S0 	= 1'd0;
			ARID_S0 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S0 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S0 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S0 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S0 	= 2'd0;
		end

		if(R_s1_is_m0_active || R_s1_is_m1_active || R_s1_is_m2_active)begin
			ARVALID_S1 	= 1'd0;
			ARID_S1 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S1 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S1 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S1 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S1 	= 2'd0;
		end
		else if(m0_ar_grant_s1)begin
			ARVALID_S1 	= ARVALID_M0;
			ARID_S1 	= {4'd0, ARID_M0};
			ARADDR_S1 	= ARADDR_M0;
			ARLEN_S1 	= ARLEN_M0;
			ARSIZE_S1 	= ARSIZE_M0;
			ARBURST_S1 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s1)begin
			ARVALID_S1 	= ARVALID_M1;
			ARID_S1 	= {4'd0, ARID_M1};
			ARADDR_S1 	= ARADDR_M1;
			ARLEN_S1 	= ARLEN_M1;
			ARSIZE_S1 	= ARSIZE_M1;
			ARBURST_S1 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s1)begin
			ARVALID_S1 	= ARVALID_M2;
			ARID_S1 	= {4'd0, ARID_M2};
			ARADDR_S1 	= ARADDR_M2;	
			ARLEN_S1 	= ARLEN_M2;
			ARSIZE_S1 	= ARSIZE_M2;
			ARBURST_S1 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S1 	= 1'd0;
			ARID_S1 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S1 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S1 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S1 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S1 	= 2'd0;
		end

		if(R_s2_is_m0_active || R_s2_is_m1_active || R_s2_is_m2_active)begin
			ARVALID_S2 	= 1'd0;
			ARID_S2 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S2 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S2 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S2 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S2 	= 2'd0;
		end
		else if(m0_ar_grant_s2)begin
			ARVALID_S2 	= ARVALID_M0;
			ARID_S2 	= {4'd0, ARID_M0};
			ARADDR_S2 	= ARADDR_M0;
			ARLEN_S2 	= ARLEN_M0;
			ARSIZE_S2 	= ARSIZE_M0;
			ARBURST_S2 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s2)begin
			ARVALID_S2 	= ARVALID_M1;
			ARID_S2 	= {4'd0, ARID_M1};
			ARADDR_S2 	= ARADDR_M1;
			ARLEN_S2 	= ARLEN_M1;
			ARSIZE_S2 	= ARSIZE_M1;
			ARBURST_S2 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s2)begin
			ARVALID_S2 	= ARVALID_M2;
			ARID_S2 	= {4'd0, ARID_M2};
			ARADDR_S2 	= ARADDR_M2;	
			ARLEN_S2 	= ARLEN_M2;
			ARSIZE_S2 	= ARSIZE_M2;
			ARBURST_S2 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S2 	= 1'd0;
			ARID_S2 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S2 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S2 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S2 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S2 	= 2'd0;
		end

		if(R_s3_is_m0_active || R_s3_is_m1_active || R_s3_is_m2_active)begin
			ARVALID_S3 	= 1'd0;
			ARID_S3 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S3 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S3 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S3 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S3 	= 2'd0;
		end
		else if(m0_ar_grant_s3)begin
			ARVALID_S3 	= ARVALID_M0;
			ARID_S3 	= {4'd0, ARID_M0};
			ARADDR_S3 	= ARADDR_M0;
			ARLEN_S3 	= ARLEN_M0;
			ARSIZE_S3 	= ARSIZE_M0;
			ARBURST_S3 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s3)begin
			ARVALID_S3 	= ARVALID_M1;
			ARID_S3 	= {4'd0, ARID_M1};
			ARADDR_S3 	= ARADDR_M1;
			ARLEN_S3 	= ARLEN_M1;
			ARSIZE_S3 	= ARSIZE_M1;
			ARBURST_S3 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s3)begin
			ARVALID_S3 	= ARVALID_M2;
			ARID_S3 	= {4'd0, ARID_M2};
			ARADDR_S3 	= ARADDR_M2;	
			ARLEN_S3 	= ARLEN_M2;
			ARSIZE_S3 	= ARSIZE_M2;
			ARBURST_S3 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S3 	= 1'd0;
			ARID_S3 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S3 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S3 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S3 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S3 	= 2'd0;
		end

		if(R_s4_is_m0_active || R_s4_is_m1_active || R_s4_is_m2_active)begin
			ARVALID_S4 	= 1'd0;
			ARID_S4 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S4 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S4 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S4 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S4 	= 2'd0;
		end
		else if(m0_ar_grant_s4)begin
			ARVALID_S4 	= ARVALID_M0;
			ARID_S4 	= {4'd0, ARID_M0};
			ARADDR_S4 	= ARADDR_M0;
			ARLEN_S4 	= ARLEN_M0;
			ARSIZE_S4 	= ARSIZE_M0;
			ARBURST_S4 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s4)begin
			ARVALID_S4 	= ARVALID_M1;
			ARID_S4 	= {4'd0, ARID_M1};
			ARADDR_S4 	= ARADDR_M1;
			ARLEN_S4 	= ARLEN_M1;
			ARSIZE_S4 	= ARSIZE_M1;
			ARBURST_S4 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s4)begin
			ARVALID_S4 	= ARVALID_M2;
			ARID_S4 	= {4'd0, ARID_M2};
			ARADDR_S4 	= ARADDR_M2;	
			ARLEN_S4 	= ARLEN_M2;
			ARSIZE_S4 	= ARSIZE_M2;
			ARBURST_S4 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S4 	= 1'd0;
			ARID_S4 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S4 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S4 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S4 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S4 	= 2'd0;
		end

		if(R_s5_is_m0_active || R_s5_is_m1_active || R_s5_is_m2_active)begin
			ARVALID_S5 	= 1'd0;
			ARID_S5 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S5 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S5 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S5 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S5 	= 2'd0;
		end
		else if(m0_ar_grant_s5)begin
			ARVALID_S5 	= ARVALID_M0;
			ARID_S5 	= {4'd0, ARID_M0};
			ARADDR_S5 	= ARADDR_M0;
			ARLEN_S5 	= ARLEN_M0;
			ARSIZE_S5 	= ARSIZE_M0;
			ARBURST_S5 	= ARBURST_M0;
		end
		else if(m1_ar_grant_s5)begin
			ARVALID_S5 	= ARVALID_M1;
			ARID_S5 	= {4'd0, ARID_M1};
			ARADDR_S5 	= ARADDR_M1;
			ARLEN_S5 	= ARLEN_M1;
			ARSIZE_S5 	= ARSIZE_M1;
			ARBURST_S5 	= ARBURST_M1;
		end
		else if(m2_ar_grant_s5)begin
			ARVALID_S5 	= ARVALID_M2;
			ARID_S5 	= {4'd0, ARID_M2};
			ARADDR_S5 	= ARADDR_M2;	
			ARLEN_S5 	= ARLEN_M2;
			ARSIZE_S5 	= ARSIZE_M2;
			ARBURST_S5 	= ARBURST_M2;	
		end
		else begin
			ARVALID_S5 	= 1'd0;
			ARID_S5 	= {`AXI_IDS_BITS{1'd0}};
			ARADDR_S5 	= {`AXI_ADDR_BITS{1'd0}};
			ARLEN_S5 	= {`AXI_LEN_BITS{1'd0}};
			ARSIZE_S5 	= {`AXI_SIZE_BITS{1'd0}};
			ARBURST_S5 	= 2'd0;
		end

	end

	// assign ARVALID_S0 	= (R_s0_is_m0_active || R_s0_is_m1_active)? 1'd0					: (m0_ar_grant_s0)? ARVALID_M0 			: (m1_ar_grant_s0)? ARVALID_M1			: 1'd0;
	// assign ARID_S0 		= (R_s0_is_m0_active || R_s0_is_m1_active)? {`AXI_IDS_BITS{1'd0}}	: (m0_ar_grant_s0)? {4'd0, ARID_M0} 	: (m1_ar_grant_s0)? {4'd0, ARID_M1}		: {`AXI_IDS_BITS{1'd0}};
	// assign ARADDR_S0 	= (R_s0_is_m0_active || R_s0_is_m1_active)? {`AXI_ADDR_BITS{1'd0}}	: (m0_ar_grant_s0)? ARADDR_M0 			: (m1_ar_grant_s0)? ARADDR_M1			: {`AXI_ADDR_BITS{1'd0}};
	// assign ARLEN_S0 	= (R_s0_is_m0_active || R_s0_is_m1_active)? {`AXI_LEN_BITS{1'd0}}	: (m0_ar_grant_s0)? ARLEN_M0 			: (m1_ar_grant_s0)? ARLEN_M1			: {`AXI_LEN_BITS{1'd0}};
	// assign ARSIZE_S0 	= (R_s0_is_m0_active || R_s0_is_m1_active)? {`AXI_SIZE_BITS{1'd0}}	: (m0_ar_grant_s0)? ARSIZE_M0 			: (m1_ar_grant_s0)? ARSIZE_M1			: {`AXI_SIZE_BITS{1'd0}};
	// assign ARBURST_S0 	= (R_s0_is_m0_active || R_s0_is_m1_active)? 2'd0					: (m0_ar_grant_s0)? ARBURST_M0 			: (m1_ar_grant_s0)? ARBURST_M1			: 2'd0;

	// assign ARVALID_S1 	= (R_s1_is_m0_active || R_s1_is_m1_active)? 1'd0					: (m0_ar_grant_s1)? ARVALID_M0 			: (m1_ar_grant_s1)? ARVALID_M1 			: 1'd0;
	// assign ARID_S1 		= (R_s1_is_m0_active || R_s1_is_m1_active)? {`AXI_IDS_BITS{1'd0}}	: (m0_ar_grant_s1)? {4'd0, ARID_M0}  	: (m1_ar_grant_s1)? {4'd0, ARID_M1} 	: {`AXI_IDS_BITS{1'd0}};
	// assign ARADDR_S1 	= (R_s1_is_m0_active || R_s1_is_m1_active)? {`AXI_ADDR_BITS{1'd0}}	: (m0_ar_grant_s1)? ARADDR_M0 			: (m1_ar_grant_s1)? ARADDR_M1 			: {`AXI_ADDR_BITS{1'd0}};
	// assign ARLEN_S1 	= (R_s1_is_m0_active || R_s1_is_m1_active)? {`AXI_LEN_BITS{1'd0}}	: (m0_ar_grant_s1)? ARLEN_M0 			: (m1_ar_grant_s1)? ARLEN_M1 			: {`AXI_LEN_BITS{1'd0}};
	// assign ARSIZE_S1 	= (R_s1_is_m0_active || R_s1_is_m1_active)? {`AXI_SIZE_BITS{1'd0}}	: (m0_ar_grant_s1)? ARSIZE_M0 			: (m1_ar_grant_s1)? ARSIZE_M1 			: {`AXI_SIZE_BITS{1'd0}};
	// assign ARBURST_S1 	= (R_s1_is_m0_active || R_s1_is_m1_active)? 2'd0					: (m0_ar_grant_s1)? ARBURST_M0 			: (m1_ar_grant_s1)? ARBURST_M1 			: 2'd0;


	// Channel status assignment

	always @ (posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			R_s0_is_m0_active 	<= 1'b0;
			R_s0_is_m1_active 	<= 1'b0;

			R_s1_is_m0_active 	<= 1'b0;
			R_s1_is_m1_active 	<= 1'b0;
		end
		else begin

			// S0 start sending data back to M0
			if((R_s0_is_m0_active == 1'b0) && m0_ar_grant_s0 && ARREADY_S0 && (!R_s0_is_m1_active && !R_s0_is_m2_active))begin
				R_s0_is_m0_active <= 1'b1;
			end
			else if((R_s0_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S0 && RLAST_S0)begin
				R_s0_is_m0_active <= 1'b0;
			end

			// S0 start sending data back to M1
			if((R_s0_is_m1_active == 1'b0) && m1_ar_grant_s0 && ARREADY_S0 && (!R_s0_is_m0_active && !R_s0_is_m2_active))begin
				R_s0_is_m1_active <= 1'b1;
			end
			else if((R_s0_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S0 && RLAST_S0)begin
				R_s0_is_m1_active <= 1'b0;
			end

			if((R_s0_is_m2_active == 1'b0) && m2_ar_grant_s0 && ARREADY_S0 && (!R_s0_is_m0_active && !R_s0_is_m1_active))begin
				R_s0_is_m2_active <= 1'b1;
			end
			else if((R_s0_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S0 && RLAST_S0)begin
				R_s0_is_m2_active <= 1'b0;
			end


			// S1 start sending data back to M0
			if((R_s1_is_m0_active == 1'b0) && m0_ar_grant_s1 && ARREADY_S1 && (!R_s1_is_m1_active && !R_s1_is_m2_active))begin
				R_s1_is_m0_active <= 1'b1;
			end
			else if((R_s1_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S1 && RLAST_S1)begin
				R_s1_is_m0_active <= 1'b0;
			end
			// S1 start sending data back to M1
			if((R_s1_is_m1_active == 1'b0) && m1_ar_grant_s1 && ARREADY_S1 && (!R_s1_is_m0_active && !R_s1_is_m2_active))begin
				R_s1_is_m1_active <= 1'b1;
			end
			else if((R_s1_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S1 && RLAST_S1)begin
				R_s1_is_m1_active <= 1'b0;
			end

			if((R_s1_is_m2_active == 1'b0) && m2_ar_grant_s1 && ARREADY_S1 && (!R_s1_is_m0_active && !R_s1_is_m1_active))begin
				R_s1_is_m2_active <= 1'b1;
			end
			else if((R_s1_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S1 && RLAST_S1)begin
				R_s1_is_m2_active <= 1'b0;
			end

			// S2 start sending data back to M0
			if((R_s2_is_m0_active == 1'b0) && m0_ar_grant_s2 && ARREADY_S2 && (!R_s2_is_m1_active && !R_s2_is_m2_active))begin
				R_s1_is_m0_active <= 1'b1;
			end
			else if((R_s2_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S2 && RLAST_S2)begin
				R_s2_is_m0_active <= 1'b0;
			end
			// S2 start sending data back to M1
			if((R_s2_is_m1_active == 1'b0) && m1_ar_grant_s2 && ARREADY_S2 && (!R_s2_is_m0_active && !R_s2_is_m2_active))begin
				R_s2_is_m1_active <= 1'b1;
			end
			else if((R_s2_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S2 && RLAST_S2)begin
				R_s2_is_m1_active <= 1'b0;
			end
			// S2 start sending data back to M2
			if((R_s2_is_m2_active == 1'b0) && m2_ar_grant_s2 && ARREADY_S2 && (!R_s2_is_m0_active && !R_s2_is_m1_active))begin
				R_s2_is_m2_active <= 1'b1;
			end
			else if((R_s2_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S2 && RLAST_S2)begin
				R_s2_is_m2_active <= 1'b0;
			end

			// S3 start sending data back to M0
			if((R_s3_is_m0_active == 1'b0) && m0_ar_grant_s3 && ARREADY_S3 && (!R_s3_is_m1_active && !R_s3_is_m2_active))begin
				R_s3_is_m0_active <= 1'b1;
			end
			else if((R_s3_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S3 && RLAST_S3)begin
				R_s3_is_m0_active <= 1'b0;
			end
			// S3 start sending data back to M1
			if((R_s3_is_m1_active == 1'b0) && m1_ar_grant_s3 && ARREADY_S3 && (!R_s3_is_m0_active && !R_s3_is_m2_active))begin
				R_s3_is_m1_active <= 1'b1;
			end
			else if((R_s3_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S3 && RLAST_S3)begin
				R_s3_is_m1_active <= 1'b0;
			end
			// S3 start sending data back to M2
			if((R_s3_is_m2_active == 1'b0) && m2_ar_grant_s3 && ARREADY_S3 && (!R_s3_is_m0_active && !R_s3_is_m1_active))begin
				R_s3_is_m2_active <= 1'b1;
			end
			else if((R_s3_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S3 && RLAST_S3)begin
				R_s3_is_m2_active <= 1'b0;
			end  

			// S4 start sending data back to M0
			if((R_s4_is_m0_active == 1'b0) && m0_ar_grant_s4 && ARREADY_S4 && (!R_s4_is_m1_active && !R_s4_is_m2_active))begin
				R_s4_is_m0_active <= 1'b1;
			end
			else if((R_s4_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S4 && RLAST_S4)begin
				R_s4_is_m0_active <= 1'b0;
			end
			// S4 start sending data back to M1
			if((R_s4_is_m1_active == 1'b0) && m1_ar_grant_s4 && ARREADY_S4 && (!R_s4_is_m0_active && !R_s4_is_m2_active))begin
				R_s4_is_m1_active <= 1'b1;
			end
			else if((R_s4_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S4 && RLAST_S4)begin
				R_s4_is_m1_active <= 1'b0;
			end
			// S4 start sending data back to M2
			if((R_s4_is_m2_active == 1'b0) && m2_ar_grant_s4 && ARREADY_S4 && (!R_s4_is_m0_active && !R_s4_is_m1_active))begin
				R_s4_is_m2_active <= 1'b1;
			end
			else if((R_s4_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S4 && RLAST_S4)begin
				R_s4_is_m2_active <= 1'b0;
			end

			// S5 start sending data back to M0
			if((R_s5_is_m0_active == 1'b0) && m0_ar_grant_s5 && ARREADY_S5 && (!R_s5_is_m1_active && !R_s5_is_m2_active))begin
				R_s5_is_m0_active <= 1'b1;
			end
			else if((R_s5_is_m0_active == 1'b1) && RREADY_M0 && RVALID_S5 && RLAST_S5)begin
				R_s5_is_m0_active <= 1'b0;
			end
			// S5 start sending data back to M1
			if((R_s5_is_m1_active == 1'b0) && m1_ar_grant_s5 && ARREADY_S5 && (!R_s5_is_m0_active && !R_s5_is_m2_active))begin
				R_s5_is_m1_active <= 1'b1;
			end
			else if((R_s5_is_m1_active == 1'b1) && RREADY_M1 && RVALID_S5 && RLAST_S5)begin
				R_s5_is_m1_active <= 1'b0;
			end
			// S5 start sending data back to M2
			if((R_s5_is_m2_active == 1'b0) && m2_ar_grant_s5 && ARREADY_S5 && (!R_s5_is_m0_active && !R_s5_is_m1_active))begin
				R_s5_is_m2_active <= 1'b1;
			end
			else if((R_s5_is_m2_active == 1'b1) && RREADY_M2 && RVALID_S5 && RLAST_S5)begin
				R_s5_is_m2_active <= 1'b0;
			end


		end
	end


	// // if M0 tries to access invalid address, bridge blocks it
	// assign ARREADY_M0 = (m0_ar_err_reg)? 1'd1 : ARREADY_S0;
	// assign ARREADY_M1 = (m1_ar_err_reg)? 1'd1 : ARREADY_S0;


	// assign RRESP_M0	= (R_s0_is_m0_active)?	(RREADY_M0 && RVALID_S0)? RRESP_S0 : 2'd0 :
	// 										(R_s1_is_m0_active)?	(RREADY_M0 && RVALID_S1)? RRESP_S1 : 2'd0 :
	// 																// nor s0 and s1 are active -> 



	always @(*)begin


		if(R_s0_is_m0_active)begin
			RID_M0 		= RID_S0[3:0];
			RDATA_M0 	= RDATA_S0;
			RRESP_M0 	= RRESP_S0;	
			RLAST_M0 	= RLAST_S0;
			RVALID_M0	= RVALID_S0;

		end
		else if(R_s1_is_m0_active)begin
			RID_M0 		= RID_S1[3:0];
			RDATA_M0 	= RDATA_S1;
			RRESP_M0 	= RRESP_S1;	
			RLAST_M0 	= RLAST_S1;
			RVALID_M0	= RVALID_S1;
		end
		else if(R_s2_is_m0_active)begin
			RID_M0 		= RID_S2[3:0];
			RDATA_M0 	= RDATA_S2;
			RRESP_M0 	= RRESP_S2;	
			RLAST_M0 	= RLAST_S2;
			RVALID_M0	= RVALID_S2;
		end
		else if(R_s3_is_m0_active)begin
			RID_M0 		= RID_S3[3:0];
			RDATA_M0 	= RDATA_S3;
			RRESP_M0 	= RRESP_S3;	
			RLAST_M0 	= RLAST_S3;
			RVALID_M0	= RVALID_S3;
		end
		else if(R_s4_is_m0_active)begin
			RID_M0 		= RID_S4[3:0];
			RDATA_M0 	= RDATA_S4;
			RRESP_M0 	= RRESP_S4;	
			RLAST_M0 	= RLAST_S4;
			RVALID_M0	= RVALID_S4;
		end
		else if(R_s5_is_m0_active)begin
			RID_M0 		= RID_S5[3:0];
			RDATA_M0 	= RDATA_S5;
			RRESP_M0 	= RRESP_S5;	
			RLAST_M0 	= RLAST_S5;
			RVALID_M0	= RVALID_S5;
		end
		else begin
			RID_M0 		= RID_ERR_M0;
			RDATA_M0 	= RDATA_ERR_M0;
			RRESP_M0 	= RRESP_ERR_M0;
			RLAST_M0 	= RLAST_ERR_M0;
			RVALID_M0	= RVALID_ERR_M0;
		end

		if(R_s0_is_m1_active)begin
			RID_M1 		= RID_S0[3:0];
			RDATA_M1 	= RDATA_S0;
			RRESP_M1 	= RRESP_S0;	
			RLAST_M1 	= RLAST_S0;
			RVALID_M1	= RVALID_S0;

		end
		else if(R_s1_is_m1_active)begin
			RID_M1 		= RID_S1[3:0];
			RDATA_M1 	= RDATA_S1;
			RRESP_M1 	= RRESP_S1;	
			RLAST_M1 	= RLAST_S1;
			RVALID_M1	= RVALID_S1;
		end
		else if(R_s2_is_m1_active)begin
			RID_M1 		= RID_S2[3:0];
			RDATA_M1 	= RDATA_S2;
			RRESP_M1 	= RRESP_S2;	
			RLAST_M1 	= RLAST_S2;
			RVALID_M1	= RVALID_S2;
		end
		else if(R_s3_is_m1_active)begin
			RID_M1 		= RID_S3[3:0];
			RDATA_M1 	= RDATA_S3;
			RRESP_M1 	= RRESP_S3;	
			RLAST_M1 	= RLAST_S3;
			RVALID_M1	= RVALID_S3;
		end
		else if(R_s4_is_m1_active)begin
			RID_M1 		= RID_S4[3:0];
			RDATA_M1 	= RDATA_S4;
			RRESP_M1 	= RRESP_S4;	
			RLAST_M1 	= RLAST_S4;
			RVALID_M1	= RVALID_S4;
		end
		else if(R_s5_is_m1_active)begin
			RID_M1 		= RID_S5[3:0];
			RDATA_M1 	= RDATA_S5;
			RRESP_M1 	= RRESP_S5;	
			RLAST_M1 	= RLAST_S5;
			RVALID_M1	= RVALID_S5;
		end
		else begin
			RID_M1 		= RID_ERR_M0;
			RDATA_M1 	= RDATA_ERR_M0;
			RRESP_M1 	= RRESP_ERR_M0;
			RLAST_M1 	= RLAST_ERR_M0;
			RVALID_M1	= RVALID_ERR_M0;
		end


		if(R_s0_is_m2_active)begin
			RID_M2 		= RID_S0[3:0];
			RDATA_M2 	= RDATA_S0;
			RRESP_M2 	= RRESP_S0;	
			RLAST_M2 	= RLAST_S0;
			RVALID_M2	= RVALID_S0;

		end
		else if(R_s1_is_m2_active)begin
			RID_M2 		= RID_S1[3:0];
			RDATA_M2 	= RDATA_S1;
			RRESP_M2 	= RRESP_S1;	
			RLAST_M2 	= RLAST_S1;
			RVALID_M2	= RVALID_S1;
		end
		else if(R_s2_is_m2_active)begin
			RID_M2 		= RID_S2[3:0];
			RDATA_M2 	= RDATA_S2;
			RRESP_M2 	= RRESP_S2;	
			RLAST_M2 	= RLAST_S2;
			RVALID_M2	= RVALID_S2;
		end
		else if(R_s3_is_m2_active)begin
			RID_M2 		= RID_S3[3:0];
			RDATA_M2 	= RDATA_S3;
			RRESP_M2 	= RRESP_S3;	
			RLAST_M2 	= RLAST_S3;
			RVALID_M2	= RVALID_S3;
		end
		else if(R_s4_is_m2_active)begin
			RID_M2 		= RID_S4[3:0];
			RDATA_M2 	= RDATA_S4;
			RRESP_M2 	= RRESP_S4;	
			RLAST_M2 	= RLAST_S4;
			RVALID_M2	= RVALID_S4;
		end
		else if(R_s5_is_m2_active)begin
			RID_M2 		= RID_S5[3:0];
			RDATA_M2 	= RDATA_S5;
			RRESP_M2 	= RRESP_S5;	
			RLAST_M2 	= RLAST_S5;
			RVALID_M2	= RVALID_S5;
		end
		else begin
			RID_M2 		= RID_ERR_M0;
			RDATA_M2 	= RDATA_ERR_M0;
			RRESP_M2 	= RRESP_ERR_M0;
			RLAST_M2 	= RLAST_ERR_M0;
			RVALID_M2	= RVALID_ERR_M0;
		end
	end

	assign RREADY_S0	= R_s0_is_m0_active? RREADY_M0 	: R_s0_is_m1_active? RREADY_M1 : R_s0_is_m2_active?	RREADY_M2 : 1'd0;
	assign RREADY_S1 	= R_s1_is_m0_active? RREADY_M0 	: R_s1_is_m1_active? RREADY_M1 : R_s1_is_m2_active? RREADY_M2 : 1'd0;
	assign RREADY_S2 	= R_s2_is_m0_active? RREADY_M0 	: R_s2_is_m1_active? RREADY_M1 : R_s2_is_m2_active? RREADY_M2 : 1'd0;
	assign RREADY_S3 	= R_s3_is_m0_active? RREADY_M0 	: R_s3_is_m1_active? RREADY_M1 : R_s3_is_m2_active? RREADY_M2 : 1'd0;
	assign RREADY_S4 	= R_s4_is_m0_active? RREADY_M0 	: R_s4_is_m1_active? RREADY_M1 : R_s4_is_m2_active? RREADY_M2 : 1'd0;
	assign RREADY_S5 	= R_s5_is_m0_active? RREADY_M0 	: R_s5_is_m1_active? RREADY_M1 : R_s5_is_m2_active? RREADY_M2 : 1'd0;


	// assign RID_M0 		= R_s0_is_m0_active? RID_S0[3:0] 	: R_s1_is_m0_active? RID_S1[3:0] 	: RID_ERR_M0;
	// assign RDATA_M0 	= R_s0_is_m0_active? RDATA_S0		: R_s1_is_m0_active? RDATA_S1 		: RDATA_ERR_M0;
	// assign RRESP_M0 	= R_s0_is_m0_active? RRESP_S0		: R_s1_is_m0_active? RRESP_S1 		: RRESP_ERR_M0;
	// assign RLAST_M0 	= R_s0_is_m0_active? RLAST_S0		: R_s1_is_m0_active? RLAST_S1		: RLAST_ERR_M0;
	// assign RVALID_M0 	= R_s0_is_m0_active? RVALID_S0 		: R_s1_is_m0_active? RVALID_S1 		: RVALID_ERR_M0;

	// assign RID_M1 		= R_s0_is_m1_active? RID_S0[3:0] 	: R_s1_is_m1_active? RID_S1[3:0] 	: RID_ERR_M1;
	// assign RDATA_M1 	= R_s0_is_m1_active? RDATA_S0		: R_s1_is_m1_active? RDATA_S1 		: RDATA_ERR_M1;
	// assign RRESP_M1 	= R_s0_is_m1_active? RRESP_S0		: R_s1_is_m1_active? RRESP_S1 		: RRESP_ERR_M1;
	// assign RLAST_M1 	= R_s0_is_m1_active? RLAST_S0		: R_s1_is_m1_active? RLAST_S1		: RLAST_ERR_M1;
	// assign RVALID_M1 	= R_s0_is_m1_active? RVALID_S0 		: R_s1_is_m1_active? RVALID_S1 		: RVALID_ERR_M1;


    //======================================================================
    //== 3.2 AW & W
    //======================================================================

	// Channel status assignment
	reg W_s0_active, W_s1_active; // s0/s1 only receive data from m1
	reg B_s0_active, B_s1_active;

	reg B_s1_is_m1_active, B_s2_is_m1_active, B_s3_is_m1_active, B_s4_is_m1_active, B_s5_is_m1_active;
	reg B_s1_is_m2_active, B_s2_is_m2_active, B_s3_is_m2_active, B_s4_is_m2_active, B_s5_is_m2_active;


	wire W_s1_is_m1_collid_cond = (!W_s2_is_m1_active && !W_s3_is_m1_active && !W_s4_is_m1_active && !W_s5_is_m1_active);
	wire W_s2_is_m1_collid_cond = (!W_s1_is_m1_active && !W_s3_is_m1_active && !W_s4_is_m1_active && !W_s5_is_m1_active);
	wire W_s3_is_m1_collid_cond = (!W_s1_is_m1_active && !W_s2_is_m1_active && !W_s4_is_m1_active && !W_s5_is_m1_active);
	wire W_s4_is_m1_collid_cond = (!W_s1_is_m1_active && !W_s2_is_m1_active && !W_s3_is_m1_active && !W_s5_is_m1_active);
	wire W_s5_is_m1_collid_cond = (!W_s1_is_m1_active && !W_s2_is_m1_active && !W_s3_is_m1_active && !W_s4_is_m1_active);

	wire W_s1_is_m2_collid_cond = (!W_s2_is_m2_active && !W_s3_is_m2_active && !W_s4_is_m2_active && !W_s5_is_m2_active);
	wire W_s2_is_m2_collid_cond = (!W_s1_is_m2_active && !W_s3_is_m2_active && !W_s4_is_m2_active && !W_s5_is_m2_active);
	wire W_s3_is_m2_collid_cond = (!W_s1_is_m2_active && !W_s2_is_m2_active && !W_s4_is_m2_active && !W_s5_is_m2_active);
	wire W_s4_is_m2_collid_cond = (!W_s1_is_m2_active && !W_s2_is_m2_active && !W_s3_is_m2_active && !W_s5_is_m2_active);
	wire W_s5_is_m2_collid_cond = (!W_s1_is_m2_active && !W_s2_is_m2_active && !W_s3_is_m2_active && !W_s4_is_m2_active);



	always @ (posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			W_s0_active <= 1'b0;
			W_s1_active <= 1'b0;

			B_s0_active <= 1'b0;
			B_s1_active <= 1'b0;
		end
		else begin

			// S0 start listening data from M1

			// if((W_s0_active == 1'b1 || (m1_aw_req_s0 && AWREADY_S0 && (!W_s1_active))) && WREADY_S0 && WVALID_M1 && WLAST_M1)begin
			// 	W_s0_active <= 1'b0;
			// 	B_s0_active <= 1'b1;
			// end
			// else if((W_s0_active == 1'b0) && m1_aw_req_s0 && AWREADY_S0 && (!W_s1_active))begin
			// 	W_s0_active <= 1'b1;
			// end
			// else if((B_s0_active == 1'b1) && BVALID_S0 && BREADY_M1)begin
			// 	B_s0_active <= 1'b0;
			// end

			if((W_s1_is_m1_active == 1'b1 || WREADY_S1 && WVALID_M1 && WLAST_M1 && (m1_aw_grant_s1 && AWREADY_S1 && !W_s1_is_m2_active)))begin
				W_s1_is_m1_active 		<= 1'b0;
				B_s1_is_m1_active 		<= 1'b1;
			end 
			else if((W_s1_is_m1_active == 1'b0) && m1_aw_grant_s1 && AWREADY_S1 && !W_s1_is_m2_active)begin
				W_s1_is_m1_active 		<= 1'b1;
			end
			else if((B_s1_is_m1_active == 1'b1) && BVALID_S1 && BREADY_M1)begin
				B_s1_is_m1_active 		<= 1'b0;
			end

			if((W_s1_is_m2_active == 1'b1 || WREADY_S1 && WVALID_M2 && WLAST_M2 && (m2_aw_grant_s1 && AWREADY_S1 && !W_s1_is_m1_active)))begin
				W_s1_is_m2_active 		<= 1'b0;
				B_s1_is_m2_active 		<= 1'b1;
			end 
			else if((W_s1_is_m2_active == 1'b0) && m2_aw_grant_s1 && AWREADY_S1 && !W_s1_is_m1_active)begin
				W_s1_is_m2_active 		<= 1'b1;
			end
			else if((B_s1_is_m2_active == 1'b1) && BVALID_S1 && BREADY_M2)begin
				B_s1_is_m2_active 		<= 1'b0;
			end


			/**************** S2 Writing ***************/
			if((W_s2_is_m1_active == 1'b1 || WREADY_S2 && WVALID_M1 && WLAST_M1 && (m1_aw_grant_s2 && AWREADY_S2 && !W_s2_is_m2_active)))begin
				W_s2_is_m1_active 		<= 1'b0;
				B_s2_is_m1_active 		<= 1'b1;
			end 
			else if((W_s2_is_m1_active == 1'b0) && m1_aw_grant_s2 && AWREADY_S2 && !W_s2_is_m2_active)begin
				W_s2_is_m1_active 		<= 1'b1;
			end
			else if((B_s2_is_m1_active == 1'b1) && BVALID_S2 && BREADY_M1)begin
				B_s2_is_m1_active 		<= 1'b0;
			end

			if((W_s2_is_m2_active == 1'b1 || WREADY_S2 && WVALID_M2 && WLAST_M2 && (m2_aw_grant_s2 && AWREADY_S2 && !W_s2_is_m1_active)))begin
				W_s2_is_m2_active 		<= 1'b0;
				B_s2_is_m2_active 		<= 1'b1;
			end 
			else if((W_s2_is_m2_active == 1'b0) && m2_aw_grant_s2 && AWREADY_S2 && !W_s2_is_m1_active)begin
				W_s2_is_m2_active 		<= 1'b1;
			end
			else if((B_s2_is_m2_active == 1'b1) && BVALID_S2 && BREADY_M2)begin
				B_s2_is_m2_active 		<= 1'b0;
			end

			/**************** S3 Writing ***************/
			if((W_s3_is_m1_active == 1'b1 || WREADY_S3 && WVALID_M1 && WLAST_M1 && (m1_aw_grant_s3 && AWREADY_S3 && !W_s3_is_m2_active)))begin
				W_s3_is_m1_active 		<= 1'b0;
				B_s3_is_m1_active 		<= 1'b1;
			end 
			else if((W_s3_is_m1_active == 1'b0) && m1_aw_grant_s3 && AWREADY_S3 && !W_s3_is_m2_active)begin
				W_s3_is_m1_active 		<= 1'b1;
			end
			else if((B_s3_is_m1_active == 1'b1) && BVALID_S3 && BREADY_M1)begin
				B_s3_is_m1_active 		<= 1'b0;
			end

			if((W_s3_is_m2_active == 1'b1 || WREADY_S3 && WVALID_M2 && WLAST_M2 && (m2_aw_grant_s3 && AWREADY_S3 && !W_s3_is_m1_active)))begin
				W_s3_is_m2_active 		<= 1'b0;
				B_s3_is_m2_active 		<= 1'b1;
			end 
			else if((W_s3_is_m2_active == 1'b0) && m2_aw_grant_s3 && AWREADY_S3 && !W_s3_is_m1_active)begin
				W_s3_is_m2_active 		<= 1'b1;
			end
			else if((B_s3_is_m2_active == 1'b1) && BVALID_S3 && BREADY_M2)begin
				B_s3_is_m2_active 		<= 1'b0;
			end

			/**************** S4 Writing ***************/
			if((W_s4_is_m1_active == 1'b1 || WREADY_S4 && WVALID_M1 && WLAST_M1 && (m1_aw_grant_s4 && AWREADY_S4 && !W_s4_is_m2_active)))begin
				W_s4_is_m1_active 		<= 1'b0;
				B_s4_is_m1_active 		<= 1'b1;
			end 
			else if((W_s4_is_m1_active == 1'b0) && m1_aw_grant_s4 && AWREADY_S4 && !W_s4_is_m2_active)begin
				W_s4_is_m1_active 		<= 1'b1;
			end
			else if((B_s4_is_m1_active == 1'b1) && BVALID_S4 && BREADY_M1)begin
				B_s4_is_m1_active 		<= 1'b0;
			end

			if((W_s4_is_m2_active == 1'b1 || WREADY_S4 && WVALID_M2 && WLAST_M2 && (m2_aw_grant_s4 && AWREADY_S4 && !W_s4_is_m1_active)))begin
				W_s4_is_m2_active 		<= 1'b0;
				B_s4_is_m2_active 		<= 1'b1;
			end 
			else if((W_s4_is_m2_active == 1'b0) && m2_aw_grant_s4 && AWREADY_S4 && !W_s4_is_m1_active)begin
				W_s4_is_m2_active 		<= 1'b1;
			end
			else if((B_s4_is_m2_active == 1'b1) && BVALID_S4 && BREADY_M2)begin
				B_s4_is_m2_active 		<= 1'b0;
			end

			/**************** S5 Writing ***************/
			if((W_s5_is_m1_active == 1'b1 || WREADY_S5 && WVALID_M1 && WLAST_M1 && (m1_aw_grant_s5 && AWREADY_S5 && !W_s5_is_m2_active)))begin
				W_s5_is_m1_active 		<= 1'b0;
				B_s5_is_m1_active 		<= 1'b1;
			end 
			else if((W_s5_is_m1_active == 1'b0) && m1_aw_grant_s5 && AWREADY_S5 && !W_s5_is_m2_active)begin
				W_s5_is_m1_active 		<= 1'b1;
			end
			else if((B_s5_is_m1_active == 1'b1) && BVALID_S5 && BREADY_M1)begin
				B_s5_is_m1_active 		<= 1'b0;
			end

			if((W_s5_is_m2_active == 1'b1 || WREADY_S5 && WVALID_M2 && WLAST_M2 && (m2_aw_grant_s5 && AWREADY_S5 && !W_s5_is_m1_active)))begin
				W_s5_is_m2_active 		<= 1'b0;
				B_s5_is_m2_active 		<= 1'b1;
			end 
			else if((W_s5_is_m2_active == 1'b0) && m2_aw_grant_s5 && AWREADY_S5 && !W_s5_is_m1_active)begin
				W_s5_is_m2_active 		<= 1'b1;
			end
			else if((B_s5_is_m2_active == 1'b1) && BVALID_S5 && BREADY_M2)begin
				B_s5_is_m2_active 		<= 1'b0;
			end


			// S1 start listening data from M1
			// if((W_s1_active == 1'b1 || (m1_aw_req_s1 && AWREADY_S1 && (!W_s1_active))) && WREADY_S1 && WVALID_M1 && WLAST_M1)begin
			// 	W_s1_active <= 1'b0;
			// 	B_s1_active <= 1'b1;
			// end
			// else if((W_s1_active == 1'b0) && m1_aw_req_s1 && AWREADY_S1 && (!W_s0_active))begin
			// 	W_s1_active <= 1'b1;
			// end
			// else if((B_s1_active == 1'b1) && BVALID_S1 && BREADY_M1)begin
			// 	B_s1_active <= 1'b0;
			// end
			
			// if((B_s1_active == 1'b0) && m1_aw_req_s1 && AWREADY_S1 && (!B_s0_active))begin
			// 	B_s1_active <= 1'b1;
			// end
			// else if((B_s1_active == 1'b1) && BVALID_S1 && BREADY_M1)begin
			// 	B_s1_active <= 1'b0;
			// end

		end
	end

	// assign AWREADY_M1 	= (m1_aw_req_s0)? AWREADY_S0 	: (m1_aw_req_s1)? AWREADY_S1 : (m1_aw_req_err)? 1'b1 : 1'b0;

	always @(*)begin

		if(m1_aw_grant_s1)begin
			AWREADY_M1 	= AWREADY_S1;
		end
		else if(m1_aw_grant_s2)begin
			AWREADY_M1 	= AWREADY_S2;
		end
		else if(m1_aw_grant_s3)begin
			AWREADY_M1 	= AWREADY_S3;
		end
		else if(m1_aw_grant_s4)begin
			AWREADY_M1 	= AWREADY_S4;
		end
		else if(m1_aw_grant_s5)begin
			AWREADY_M1 	= AWREADY_S5;
		end
		else if(m1_aw_req_err)begin
			AWREADY_M1 	= 1'b1;
		end
		else begin
			AWREADY_M1 	= 1'b0;
		end

		if(m2_aw_grant_s1)begin
			AWREADY_M2 	= AWREADY_S1;
		end
		else if(m2_aw_grant_s2)begin
			AWREADY_M2 	= AWREADY_S2;
		end
		else if(m2_aw_grant_s3)begin
			AWREADY_M2 	= AWREADY_S3;
		end
		else if(m2_aw_grant_s4)begin
			AWREADY_M2 	= AWREADY_S4;
		end
		else if(m2_aw_grant_s5)begin
			AWREADY_M2 	= AWREADY_S5;
		end
		else if(m2_aw_req_err)begin
			AWREADY_M2 	= 1'b1;
		end
		else begin
			AWREADY_M2 	= 1'b0;
		end
	end

	assign AWVALID_S1 	= (m1_aw_grant_s1)? AWVALID_M1 			: (m2_aw_grant_s1)? AWVALID_M2 		: 1'd0;
	assign AWID_S1 		= (m1_aw_grant_s1)? {4'd0, AWID_M1} 	: (m2_aw_grant_s1)? {4'd0, AWID_M2} : {`AXI_IDS_BITS{1'd0}};
	assign AWADDR_S1 	= (m1_aw_grant_s1)? AWADDR_M1 			: (m2_aw_grant_s1)? AWADDR_M2 		: {`AXI_ADDR_BITS{1'd0}};
	assign AWLEN_S1 	= (m1_aw_grant_s1)? AWLEN_M1 			: (m2_aw_grant_s1)? AWLEN_M2 		: {`AXI_LEN_BITS{1'd0}};
	assign AWSIZE_S1 	= (m1_aw_grant_s1)? AWSIZE_M1 			: (m2_aw_grant_s1)? AWSIZE_M2 		: {`AXI_SIZE_BITS{1'd0}};
	assign AWBURST_S1 	= (m1_aw_grant_s1)? AWBURST_M1 			: (m2_aw_grant_s1)? AWBURST_M2 		: 2'd0;

	assign AWVALID_S2 	= (m1_aw_grant_s2)? AWVALID_M1 			: (m2_aw_grant_s2)? AWVALID_M2 		: 1'd0;
	assign AWID_S2 		= (m1_aw_grant_s2)? {4'd0, AWID_M1} 	: (m2_aw_grant_s2)? {4'd0, AWID_M2} : {`AXI_IDS_BITS{1'd0}};
	assign AWADDR_S2 	= (m1_aw_grant_s2)? AWADDR_M1 			: (m2_aw_grant_s2)? AWADDR_M2 		: {`AXI_ADDR_BITS{1'd0}};
	assign AWLEN_S2 	= (m1_aw_grant_s2)? AWLEN_M1 			: (m2_aw_grant_s2)? AWLEN_M2 		: {`AXI_LEN_BITS{1'd0}};
	assign AWSIZE_S2 	= (m1_aw_grant_s2)? AWSIZE_M1 			: (m2_aw_grant_s2)? AWSIZE_M2 		: {`AXI_SIZE_BITS{1'd0}};
	assign AWBURST_S2 	= (m1_aw_grant_s2)? AWBURST_M1 			: (m2_aw_grant_s2)? AWBURST_M2 		: 2'd0;

	assign AWVALID_S3 	= (m1_aw_grant_s3)? AWVALID_M1 			: (m2_aw_grant_s3)? AWVALID_M2 		: 1'd0;
	assign AWID_S3 		= (m1_aw_grant_s3)? {4'd0, AWID_M1} 	: (m2_aw_grant_s3)? {4'd0, AWID_M2} : {`AXI_IDS_BITS{1'd0}};
	assign AWADDR_S3 	= (m1_aw_grant_s3)? AWADDR_M1 			: (m2_aw_grant_s3)? AWADDR_M2 		: {`AXI_ADDR_BITS{1'd0}};
	assign AWLEN_S3 	= (m1_aw_grant_s3)? AWLEN_M1 			: (m2_aw_grant_s3)? AWLEN_M2 		: {`AXI_LEN_BITS{1'd0}};
	assign AWSIZE_S3 	= (m1_aw_grant_s3)? AWSIZE_M1 			: (m2_aw_grant_s3)? AWSIZE_M2 		: {`AXI_SIZE_BITS{1'd0}};
	assign AWBURST_S3 	= (m1_aw_grant_s3)? AWBURST_M1 			: (m2_aw_grant_s3)? AWBURST_M2 		: 2'd0;

	assign AWVALID_S4 	= (m1_aw_grant_s4)? AWVALID_M1 			: (m2_aw_grant_s4)? AWVALID_M2 		: 1'd0;
	assign AWID_S4 		= (m1_aw_grant_s4)? {4'd0, AWID_M1} 	: (m2_aw_grant_s4)? {4'd0, AWID_M2} : {`AXI_IDS_BITS{1'd0}};
	assign AWADDR_S4 	= (m1_aw_grant_s4)? AWADDR_M1 			: (m2_aw_grant_s4)? AWADDR_M2 		: {`AXI_ADDR_BITS{1'd0}};
	assign AWLEN_S4 	= (m1_aw_grant_s4)? AWLEN_M1 			: (m2_aw_grant_s4)? AWLEN_M2 		: {`AXI_LEN_BITS{1'd0}};
	assign AWSIZE_S4 	= (m1_aw_grant_s4)? AWSIZE_M1 			: (m2_aw_grant_s4)? AWSIZE_M2 		: {`AXI_SIZE_BITS{1'd0}};
	assign AWBURST_S4 	= (m1_aw_grant_s4)? AWBURST_M1 			: (m2_aw_grant_s4)? AWBURST_M2 		: 2'd0;

	assign AWVALID_S5 	= (m1_aw_grant_s5)? AWVALID_M1 			: (m2_aw_grant_s5)? AWVALID_M2 		: 1'd0;
	assign AWID_S5 		= (m1_aw_grant_s5)? {4'd0, AWID_M1} 	: (m2_aw_grant_s5)? {4'd0, AWID_M2} : {`AXI_IDS_BITS{1'd0}};
	assign AWADDR_S5 	= (m1_aw_grant_s5)? AWADDR_M1 			: (m2_aw_grant_s5)? AWADDR_M2 		: {`AXI_ADDR_BITS{1'd0}};
	assign AWLEN_S5 	= (m1_aw_grant_s5)? AWLEN_M1 			: (m2_aw_grant_s5)? AWLEN_M2 		: {`AXI_LEN_BITS{1'd0}};
	assign AWSIZE_S5 	= (m1_aw_grant_s5)? AWSIZE_M1 			: (m2_aw_grant_s5)? AWSIZE_M2 		: {`AXI_SIZE_BITS{1'd0}};
	assign AWBURST_S5 	= (m1_aw_grant_s5)? AWBURST_M1 			: (m2_aw_grant_s5)? AWBURST_M2 		: 2'd0;


	// assign AWVALID_S0 	= (m1_aw_req_s0)? AWVALID_M1 			: 1'd0;
	// assign AWID_S0 		= (m1_aw_req_s0)? {4'd0, AWID_M1} 		: {`AXI_IDS_BITS{1'd0}};
	// assign AWADDR_S0 	= (m1_aw_req_s0)? AWADDR_M1 			: {`AXI_ADDR_BITS{1'd0}};
	// assign AWLEN_S0 	= (m1_aw_req_s0)? AWLEN_M1 				: {`AXI_LEN_BITS{1'd0}};
	// assign AWSIZE_S0 	= (m1_aw_req_s0)? AWSIZE_M1 			: {`AXI_SIZE_BITS{1'd0}};
	// assign AWBURST_S0 	= (m1_aw_req_s0)? AWBURST_M1 			: 2'd0;

	// assign AWVALID_S1 	= (m1_aw_req_s1)? AWVALID_M1 			: 1'd0;
	// assign AWID_S1 		= (m1_aw_req_s1)? {4'd0, AWID_M1} 		: {`AXI_IDS_BITS{1'd0}};
	// assign AWADDR_S1 	= (m1_aw_req_s1)? AWADDR_M1 			: {`AXI_ADDR_BITS{1'd0}};
	// assign AWLEN_S1 	= (m1_aw_req_s1)? AWLEN_M1 				: {`AXI_LEN_BITS{1'd0}};
	// assign AWSIZE_S1 	= (m1_aw_req_s1)? AWSIZE_M1 			: {`AXI_SIZE_BITS{1'd0}};
	// assign AWBURST_S1 	= (m1_aw_req_s1)? AWBURST_M1 			: 2'd0;



	always @(*)begin
		if(W_s1_is_m1_active || m1_aw_grant_s1)begin
			WREADY_M1 	= WREADY_S1;
		end
		else if(W_s2_is_m1_active || m1_aw_grant_s2)begin
			WREADY_M1	= WREADY_S2;
		end
		else if(W_s3_is_m1_active || m1_aw_grant_s3)begin
			WREADY_M1 	= WREADY_S3;
		end
		else if(W_s4_is_m1_active || m1_aw_grant_s4)begin
			WREADY_M1 	= WREADY_S4;
		end
		else if(W_s5_is_m1_active || m1_aw_grant_s5)begin
			WREADY_M1 	= WREADY_S5;
		end
		else if(w_err_m1 || m1_aw_req_err)begin
			WREADY_M1 	= 1'b1;
		end
		else begin
			WREADY_M1 	= 1'b0;
		end

		if(W_s1_is_m2_active || m2_aw_grant_s2)begin
			WREADY_M2 	= WREADY_S1;
		end
		else if(W_s2_is_m2_active || m2_aw_grant_s2)begin
			WREADY_M2	= WREADY_S2;
		end
		else if(W_s3_is_m2_active || m2_aw_grant_s3)begin
			WREADY_M2 	= WREADY_S3;
		end
		else if(W_s4_is_m2_active || m2_aw_grant_s4)begin
			WREADY_M2 	= WREADY_S4;
		end
		else if(W_s5_is_m2_active || m2_aw_grant_s5)begin
			WREADY_M2 	= WREADY_S5;
		end
		else if(w_err_m2 || m2_aw_req_err)begin
			WREADY_M2 	= 1'b1;
		end
		else begin
			WREADY_M2 	= 1'b0;
		end

	end


	// assign WREADY_M1 	= (W_s0_active || m1_aw_req_s0)? WREADY_S0 : (W_s1_active || m1_aw_req_s1)? WREADY_S1 : (w_err || m1_aw_req_err)? 1'd1 : 1'd0;




	// assign WDATA_S0 	= (W_s0_active || m1_aw_req_s0)? WDATA_M1 	: {`AXI_DATA_BITS{1'b0}};
	// assign WSTRB_S0 	= (W_s0_active || m1_aw_req_s0)? WSTRB_M1 	: {`AXI_STRB_BITS{1'b0}};
	// assign WLAST_S0 	= (W_s0_active || m1_aw_req_s0)? WLAST_M1 	: 1'b0;
	// assign WVALID_S0 	= (W_s0_active || m1_aw_req_s0)? WVALID_M1 	: 1'b0;

	// assign WDATA_S1 	= (W_s1_active || m1_aw_req_s1)? WDATA_M1 	: {`AXI_DATA_BITS{1'b0}};
	// assign WSTRB_S1 	= (W_s1_active || m1_aw_req_s1)? WSTRB_M1 	: {`AXI_STRB_BITS{1'b0}};
	// assign WLAST_S1 	= (W_s1_active || m1_aw_req_s1)? WLAST_M1 	: 1'b0;
	// assign WVALID_S1 	= (W_s1_active || m1_aw_req_s1)? WVALID_M1 	: 1'b0;


	assign WDATA_S1 	= (W_s1_is_m1_active || m1_aw_grant_s1)? WDATA_M1 	: (W_s1_is_m2_active || m2_aw_grant_s1)? WDATA_M2 	: {`AXI_DATA_BITS{1'b0}};
	assign WSTRB_S1 	= (W_s1_is_m1_active || m1_aw_grant_s1)? WSTRB_M1 	: (W_s1_is_m2_active || m2_aw_grant_s1)? WDATA_M2 	: {`AXI_STRB_BITS{1'b0}};
	assign WLAST_S1 	= (W_s1_is_m1_active || m1_aw_grant_s1)? WLAST_M1 	: (W_s1_is_m2_active || m2_aw_grant_s1)? WLAST_M2 	: 1'b0;
	assign WVALID_S1 	= (W_s1_is_m1_active || m1_aw_grant_s1)? WVALID_M1 	: (W_s1_is_m2_active || m2_aw_grant_s1)? WVALID_M2 	: 1'b0;

	assign WDATA_S2 	= (W_s2_is_m1_active || m1_aw_grant_s2)? WDATA_M1 	: (W_s2_is_m2_active || m2_aw_grant_s2)? WDATA_M2 	: {`AXI_DATA_BITS{1'b0}};
	assign WSTRB_S2 	= (W_s2_is_m1_active || m1_aw_grant_s2)? WSTRB_M1 	: (W_s2_is_m2_active || m2_aw_grant_s2)? WDATA_M2 	: {`AXI_STRB_BITS{1'b0}};
	assign WLAST_S2 	= (W_s2_is_m1_active || m1_aw_grant_s2)? WLAST_M1 	: (W_s2_is_m2_active || m2_aw_grant_s2)? WLAST_M2 	: 1'b0;
	assign WVALID_S2 	= (W_s2_is_m1_active || m1_aw_grant_s2)? WVALID_M1 	: (W_s2_is_m2_active || m2_aw_grant_s2)? WVALID_M2 	: 1'b0;

	assign WDATA_S3 	= (W_s3_is_m1_active || m1_aw_grant_s3)? WDATA_M1 	: (W_s3_is_m2_active || m2_aw_grant_s3)? WDATA_M2 	: {`AXI_DATA_BITS{1'b0}};
	assign WSTRB_S3 	= (W_s3_is_m1_active || m1_aw_grant_s3)? WSTRB_M1 	: (W_s3_is_m2_active || m2_aw_grant_s3)? WDATA_M2 	: {`AXI_STRB_BITS{1'b0}};
	assign WLAST_S3 	= (W_s3_is_m1_active || m1_aw_grant_s3)? WLAST_M1 	: (W_s3_is_m2_active || m2_aw_grant_s3)? WLAST_M2 	: 1'b0;
	assign WVALID_S3 	= (W_s3_is_m1_active || m1_aw_grant_s3)? WVALID_M1 	: (W_s3_is_m2_active || m2_aw_grant_s3)? WVALID_M2 	: 1'b0;

	assign WDATA_S4 	= (W_s4_is_m1_active || m1_aw_grant_s4)? WDATA_M1 	: (W_s4_is_m2_active || m2_aw_grant_s4)? WDATA_M2 	: {`AXI_DATA_BITS{1'b0}};
	assign WSTRB_S4 	= (W_s4_is_m1_active || m1_aw_grant_s4)? WSTRB_M1 	: (W_s4_is_m2_active || m2_aw_grant_s4)? WDATA_M2 	: {`AXI_STRB_BITS{1'b0}};
	assign WLAST_S4 	= (W_s4_is_m1_active || m1_aw_grant_s4)? WLAST_M1 	: (W_s4_is_m2_active || m2_aw_grant_s4)? WLAST_M2 	: 1'b0;
	assign WVALID_S4 	= (W_s4_is_m1_active || m1_aw_grant_s4)? WVALID_M1 	: (W_s4_is_m2_active || m2_aw_grant_s4)? WVALID_M2 	: 1'b0;

	assign WDATA_S5 	= (W_s5_is_m1_active || m1_aw_grant_s5)? WDATA_M1 	: (W_s5_is_m2_active || m2_aw_grant_s5)? WDATA_M2 	: {`AXI_DATA_BITS{1'b0}};
	assign WSTRB_S5 	= (W_s5_is_m1_active || m1_aw_grant_s5)? WSTRB_M1 	: (W_s5_is_m2_active || m2_aw_grant_s5)? WDATA_M2 	: {`AXI_STRB_BITS{1'b0}};
	assign WLAST_S5 	= (W_s5_is_m1_active || m1_aw_grant_s5)? WLAST_M1 	: (W_s5_is_m2_active || m2_aw_grant_s5)? WLAST_M2 	: 1'b0;
	assign WVALID_S5 	= (W_s5_is_m1_active || m1_aw_grant_s5)? WVALID_M1 	: (W_s5_is_m2_active || m2_aw_grant_s5)? WVALID_M2 	: 1'b0;

	


    //======================================================================
    //== 3.3 B
    //======================================================================

	assign BREADY_S1 	= B_s1_is_m1_active? BREADY_M1 : B_s1_is_m2_active? BREADY_M2 : 1'b0;
	assign BREADY_S2 	= B_s2_is_m1_active? BREADY_M1 : B_s2_is_m2_active? BREADY_M2 : 1'b0;
	assign BREADY_S3 	= B_s3_is_m1_active? BREADY_M1 : B_s3_is_m2_active? BREADY_M2 : 1'b0;
	assign BREADY_S4 	= B_s4_is_m1_active? BREADY_M1 : B_s4_is_m2_active? BREADY_M2 : 1'b0;
	assign BREADY_S5 	= B_s5_is_m1_active? BREADY_M1 : B_s5_is_m2_active? BREADY_M2 : 1'b0;

	always @(*)begin
		if(B_s1_is_m1_active)begin
			BID_M1 		= BID_S1[3:0];
			BRESP_M1 	= BRESP_S1;
			BVALID_M1 	= BVALID_S1;
		end
		else if(B_s2_is_m1_active)begin
			BID_M1 		= BID_S2[3:0];
			BRESP_M1 	= BRESP_S2;
			BVALID_M1 	= BVALID_S2;
		end
		else if(B_s3_is_m1_active)begin
			BID_M1 		= BID_S2[3:0];
			BRESP_M1 	= BRESP_S2;
			BVALID_M1 	= BVALID_S2;
		end
		else if(B_s4_is_m1_active)begin
			BID_M1 		= BID_S2[3:0];
			BRESP_M1 	= BRESP_S2;
			BVALID_M1 	= BVALID_S2;
		end
		else if(B_s5_is_m1_active)begin
			BID_M1 		= BID_S2[3:0];
			BRESP_M1 	= BRESP_S2;
			BVALID_M1 	= BVALID_S2;
		end
		else if(b_err_m1)begin
			BID_M1 		= BID_ERR;
			BRESP_M1 	= BRESP_ERR;
			BVALID_M1 	= BVALID_ERR;
		end
		else begin
			BID_M1 		= {`AXI_ID_BITS{1'b0}};
			BRESP_M1 	= 2'b00;
			BVALID_M1 	= 1'b0;
		end

		if(B_s1_is_m2_active)begin
			BID_M2 		= BID_S1[3:0];
			BRESP_M2 	= BRESP_S1;
			BVALID_M2 	= BVALID_S1;
		end
		else if(B_s2_is_m2_active)begin
			BID_M2 		= BID_S2[3:0];
			BRESP_M2 	= BRESP_S2;
			BVALID_M2 	= BVALID_S2;
		end
		else if(B_s3_is_m2_active)begin
			BID_M2 		= BID_S2[3:0];
			BRESP_M2 	= BRESP_S2;
			BVALID_M2 	= BVALID_S2;
		end
		else if(B_s4_is_m2_active)begin
			BID_M2 		= BID_S2[3:0];
			BRESP_M2 	= BRESP_S2;
			BVALID_M2 	= BVALID_S2;
		end
		else if(B_s5_is_m2_active)begin
			BID_M2 		= BID_S2[3:0];
			BRESP_M2 	= BRESP_S2;
			BVALID_M2 	= BVALID_S2;
		end
		else if(b_err_m1)begin
			BID_M2 		= BID_ERR;
			BRESP_M2 	= BRESP_ERR;
			BVALID_M2 	= BVALID_ERR;
		end
		else begin
			BID_M2 		= {`AXI_ID_BITS{1'b0}};
			BRESP_M2 	= 2'b00;
			BVALID_M2 	= 1'b0;
		end

	end



	// assign BREADY_S0 	= B_s0_active? BREADY_M1 : 1'b0;
	// assign BREADY_S1 	= B_s1_active? BREADY_M1 : 1'b0;

	// assign BID_M1 		= B_s0_active? BID_S0[3:0] 	: B_s1_active? BID_S1[3:0] 	: b_err? BID_ERR 		: {`AXI_ID_BITS{1'b0}};
	// assign BRESP_M1 	= B_s0_active? BRESP_S0 	: B_s1_active? BRESP_S1 	: b_err? BRESP_ERR 		: 2'b00;
	// assign BVALID_M1 	= B_s0_active? BVALID_S0 	: B_s1_active? BVALID_S1 	: b_err? BVALID_ERR 	: 1'b0;



endmodule
