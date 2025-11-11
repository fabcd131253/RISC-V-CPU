`include "./include/AXI_define.svh"


module DMA_S(
    input ACLK,
    input ARESETn,

	/* Slave Interface*/
	input 		 							ARVALID_S,
    input 		 	[`AXI_ADDR_BITS-1:0] 	ARADDR_S,
	input 		 	[`AXI_ID_BITS-1:0]		ARID_S,
	input 			[`AXI_LEN_BITS-1:0]		ARLEN_S,
	input 		 	[`AXI_SIZE_BITS-1:0] 	ARSIZE_S,
	input 		 	[1:0]					ARBURST_S,
	output logic ARREADY_S,

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


    ,
	output CEB,
	output WEB,
	output [13:0] A,
	output [31:0] DI,
	input [31:0] DO

);

//==========================================================================
//== SRAM Interface and Internal Logic Signals
//==========================================================================
localparam SRAM_ADDR_WIDTH = 14;

// SRAM control signals
wire sram_ceb;
wire sram_web;
logic [13:0] sram_a;
wire [`AXI_DATA_BITS-1:0]  sram_d_in;
wire [`AXI_DATA_BITS-1:0]  sram_q_out;
wire [31:0]  sram_bweb;

// FSM states
localparam FSM_IDLE = 2'b00;
localparam FSM_DATA = 2'b01;
localparam FSM_RESP = 2'b10;

//==========================================================================
//== Read Channel Logic
//==========================================================================
reg [1:0] r_cs, r_ns;
reg [`AXI_LEN_BITS-1:0] 	r_len_ctr;

