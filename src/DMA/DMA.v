// `include "../../include/AXI_define.svh"

module DMA(
    input 				clk,
    input 				rst,
    // input 				DMAEN,
    // input 		[31:0] 	DESC_BASE,
    output reg          DMA_interrupt,

	/* Master Interface*/
	output reg 			R_req,
    output reg 	[31:0] 	AR_ADDR,
    input 		[31:0] 	R_DATA,
	input 				R_valid,

	output reg 			W_req,
    output reg 	[31:0] 	AW_ADDR,
    output reg  [31:0]  W_DATA,
	input 				W_done,


	/* Memory Interface*/
	input 				CEB,
	input 				WEB,
	input 		[6:0] 	A,
	input 		[31:0] 	DI,
	output reg 	[31:0] 	DO

);

// 7 bits
reg [31:0] 	DMA_MEM [0:128]; // 0x1002_0000 - 0x1002_0200(1-bit for 1-byte)

// DMA_MEM[64] == DMAEN
// DMA_MEM[128] == DESC_BASE

wire 			DMAEN;
wire [31:0] 	DESC_BASE;

assign DMAEN 		= DMA_MEM[64];
assign DESC_BASE 	= DMA_MEM[128];

always @(posedge clk)begin
	if(~CEB)begin
		if(~WEB)begin
			DMA_MEM[A] 	<= DI;
		end
		else begin
			DO 			<= DMA_MEM[A];
		end
	end
end

reg [31:0] DESC_BASE_reg;
reg [31:0] data_reg;

reg [3:0] cs, ns;
localparam IDLE 			= 4'b0000;
localparam DESC_READ 		= 4'b0001;
localparam DATA_READ 		= 4'b0010;
localparam DATA_WRITE 		= 4'b0011;
localparam LAST_CHECK 		= 4'b0100;
localparam DONE 			= 4'b0101;

reg [3:0] desc_cs, desc_ns;

localparam desc_SRC 		= 4'b0110;
localparam desc_DST 		= 4'b0111;
localparam desc_LEN 		= 4'b1000;
localparam desc_NEXT_DESC 	= 4'b1001;
localparam desc_EOC 		= 4'b1010;
localparam desc_DONE 		= 4'b1011;

reg [31:0] DMASRC;
reg [31:0] DMADST;
reg [31:0] DMALEN;
reg [31:0] NEXT_DESC;
reg EOC;

reg [31:0] LEN_ctr;

always @(posedge clk or posedge rst)begin
    if(rst)begin
        DMA_interrupt 	<= 1'b0;
    end
    else begin
        DMA_interrupt 	<= (cs == DONE)? 1'b1 : DMA_interrupt;
    end
end

always @(posedge clk or posedge rst)begin
    if(rst)begin
        cs 			<= IDLE;
        ns 			<= IDLE;

        desc_cs 	<= IDLE;
		desc_ns 	<= IDLE;
    end
    else begin
        cs 			<= ns;
		desc_cs 	<= desc_ns;
    end
end

always @(posedge clk or posedge rst)begin
	if(rst)begin
		DESC_BASE_reg	<= 32'd0;
		R_req			<= 1'b0;
		AR_ADDR 		<= 32'd0;
		W_req 			<= 1'b0;
		AW_ADDR 		<= 32'd0;
		W_DATA 			<= 32'd0;

		LEN_ctr 		<= 32'd0;
	end
	else begin
		case(cs)
			IDLE: begin
				DESC_BASE_reg 	<= (DMAEN && DESC_BASE)? DESC_BASE : DESC_BASE_reg;
			end
			DESC_READ: begin
				LEN_ctr 		<= 32'd0;
			end
			DATA_READ: begin
				R_req 			<= 1'b1;
				W_req 			<= 1'b0;
				
				AR_ADDR			<= DMASRC + LEN_ctr;

				data_reg 		<= (R_valid)? R_DATA : data_reg; 
			end
			DATA_WRITE: begin
				R_req 			<= 1'b0;
				W_req 			<= 1'b1;

				AW_ADDR 		<= DMADST + LEN_ctr;
				W_DATA 			<= data_reg;

				// DMALEN 			<= !DMALEN? DMALEN : (W_done)? DMALEN - 32'd4 : DMALEN;
				LEN_ctr			<= (W_done)? LEN_ctr + 32'd4 : LEN_ctr;
			end
			LAST_CHECK: begin
				R_req 			<= 1'b0;
				W_req 			<= 1'b0;
			end
			DONE: begin
				R_req 			<= 1'b0;
				W_req 			<= 1'b0;
			end

		endcase

	end
