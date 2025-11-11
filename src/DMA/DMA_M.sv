`include "./include/AXI_define.svh"

module DMA_M(
    input ACLK,
    input ARESETn,

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
	output logic RREADY_M,

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
	output logic BREADY_M,


    input 									R_req,
	input 			[`AXI_ADDR_BITS-1:0]	DMA_R_ADDR,
	output logic	[`AXI_DATA_BITS-1:0]	DMA_R_DATA,
	output logic 							R_valid,

	input									W_req,
	input 			[`AXI_ADDR_BITS-1:0]	DMA_W_ADDR,
	input 			[`AXI_DATA_BITS-1:0]	DMA_W_DATA,
	output logic 							W_done
);


//--------------------------------------------------------------------------
//== Local Parameters and Master IDs
//--------------------------------------------------------------------------
localparam M0_ID = 4'b0000;
localparam M1_ID = 4'b0001;

// FSM states
localparam IDLE 	= 3'b000;
localparam R_ADDR 	= 3'b001;
localparam R_DATA 	= 3'b010;
localparam W_ADDR 	= 3'b011;
localparam W_DATA 	= 3'b100;
localparam W_RESP 	= 3'b101;


//**************************************************************************
//** LOGIC FOR MASTER 1 (Read/Write)
//**************************************************************************


reg [2:0] wr_cs, wr_ns;

reg [`AXI_ADDR_BITS-1:0] latched_m1_raddr;
reg [`AXI_ADDR_BITS-1:0] latched_m1_waddr;
reg [`AXI_DATA_BITS-1:0] latched_m1_wdata;
reg latched_r_req;
reg latched_w_req;

assign DMA_R_DATA 		= RDATA_M;
assign R_valid 			= (wr_cs == R_DATA) && RVALID_M;
assign W_done 			= (wr_cs == W_RESP) && BVALID_M;

always @ (posedge ACLK or negedge ARESETn)begin
    if(!ARESETn)begin
        latched_m1_raddr        <= {`AXI_ADDR_BITS{1'b0}};
        latched_r_req        	<= 1'b0;
        latched_w_req        	<= 1'b0;
        latched_m1_waddr        <= {`AXI_ADDR_BITS{1'b0}};
        latched_m1_wdata        <= {`AXI_DATA_BITS{1'b0}};
    end
    else begin
        latched_m1_raddr        <= latched_m1_raddr;
        latched_r_req        	<= latched_r_req;
        latched_w_req        	<= latched_w_req;
        latched_m1_waddr        <= latched_m1_waddr;
        latched_m1_wdata        <= latched_m1_wdata;

        if(R_req)begin
            latched_m1_raddr 	<= DMA_R_ADDR;
            latched_r_req 		<= 1'b1;
        end
        else if(wr_cs == R_DATA)begin
            latched_m1_raddr 	<= {`AXI_ADDR_BITS{1'b0}};
            latched_r_req 		<= 1'b0;
        end
        
        if(W_req && (wr_cs == IDLE || wr_cs == W_RESP))begin
            latched_m1_waddr 	<= DMA_W_ADDR;
            latched_m1_wdata 	<= DMA_W_DATA;
            latched_w_req 		<= 1'b1;
        end
        else if(wr_cs == W_RESP)begin
            latched_m1_waddr 	<= {`AXI_ADDR_BITS{1'b0}};
            latched_m1_wdata 	<= {`AXI_DATA_BITS{1'b0}};
            latched_w_req 		<= 1'b0;
        end
    end
end


// M Read FSM
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn)begin
        wr_cs <= IDLE;
    end
    else begin
        wr_cs <= wr_ns;
    end
end

always @(*) begin
    ARVALID_M 	= 1'b0;
	ARADDR_M  	= {`AXI_ADDR_BITS{1'b0}};
	RREADY_M  	= 1'b0;
	
	AWVALID_M 	= 1'b0;
	AWADDR_M 	= {`AXI_ADDR_BITS{1'b0}};
	WVALID_M 	= 1'b0;
	WDATA_M 	= {`AXI_DATA_BITS{1'b0}};
	BREADY_M 	= 1'b0;

    case(wr_cs)
        IDLE: begin
			ARVALID_M 	= 1'b0;
            AWVALID_M  	= 1'b0;
			wr_ns  		= (latched_r_req || R_req)? R_ADDR : (latched_w_req || W_req)? W_ADDR : IDLE;
        end
		R_ADDR: begin
			ARVALID_M 	= 1'b1;
			ARADDR_M 	= latched_m1_raddr;
            
			wr_ns 		= (ARREADY_M)? R_DATA : R_ADDR;
        end
        R_DATA: begin
            ARVALID_M  	= 1'b0;
			RREADY_M 	= 1'b1;
			wr_ns 		= (RVALID_M)? IDLE : R_DATA;
        end
		W_ADDR: begin
			AWVALID_M 	= 1'b1;
			AWADDR_M 	= latched_m1_waddr;
			
			wr_ns 		= (AWREADY_M)? W_DATA : W_ADDR;
		end
		W_DATA: begin
			WVALID_M 	= 1'b1;
			WDATA_M 	= latched_m1_wdata;
			
			wr_ns 		= (WREADY_M)? W_RESP : W_DATA;
		end
		W_RESP: begin
			BREADY_M 	= 1'b1;
			wr_ns 		= (BVALID_M)? IDLE : W_RESP;
		end
        default: wr_ns 	= IDLE;
    endcase
end

// M static AXI signals
assign ARID_M 		= {`AXI_ID_BITS{1'b0}};
assign ARLEN_M 		= {`AXI_LEN_BITS{1'b0}}; // 1 beat
assign ARSIZE_M 	= 3'b010; // 4 bytes
assign ARBURST_M 	= 2'b01; // Burst Type: INCR


assign AWID_M 		= {`AXI_ID_BITS{1'b0}};
assign AWLEN_M 		= {`AXI_LEN_BITS{1'b0}};
assign AWSIZE_M 	= 3'b010;
assign AWBURST_M 	= 2'b01;

assign WLAST_M 	= 1'b1; // Master only issues 1 beat 
assign WSTRB_M 	= 4'b0000; // decided in CPU






endmodule