reg [`AXI_ADDR_BITS-1:0] 	r_addr_ctr;
reg [`AXI_SIZE_BITS-1:0] 	latched_arsize;
reg [`AXI_IDS_BITS-1:0] 	latched_arid;

reg [1:0] w_cs, w_ns;
reg [`AXI_ADDR_BITS-1:0]	w_addr_ctr;
reg [`AXI_LEN_BITS-1:0] 	w_len_ctr;
reg [`AXI_SIZE_BITS-1:0] 	latched_awsize;
reg [`AXI_IDS_BITS-1:0] 	latched_awid;

// logic rvalid_pipeline; // To handle 1-cycle read latency

// Read Data Channel Logic (handles 1-cycle latency)
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        RVALID_S <= 1'b0;
    end else begin
        // A read is initiated by accepting an address
        if (ARVALID_S && ARREADY_S) begin
            RVALID_S <= 1'b1;
        end
        // De-assert valid when the last beat is taken
        else if (RVALID_S && RREADY_S && r_len_ctr == {`AXI_LEN_BITS{1'b0}}) begin
            RVALID_S <= 1'b0;
        end
    end
end

// assign RVALID_S = rvalid_pipeline;

// State register for read FSM
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        r_cs <= FSM_IDLE;
    end
    else begin
        r_cs <= r_ns;
    end
end

// Combinational logic for read FSM
always @ (*) begin
    r_ns = r_cs;
    ARREADY_S = 1'b0;

    case (r_cs)
        FSM_IDLE: begin
            ARREADY_S = (w_cs == FSM_IDLE && !AWVALID_S)? 1'b1 : 1'b0;
            r_ns = (ARVALID_S && ARREADY_S)? FSM_DATA : FSM_IDLE;
        end
        FSM_DATA: begin
            ARREADY_S = 1'b0;
            // Stay in this state until the last beat is accepted by the master
            r_ns = (RVALID_S && RREADY_S && r_len_ctr == {`AXI_LEN_BITS{1'b0}})? FSM_IDLE : FSM_DATA;
            
        end
        default: begin
            r_ns = FSM_IDLE;
        end
    endcase
end

// Burst counters and latched signals for read
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        r_len_ctr 		<= {`AXI_LEN_BITS{1'b0}};
		r_addr_ctr 		<= {`AXI_ADDR_BITS{1'b0}};
		latched_arsize 	<= {`AXI_SIZE_BITS{1'b0}};
		latched_arid 	<= {`AXI_IDS_BITS{1'b0}};
    end else begin
        if (ARVALID_S && ARREADY_S) begin
            r_len_ctr 		<= ARLEN_S;
			r_addr_ctr 		<= ARADDR_S;
			latched_arsize 	<= ARSIZE_S;
            latched_arid 	<= ARID_S;
        end
        // Increment address and decrement length when master accepts a beat
		else if (RVALID_S && RREADY_S && r_cs == FSM_DATA && r_len_ctr != {`AXI_LEN_BITS{1'b0}}) begin
            r_addr_ctr 		<= r_addr_ctr + (1 << latched_arsize);
			r_len_ctr 		<= r_len_ctr - 1;
        end
    end
end



assign RID_S   = latched_arid;
assign RDATA_S = sram_q_out;
assign RRESP_S = 2'b00; // OKAY
assign RLAST_S = (r_len_ctr == {`AXI_LEN_BITS{1'b0}});

//==========================================================================
//== Write Channel Logic
//==========================================================================


// State register for write FSM
always @ (posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        w_cs <= FSM_IDLE;
    end else begin
        w_cs <= w_ns;
    end
end

// Combinational logic for write FSM
always @ (*) begin
    // w_ns = w_cs;
    AWREADY_S = 1'b0;
    WREADY_S = 1'b0;
    
    case (w_cs)
        FSM_IDLE: begin
            AWREADY_S = (r_cs == FSM_IDLE && !ARVALID_S)? 1'b1 : 1'b0;
            // AWREADY_S = 1'b1;
            w_ns = (AWVALID_S && AWREADY_S)? FSM_DATA : FSM_IDLE;
        end
        FSM_DATA: begin
            WREADY_S = 1'b1;
            // WREADY_S = (r_cs == FSM_IDLE && !ARVALID_S)? 1'b1 : 1'b0; // reading request always has a higher priority
            w_ns = (WVALID_S && WLAST_S)? FSM_RESP : FSM_DATA;
        end
        FSM_RESP: begin
            w_ns = (BREADY_S)? FSM_IDLE : FSM_RESP;
        end
        default: w_ns = FSM_IDLE;
    endcase
end

// Burst counters and latched signals for write
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        w_addr_ctr 		<= {`AXI_ADDR_BITS{1'b0}};
        w_len_ctr 		<= {`AXI_LEN_BITS{1'b0}};
		latched_awsize 	<= {`AXI_SIZE_BITS{1'b0}};
        latched_awid    <= {`AXI_IDS_BITS{1'b0}};
    end else begin
        // Latch address, len, and ID at the start of the burst
        if (AWVALID_S && AWREADY_S) begin
            w_addr_ctr 		<= AWADDR_S;
            w_len_ctr 		<= AWLEN_S;
            latched_awsize 	<= AWSIZE_S;
			latched_awid    <= AWID_S;
        end
        // Increment address and decrement length for each data beat
        else if (WVALID_S && WREADY_S && w_cs == FSM_DATA && !WLAST_S) begin
            w_addr_ctr <= w_addr_ctr + (1 << latched_awsize); // Increment by 4 bytes
            w_len_ctr  <= w_len_ctr - {`AXI_LEN_BITS{1'b1}};
        end
    end
end

// Write Response Channel Logic
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        BVALID_S <= 1'b0;
        BID_S    <= {`AXI_IDS_BITS{1'b0}};
        BRESP_S  <= 2'b00;
    end
    else begin
        if (w_cs == FSM_DATA && WVALID_S && WLAST_S && WREADY_S) begin
            BVALID_S <= 1'b1;
            BID_S    <= latched_awid;
            BRESP_S  <= 2'b00; // OKAY
        end
		else if (BREADY_S) begin
            BVALID_S <= 1'b0;
        end
    end
end

//==========================================================================
//== SRAM Control and Instantiation
//==========================================================================

// AXI address -> SRAM address (word-aligned)

wire [`AXI_ADDR_BITS-1:0] r_addr_ctr_next = r_addr_ctr + (1 << latched_arsize);

always @(*) begin
    
    sram_a = 7'd0;

	// address always process read request first.

    // address of reading

    if(r_cs == FSM_IDLE && ARVALID_S && ARREADY_S)begin
        sram_a = ARADDR_S[8:2];
    end
    else if(r_cs == FSM_DATA && RREADY_S)begin
        sram_a = r_addr_ctr_next[8:2];
    end
    else if(r_cs == FSM_DATA)begin
        sram_a = r_addr_ctr[8:2];
    end
    else if(w_cs == FSM_DATA)begin
        sram_a = w_addr_ctr[8:2];
    end

end

assign sram_d_in = WDATA_S;
// assign sram_bweb = { {8{WSTRB_S[3]}}, {8{WSTRB_S[2]}}, {8{WSTRB_S[1]}}, {8{WSTRB_S[0]}} };

// SRAM is active (CEB=0) during the data phase of read or write bursts
assign sram_ceb = !((w_cs == FSM_DATA && WVALID_S) || (r_cs == FSM_DATA) || (r_cs == FSM_IDLE && ARVALID_S));
// SRAM writes (WEB=0) only during a valid write beat
assign sram_web = !(w_cs == FSM_DATA && WVALID_S && WREADY_S);


assign CEB 		= sram_ceb;
assign WEB 		= sram_web;
// assign BWEB 	= sram_bweb;
assign A 		= sram_a;
assign DI 		= sram_d_in;
assign sram_q_out = DO;


endmodule