end

always @(*)begin

    case(cs)
        IDLE: begin
            ns  	= (DMAEN && DESC_BASE)? DESC_READ : IDLE;
        end
        DESC_READ: begin
            ns  	= (desc_cs == desc_DONE)? DATA_READ : DATA_WRITE;
        end
        DATA_READ: begin
			ns 		= (R_valid)? DATA_WRITE : DATA_WRITE;
        end
        DATA_WRITE: begin
			ns 		= (W_done)? (LEN_ctr == DMALEN - 32'd4)? LAST_CHECK : DATA_READ : DATA_WRITE;
        end
        LAST_CHECK: begin
			ns 		= (EOC)? DONE : DESC_READ; 
        end
		DONE: begin
			ns 		= IDLE;
		end
		default: ns = IDLE;
    endcase

end





/* Description List FSM */


always @(posedge clk or posedge rst)begin
	if(rst)begin
		DMASRC 		<= 32'd0;
		DMADST 		<= 32'd0;
		DMALEN 		<= 32'd0;
		NEXT_DESC 	<= 32'd0;
		EOC 		<= 1'd0;
	end
	else begin
		case(desc_cs)
			IDLE: begin
				R_req 			<= 1'b0;
				AR_ADDR 		<= 32'd0;
				DMASRC 			<= 32'd0;
				DMADST 			<= 32'd0;
				DMALEN 			<= 32'd0;
				NEXT_DESC 		<= 32'd0;
				EOC 			<= 1'd0;
				// DESC_BASE_reg 	<= DESC_BASE_reg;
			end
			desc_SRC: begin
				R_req 			<= 1'b1;
				AR_ADDR 		<= DESC_BASE_reg;
				DMASRC 			<= (R_valid)? R_DATA : DMASRC;
			end
			desc_DST: begin
				R_req 			<= 1'b1;
				AR_ADDR 		<= DESC_BASE_reg + 32'd4;
				DMADST 			<= (R_valid)? R_DATA : DMADST;
			end
			desc_LEN: begin
				R_req 			<= 1'b1;
				AR_ADDR 		<= DESC_BASE_reg + 32'd8;
				DMALEN 			<= (R_valid)? R_DATA : DMALEN;
			end
			desc_NEXT_DESC: begin
				R_req 			<= 1'b1;
				AR_ADDR 		<= DESC_BASE_reg + 32'd12;
				NEXT_DESC 		<= (R_valid)? R_DATA : NEXT_DESC;
			end
			desc_EOC: begin
				R_req 			<= 1'b1;
				AR_ADDR 		<= DESC_BASE_reg + 32'd16;
				EOC 			<= (R_valid)? R_DATA : EOC;
			end
			desc_DONE: begin
				R_req			<= 1'b0;
				DESC_BASE_reg 	<= NEXT_DESC;
			end

		endcase

	end
end

always @(*)begin

	case(desc_cs)
		IDLE: begin
			desc_ns 	= (cs == DESC_READ)? desc_SRC : IDLE;
		end
		desc_SRC: begin
			desc_ns 	= (R_valid)? desc_DST : desc_SRC;
		end
		desc_DST: begin
			desc_ns 	= (R_valid)? desc_LEN : desc_DST;
		end
		desc_LEN: begin
			desc_ns 	= (R_valid)? desc_NEXT_DESC : desc_LEN;
		end
		desc_NEXT_DESC: begin
			desc_ns 	= (R_valid)? desc_EOC : desc_NEXT_DESC;
		end
		desc_EOC: begin
			desc_ns 	= (R_valid)? desc_DONE : desc_EOC;
		end
		desc_DONE: begin
			desc_ns 	= IDLE;
		end

	endcase

end



endmodule