<<<<<<< HEAD
`include "./include/AXI_define.svh"
`include "./sim/ROM/ROM.v"

module ROM_wrapper(
    input ACLK,
    input ARESETn,

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
	input RREADY_S


);

// SRAM control signals
wire CEB;
logic [11:0] addr;
wire [`AXI_DATA_BITS-1:0]  DO;


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
            ARREADY_S = 1'b1;
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
assign RDATA_S = DO;
assign RRESP_S = 2'b00; // OKAY
assign RLAST_S = (r_len_ctr == {`AXI_LEN_BITS{1'b0}});



wire [`AXI_ADDR_BITS-1:0] r_addr_ctr_next = r_addr_ctr + (1 << latched_arsize);

always @(*) begin
    
    addr = 12'd0; 

	// address always process read request first.

    // address of reading

    if(r_cs == FSM_IDLE && ARVALID_S && ARREADY_S)begin
        addr = ARADDR_S[13:2];
    end
    else if(r_cs == FSM_DATA && RREADY_S)begin
        addr = r_addr_ctr_next[13:2];
    end
    else if(r_cs == FSM_DATA)begin
        addr = r_addr_ctr[13:2];
    end
    else if(w_cs == FSM_DATA)begin
        addr = w_addr_ctr[13:2];
    end

end

assign CEB = (r_cs == FSM_DATA) || (r_cs == FSM_IDLE && ARVALID_S);

ROM ROM(
    .CK(ACLK),
    .CS(CEB),
    .OE(1'b1),
    .A(addr),
    .DO(DO)
);


=======
`include "./include/AXI_define.svh"
`include "./sim/ROM/ROM.v"

module ROM_wrapper(
    input ACLK,
    input ARESETn,

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
	input RREADY_S


);

// SRAM control signals
wire CEB;
logic [11:0] addr;
wire [`AXI_DATA_BITS-1:0]  DO;


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
            ARREADY_S = 1'b1;
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
assign RDATA_S = DO;
assign RRESP_S = 2'b00; // OKAY
assign RLAST_S = (r_len_ctr == {`AXI_LEN_BITS{1'b0}});



wire [`AXI_ADDR_BITS-1:0] r_addr_ctr_next = r_addr_ctr + (1 << latched_arsize);

always @(*) begin
    
    addr = 12'd0; 

	// address always process read request first.

    // address of reading

    if(r_cs == FSM_IDLE && ARVALID_S && ARREADY_S)begin
        addr = ARADDR_S[13:2];
    end
    else if(r_cs == FSM_DATA && RREADY_S)begin
        addr = r_addr_ctr_next[13:2];
    end
    else if(r_cs == FSM_DATA)begin
        addr = r_addr_ctr[13:2];
    end
    else if(w_cs == FSM_DATA)begin
        addr = w_addr_ctr[13:2];
    end

end

assign CEB = (r_cs == FSM_DATA) || (r_cs == FSM_IDLE && ARVALID_S);

ROM ROM(
    .CK(ACLK),
    .CS(CEB),
    .OE(1'b1),
    .A(addr),
    .DO(DO)
);


>>>>>>> 1db5785 (Initial commit)
endmodule