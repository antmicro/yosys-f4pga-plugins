module TDP_BRAM36 (
	WEN_A1,
	WEN_B1,
	REN_A1,
	REN_B1,
	CLK_A1,
	CLK_B1,
	BE_A1,
	BE_B1,
	ADDR_A1,
	ADDR_B1,
	WDATA_A1,
	WDATA_B1,
	RDATA_A1,
	RDATA_B1,
	FLUSH1,
	SYNC_FIFO1,
	RMODE_A1,
	RMODE_B1,
	WMODE_A1,
	WMODE_B1,
	FMODE1,
	POWERDN1,
	SLEEP1,
	PROTECT1,
	UPAE1,
	UPAF1,
	WEN_A2,
	WEN_B2,
	REN_A2,
	REN_B2,
	CLK_A2,
	CLK_B2,
	BE_A2,
	BE_B2,
	ADDR_A2,
	ADDR_B2,
	WDATA_A2,
	WDATA_B2,
	RDATA_A2,
	RDATA_B2,
	FLUSH2,
	SYNC_FIFO2,
	RMODE_A2,
	RMODE_B2,
	WMODE_A2,
	WMODE_B2,
	FMODE2,
	POWERDN2,
	SLEEP2,
	PROTECT2,
	UPAE2,
	UPAF2,
	SPLIT,
	RAM_ID_i,
	PL_INIT_i,
	PL_ENA_i,
	PL_REN_i,
	PL_CLK_i,
	PL_WEN_i,
	PL_ADDR_i,
	PL_DATA_i,
	PL_INIT_o,
	PL_ENA_o,
	PL_REN_o,
	PL_CLK_o,
	PL_WEN_o,
	PL_ADDR_o,
	PL_DATA_o
);
	input wire WEN_A1;
	input wire WEN_B1;
	input wire REN_A1;
	input wire REN_B1;
	input wire CLK_A1;
	input wire CLK_B1;
	input wire [1:0] BE_A1;
	input wire [1:0] BE_B1;
	input wire [14:0] ADDR_A1;
	input wire [14:0] ADDR_B1;
	input wire [17:0] WDATA_A1;
	input wire [17:0] WDATA_B1;
	output reg [17:0] RDATA_A1;
	output reg [17:0] RDATA_B1;
	input wire FLUSH1;
	input wire SYNC_FIFO1;
	input wire [2:0] RMODE_A1;
	input wire [2:0] RMODE_B1;
	input wire [2:0] WMODE_A1;
	input wire [2:0] WMODE_B1;
	input wire FMODE1;
	input wire POWERDN1;
	input wire SLEEP1;
	input wire PROTECT1;
	input wire [10:0] UPAE1;
	input wire [10:0] UPAF1;
	input wire WEN_A2;
	input wire WEN_B2;
	input wire REN_A2;
	input wire REN_B2;
	input wire CLK_A2;
	input wire CLK_B2;
	input wire [1:0] BE_A2;
	input wire [1:0] BE_B2;
	input wire [13:0] ADDR_A2;
	input wire [13:0] ADDR_B2;
	input wire [17:0] WDATA_A2;
	input wire [17:0] WDATA_B2;
	output reg [17:0] RDATA_A2;
	output reg [17:0] RDATA_B2;
	input wire FLUSH2;
	input wire SYNC_FIFO2;
	input wire [2:0] RMODE_A2;
	input wire [2:0] RMODE_B2;
	input wire [2:0] WMODE_A2;
	input wire [2:0] WMODE_B2;
	input wire FMODE2;
	input wire POWERDN2;
	input wire SLEEP2;
	input wire PROTECT2;
	input wire [10:0] UPAE2;
	input wire [10:0] UPAF2;
	input SPLIT;
	input [8:0] RAM_ID_i;
	input wire PL_INIT_i;
	input wire PL_ENA_i;
	input wire PL_REN_i;
	input wire PL_CLK_i;
	input wire [1:0] PL_WEN_i;
	input wire [23:0] PL_ADDR_i;
	input wire [35:0] PL_DATA_i;
	output reg PL_INIT_o;
	output reg PL_ENA_o;
	output reg PL_REN_o;
	output reg PL_CLK_o;
	output reg [1:0] PL_WEN_o;
	output reg [23:0] PL_ADDR_o;
	output wire [35:0] PL_DATA_o;
	wire EMPTY2;
	wire EPO2;
	wire EWM2;
	wire FULL2;
	wire FMO2;
	wire FWM2;
	wire EMPTY1;
	wire EPO1;
	wire EWM1;
	wire FULL1;
	wire FMO1;
	wire FWM1;
	wire UNDERRUN1;
	wire OVERRUN1;
	wire UNDERRUN2;
	wire OVERRUN2;
	wire UNDERRUN3;
	wire OVERRUN3;
	wire EMPTY3;
	wire EPO3;
	wire EWM3;
	wire FULL3;
	wire FMO3;
	wire FWM3;
	wire ram_fmode1;
	wire ram_fmode2;
	wire [17:0] ram_rdata_a1;
	wire [17:0] ram_rdata_b1;
	wire [17:0] ram_rdata_a2;
	wire [17:0] ram_rdata_b2;
	reg [17:0] ram_wdata_a1;
	reg [17:0] ram_wdata_b1;
	reg [17:0] ram_wdata_a2;
	reg [17:0] ram_wdata_b2;
	reg [14:0] laddr_a1;
	reg [14:0] laddr_b1;
	wire [13:0] ram_addr_a1;
	wire [13:0] ram_addr_b1;
	wire [13:0] ram_addr_a2;
	wire [13:0] ram_addr_b2;
	wire smux_clk_a1;
	wire smux_clk_b1;
	wire smux_clk_a2;
	wire smux_clk_b2;
	reg [1:0] ram_be_a1;
	reg [1:0] ram_be_a2;
	reg [1:0] ram_be_b1;
	reg [1:0] ram_be_b2;
	reg [2:0] ram_rmode_a1;
	reg [2:0] ram_wmode_a1;
	reg [2:0] ram_rmode_b1;
	reg [2:0] ram_wmode_b1;
	reg [2:0] ram_rmode_a2;
	reg [2:0] ram_wmode_a2;
	reg [2:0] ram_rmode_b2;
	reg [2:0] ram_wmode_b2;
	wire ram_ren_a1;
	wire ram_ren_b1;
	wire ram_ren_a2;
	wire ram_ren_b2;
	wire ram_wen_a1;
	wire ram_wen_b1;
	wire ram_wen_a2;
	wire ram_wen_b2;
	wire ren_o;
	wire [11:0] ff_raddr;
	wire [11:0] ff_waddr;
	reg [35:0] fifo_rdata;
	reg [1:0] fifo_rmode;
	reg [1:0] fifo_wmode;
	wire [1:0] bwl;
	assign ram_fmode1 = FMODE1 & SPLIT;
	assign ram_fmode2 = FMODE2 & SPLIT;
	assign smux_clk_a1 = CLK_A1;
	assign smux_clk_b1 = (FMODE1 ? (SYNC_FIFO1 ? CLK_A1 : CLK_B1) : CLK_B1);
	assign smux_clk_a2 = (SPLIT ? CLK_A2 : CLK_A1);
	assign smux_clk_b2 = (SPLIT ? CLK_B2 : (FMODE1 ? (SYNC_FIFO1 ? CLK_A1 : CLK_B1) : CLK_B1));
	assign ram_ren_a1 = (SPLIT ? REN_A1 : (FMODE1 ? 0 : REN_A1));
	assign ram_ren_a2 = (SPLIT ? REN_A2 : (FMODE1 ? 0 : REN_A1));
	assign ram_ren_b1 = (SPLIT ? REN_B1 : (FMODE1 ? ren_o : REN_B1));
	assign ram_ren_b2 = (SPLIT ? REN_B2 : (FMODE1 ? ren_o : REN_B1));
	assign ram_wen_a1 = (SPLIT ? WEN_A1 : (FMODE1 ? ~FULL3 & WEN_A1 : WEN_A1 & ~ADDR_A1[4]));
	assign ram_wen_a2 = (SPLIT ? WEN_A2 : (FMODE1 ? ~FULL3 & WEN_A1 : WEN_A1 & ADDR_A1[4]));
	localparam MODE_36 = 3'b111;
	assign ram_wen_b1 = (SPLIT ? WEN_B1 : (WMODE_B1 == MODE_36 ? WEN_B1 : WEN_B1 & ~ADDR_B1[4]));
	assign ram_wen_b2 = (SPLIT ? WEN_B2 : (WMODE_B1 == MODE_36 ? WEN_B1 : WEN_B1 & ADDR_B1[4]));
	assign ram_addr_a1 = (SPLIT ? ADDR_A1[13:0] : (FMODE1 ? {ff_waddr[11:2], ff_waddr[0], 3'b000} : {ADDR_A1[14:5], ADDR_A1[3:0]}));
	assign ram_addr_b1 = (SPLIT ? ADDR_B1[13:0] : (FMODE1 ? {ff_raddr[11:2], ff_raddr[0], 3'b000} : {ADDR_B1[14:5], ADDR_B1[3:0]}));
	assign ram_addr_a2 = (SPLIT ? ADDR_A2[13:0] : (FMODE1 ? {ff_waddr[11:2], ff_waddr[0], 3'b000} : {ADDR_A1[14:5], ADDR_A1[3:0]}));
	assign ram_addr_b2 = (SPLIT ? ADDR_B2[13:0] : (FMODE1 ? {ff_raddr[11:2], ff_raddr[0], 3'b000} : {ADDR_B1[14:5], ADDR_B1[3:0]}));
	assign bwl = (SPLIT ? ADDR_A1[4:3] : (FMODE1 ? ff_waddr[1:0] : ADDR_A1[4:3]));
	localparam MODE_18 = 3'b110;
	localparam MODE_9 = 3'b101;
	always @(*) begin : WDATA_SEL
		case (SPLIT)
			1: begin
				ram_wdata_a1 = WDATA_A1;
				ram_wdata_a2 = WDATA_A2;
				ram_wdata_b1 = WDATA_B1;
				ram_wdata_b2 = WDATA_B2;
				ram_be_a2 = BE_A2;
				ram_be_b2 = BE_B2;
				ram_be_a1 = BE_A1;
				ram_be_b1 = BE_B1;
			end
			0: begin
				case (WMODE_A1)
					MODE_36: begin
						ram_wdata_a1 = {WDATA_A2[15:14], WDATA_A1[15:0]};
						ram_wdata_a2 = {WDATA_A2[17:16], WDATA_A2[13:0], WDATA_A1[17:16]};
						ram_be_a2 = (FMODE1 ? 2'b11 : BE_A2);
						ram_be_a1 = (FMODE1 ? 2'b11 : BE_A1);
					end
					MODE_18: begin
						ram_wdata_a1 = WDATA_A1;
						ram_wdata_a2 = WDATA_A1;
						ram_be_a1 = (FMODE1 ? (ff_waddr[1] ? 2'b00 : 2'b11) : BE_A1);
						ram_be_a2 = (FMODE1 ? (ff_waddr[1] ? 2'b11 : 2'b00) : BE_A1);
					end
					MODE_9:
						case (bwl)
							0: begin
								{ram_wdata_a1[16], ram_wdata_a1[7:0]} = WDATA_A1[8:0];
								{ram_wdata_a1[17], ram_wdata_a1[15:8]} = 9'b000000000;
								{ram_wdata_a2[16], ram_wdata_a2[7:0]} = 9'b000000000;
								{ram_wdata_a2[17], ram_wdata_a2[15:8]} = 9'b000000000;
								ram_be_a1[0] = (FMODE1 ? (ff_waddr[1:0] == 0 ? 1'b1 : 1'b0) : 1'b1);
								ram_be_a1[1] = (FMODE1 ? (ff_waddr[1:0] == 1 ? 1'b1 : 1'b0) : 1'b0);
								ram_be_a2[0] = (FMODE1 ? (ff_waddr[1:0] == 2 ? 1'b1 : 1'b0) : 1'b0);
								ram_be_a2[1] = (FMODE1 ? (ff_waddr[1:0] == 3 ? 1'b1 : 1'b0) : 1'b0);
							end
							1: begin
								{ram_wdata_a1[16], ram_wdata_a1[7:0]} = 9'b000000000;
								{ram_wdata_a1[17], ram_wdata_a1[15:8]} = {WDATA_A1[8:0]};
								{ram_wdata_a2[16], ram_wdata_a2[7:0]} = 9'b000000000;
								{ram_wdata_a2[17], ram_wdata_a2[15:8]} = 9'b000000000;
								{ram_be_a2, ram_be_a1} = 4'b0010;
							end
							2: begin
								{ram_wdata_a1[16], ram_wdata_a1[7:0]} = 9'b000000000;
								{ram_wdata_a1[17], ram_wdata_a1[15:8]} = 9'b000000000;
								{ram_wdata_a2[16], ram_wdata_a2[7:0]} = {WDATA_A1[8:0]};
								{ram_wdata_a2[17], ram_wdata_a2[15:8]} = 9'b000000000;
								{ram_be_a2, ram_be_a1} = 4'b0100;
							end
							3: begin
								{ram_wdata_a1[16], ram_wdata_a1[7:0]} = 9'b000000000;
								{ram_wdata_a1[17], ram_wdata_a1[15:8]} = 9'b000000000;
								{ram_wdata_a2[16], ram_wdata_a2[7:0]} = 9'b000000000;
								{ram_wdata_a2[17], ram_wdata_a2[15:8]} = {WDATA_A1[8:0]};
								{ram_be_a2, ram_be_a1} = 4'b1000;
							end
						endcase
				endcase
				case (WMODE_B1)
					MODE_36: begin
						ram_wdata_b1 = (FMODE1 ? 18'b000000000000000000 : {WDATA_B2[15:14], WDATA_B1[15:0]});
						ram_wdata_b2 = (FMODE1 ? 18'b000000000000000000 : {WDATA_B2[17:16], WDATA_B2[13:0], WDATA_B1[17:16]});
						ram_be_b2 = BE_B2;
						ram_be_b1 = BE_B1;
					end
					MODE_18: begin
						ram_wdata_b1 = (FMODE1 ? 18'b000000000000000000 : WDATA_B1);
						ram_wdata_b2 = (FMODE1 ? 18'b000000000000000000 : WDATA_B1);
						ram_be_b1 = BE_B1;
						ram_be_b2 = BE_B1;
					end
					MODE_9:
						case (ram_addr_b1[4:3])
							0: begin
								{ram_wdata_b1[16], ram_wdata_b1[7:0]} = {ram_wdata_b1[16], ram_wdata_b1[7:0]};
								{ram_wdata_b1[17], ram_wdata_b1[15:8]} = 9'b000000000;
								{ram_wdata_b2[16], ram_wdata_b2[7:0]} = 9'b000000000;
								{ram_wdata_b2[17], ram_wdata_b2[15:8]} = 9'b000000000;
								{ram_be_b2, ram_be_b1} = 4'b0001;
							end
							1: begin
								{ram_wdata_b1[16], ram_wdata_b1[7:0]} = 9'b000000000;
								{ram_wdata_b1[17], ram_wdata_b1[15:8]} = {ram_wdata_b1[16], ram_wdata_b1[7:0]};
								{ram_wdata_b2[16], ram_wdata_b2[7:0]} = 9'b000000000;
								{ram_wdata_b2[17], ram_wdata_b2[15:8]} = 9'b000000000;
								{ram_be_b2, ram_be_b1} = 4'b0010;
							end
							2: begin
								{ram_wdata_b1[16], ram_wdata_b1[7:0]} = 9'b000000000;
								{ram_wdata_b1[17], ram_wdata_b1[15:8]} = 9'b000000000;
								{ram_wdata_b2[16], ram_wdata_b2[7:0]} = {ram_wdata_b1[16], ram_wdata_b1[7:0]};
								{ram_wdata_b2[17], ram_wdata_b2[15:8]} = 9'b000000000;
								{ram_be_b2, ram_be_b1} = 4'b0100;
							end
							3: begin
								{ram_wdata_b1[16], ram_wdata_b1[7:0]} = 9'b000000000;
								{ram_wdata_b1[17], ram_wdata_b1[15:8]} = 9'b000000000;
								{ram_wdata_b2[16], ram_wdata_b2[7:0]} = 9'b000000000;
								{ram_wdata_b2[17], ram_wdata_b2[15:8]} = {ram_wdata_b1[16], ram_wdata_b1[7:0]};
								{ram_be_b2, ram_be_b1} = 4'b1000;
							end
						endcase
				endcase
			end
		endcase
	end
	always @(*)
		case (SPLIT)
			0: begin
				ram_rmode_a1 = (RMODE_A1 == MODE_36 ? MODE_18 : RMODE_A1);
				ram_rmode_a2 = (RMODE_A1 == MODE_36 ? MODE_18 : RMODE_A1);
				ram_wmode_a1 = (WMODE_A1 == MODE_36 ? MODE_18 : (FMODE1 ? MODE_18 : WMODE_A1));
				ram_wmode_a2 = (WMODE_A1 == MODE_36 ? MODE_18 : (FMODE1 ? MODE_18 : WMODE_A1));
				ram_rmode_b1 = (RMODE_B1 == MODE_36 ? MODE_18 : (FMODE1 ? MODE_18 : RMODE_B1));
				ram_rmode_b2 = (RMODE_B1 == MODE_36 ? MODE_18 : (FMODE1 ? MODE_18 : RMODE_B1));
				ram_wmode_b1 = (WMODE_B1 == MODE_36 ? MODE_18 : WMODE_B1);
				ram_wmode_b2 = (WMODE_B1 == MODE_36 ? MODE_18 : RMODE_B1);
			end
			1: begin
				ram_rmode_a1 = (RMODE_A1 == MODE_36 ? MODE_18 : RMODE_A1);
				ram_rmode_a2 = (RMODE_A2 == MODE_36 ? MODE_18 : RMODE_A2);
				ram_wmode_a1 = (WMODE_A1 == MODE_36 ? MODE_18 : WMODE_A1);
				ram_wmode_a2 = (WMODE_A2 == MODE_36 ? MODE_18 : WMODE_A2);
				ram_rmode_b1 = (RMODE_B1 == MODE_36 ? MODE_18 : RMODE_B1);
				ram_rmode_b2 = (RMODE_B2 == MODE_36 ? MODE_18 : RMODE_B2);
				ram_wmode_b1 = (WMODE_B1 == MODE_36 ? MODE_18 : WMODE_B1);
				ram_wmode_b2 = (WMODE_B2 == MODE_36 ? MODE_18 : WMODE_B2);
			end
		endcase
	always @(*) begin : FIFO_READ_SEL
		case (RMODE_B1)
			MODE_36: fifo_rdata = {ram_rdata_b2[17:16], ram_rdata_b1[17:16], ram_rdata_b2[15:0], ram_rdata_b1[15:0]};
			MODE_18: fifo_rdata = (ff_raddr[1] ? {18'b000000000000000000, ram_rdata_b2} : {18'b000000000000000000, ram_rdata_b1});
			MODE_9:
				case (ff_raddr[1:0])
					0: fifo_rdata = {27'b000000000000000000000000000, ram_rdata_b1[16], ram_rdata_b1[7:0]};
					1: fifo_rdata = {27'b000000000000000000000000000, ram_rdata_b1[17], ram_rdata_b1[15:8]};
					2: fifo_rdata = {27'b000000000000000000000000000, ram_rdata_b2[16], ram_rdata_b2[7:0]};
					3: fifo_rdata = {27'b000000000000000000000000000, ram_rdata_b2[17], ram_rdata_b2[15:8]};
				endcase
		endcase
	end
	localparam MODE_1 = 3'b001;
	localparam MODE_2 = 3'b010;
	localparam MODE_4 = 3'b100;
	always @(*) begin : RDATA_SEL
		case (SPLIT)
			1: begin
				RDATA_A1 = (FMODE1 ? {10'b0000000000, EMPTY1, EPO1, EWM1, UNDERRUN1, FULL1, FMO1, FWM1, OVERRUN1} : ram_rdata_a1);
				RDATA_B1 = ram_rdata_b1;
				RDATA_A2 = (FMODE2 ? {10'b0000000000, EMPTY2, EPO2, EWM2, UNDERRUN2, FULL2, FMO2, FWM2, OVERRUN2} : ram_rdata_a2);
				RDATA_B2 = ram_rdata_b2;
			end
			0: begin
				if (FMODE1) begin
					RDATA_A1 = {10'b0000000000, EMPTY3, EPO3, EWM3, UNDERRUN3, FULL3, FMO3, FWM3, OVERRUN3};
					RDATA_A2 = 18'b000000000000000000;
				end
				else
					case (RMODE_A1)
						MODE_36: begin
							RDATA_A1 = {ram_rdata_a2[1:0], ram_rdata_a1[15:0]};
							RDATA_A2 = {ram_rdata_a2[17:16], ram_rdata_a1[17:16], ram_rdata_a2[15:2]};
						end
						MODE_18: begin
							RDATA_A1 = (laddr_a1[4] ? ram_rdata_a2 : ram_rdata_a1);
							RDATA_A2 = 18'b000000000000000000;
						end
						MODE_9: begin
							RDATA_A1 = (laddr_a1[4] ? {9'b000000000, ram_rdata_a2[8:0]} : {9'b000000000, ram_rdata_a1[8:0]});
							RDATA_A2 = 18'b000000000000000000;
						end
						MODE_4: begin
							RDATA_A2 = 18'b000000000000000000;
							RDATA_A1[17:4] = 14'b00000000000000;
							RDATA_A1[3:0] = (laddr_a1[4] ? ram_rdata_a2[3:0] : ram_rdata_a1[3:0]);
						end
						MODE_2: begin
							RDATA_A2 = 18'b000000000000000000;
							RDATA_A1[17:2] = 16'b0000000000000000;
							RDATA_A1[1:0] = (laddr_a1[4] ? ram_rdata_a2[1:0] : ram_rdata_a1[1:0]);
						end
						MODE_1: begin
							RDATA_A2 = 18'b000000000000000000;
							RDATA_A1[17:1] = 17'b00000000000000000;
							RDATA_A1[0] = (laddr_a1[4] ? ram_rdata_a2[0] : ram_rdata_a1[0]);
						end
					endcase
				case (RMODE_B1)
					MODE_36: begin
						RDATA_B1 = {ram_rdata_b2[1:0], ram_rdata_b1[15:0]};
						RDATA_B2 = {ram_rdata_b2[17:16], ram_rdata_b1[17:16], ram_rdata_b2[15:2]};
					end
					MODE_18: begin
						RDATA_B1 = (FMODE1 ? fifo_rdata[17:0] : (laddr_b1[4] ? ram_rdata_b2 : ram_rdata_b1));
						RDATA_B2 = 18'b000000000000000000;
					end
					MODE_9: begin
						RDATA_B1 = (FMODE1 ? {9'b000000000, fifo_rdata[8:0]} : (laddr_b1[4] ? {9'b000000000, ram_rdata_b2[8:0]} : {9'b000000000, ram_rdata_b1[8:0]}));
						RDATA_B2 = 18'b000000000000000000;
					end
					MODE_4: begin
						RDATA_B2 = 18'b000000000000000000;
						RDATA_B1[17:4] = 14'b00000000000000;
						RDATA_B1[3:0] = (laddr_b1[4] ? ram_rdata_b2[3:0] : ram_rdata_b1[3:0]);
					end
					MODE_2: begin
						RDATA_B2 = 18'b000000000000000000;
						RDATA_B1[17:2] = 16'b0000000000000000;
						RDATA_B1[1:0] = (laddr_b1[4] ? ram_rdata_b2[1:0] : ram_rdata_b1[1:0]);
					end
					MODE_1: begin
						RDATA_B2 = 18'b000000000000000000;
						RDATA_B1[17:1] = 17'b00000000000000000;
						RDATA_B1[0] = (laddr_b1[4] ? ram_rdata_b2[0] : ram_rdata_b1[0]);
					end
				endcase
			end
		endcase
	end
	always @(posedge CLK_A1) laddr_a1 <= ADDR_A1;
	always @(posedge CLK_B1) laddr_b1 <= ADDR_B1;
	always @(*) begin
		case (WMODE_A1)
			default: fifo_wmode = 2'b00;
			MODE_36: fifo_wmode = 2'b00;
			MODE_18: fifo_wmode = 2'b01;
			MODE_9: fifo_wmode = 2'b10;
		endcase
		case (RMODE_B1)
			default: fifo_rmode = 2'b00;
			MODE_36: fifo_rmode = 2'b00;
			MODE_18: fifo_rmode = 2'b01;
			MODE_9: fifo_rmode = 2'b10;
		endcase
	end
	fifo_ctl #(
		.ADDR_WIDTH(12),
		.FIFO_WIDTH(3'd4)
	) fifo36_ctl(
		.rclk(smux_clk_b1),
		.rst_R_n(~FLUSH1),
		.wclk(smux_clk_a1),
		.rst_W_n(~FLUSH1),
		.ren(REN_B1),
		.wen(ram_wen_a1),
		.sync(SYNC_FIFO1),
		.depth(3'b111),
		.rmode(fifo_rmode),
		.wmode(fifo_wmode),
		.ren_o(ren_o),
		.fflags({FULL3, FMO3, FWM3, OVERRUN3, EMPTY3, EPO3, EWM3, UNDERRUN3}),
		.raddr(ff_raddr),
		.waddr(ff_waddr),
		.upaf({1'b0, UPAF1}),
		.upae({1'b0, UPAE1})
	);
	TDP18Kx18_FIFO u1(
		.RMODE_A(ram_rmode_a1),
		.RMODE_B(ram_rmode_b1),
		.WMODE_A(ram_wmode_a1),
		.WMODE_B(ram_wmode_b1),
		.WEN_A(ram_wen_a1),
		.WEN_B(ram_wen_b1),
		.REN_A(ram_ren_a1),
		.REN_B(ram_ren_b1),
		.CLK_A(smux_clk_a1),
		.CLK_B(smux_clk_b1),
		.BE_A(ram_be_a1),
		.BE_B(ram_be_b1),
		.ADDR_A(ram_addr_a1),
		.ADDR_B(ram_addr_b1),
		.WDATA_A(ram_wdata_a1),
		.WDATA_B(ram_wdata_b1),
		.RDATA_A(ram_rdata_a1),
		.RDATA_B(ram_rdata_b1),
		.EMPTY(EMPTY1),
		.EPO(EPO1),
		.EWM(EWM1),
		.UNDERRUN(UNDERRUN1),
		.FULL(FULL1),
		.FMO(FMO1),
		.FWM(FWM1),
		.OVERRUN(OVERRUN1),
		.FLUSH(FLUSH1),
		.FMODE(ram_fmode1),
		.UPAF(UPAF1),
		.UPAE(UPAE1),
		.SYNC_FIFO(SYNC_FIFO1),
		.POWERDN(POWERDN1),
		.SLEEP(SLEEP1),
		.PROTECT(PROTECT1),
		.PL_INIT(PL_INIT_i),
		.PL_ENA(PL_ENA_i),
		.PL_WEN(PL_WEN_i[0]),
		.PL_REN(PL_REN_i),
		.PL_CLK(PL_CLK_i),
		.PL_ADDR(PL_ADDR_i),
		.PL_DATA_IN({PL_DATA_i[33:32], PL_DATA_i[15:0]}),
		.PL_DATA_OUT({PL_DATA_o[33:32], PL_DATA_o[15:0]}),
		.RAM_ID({RAM_ID_i})
	);
	TDP18Kx18_FIFO u2(
		.RMODE_A(ram_rmode_a2),
		.RMODE_B(ram_rmode_b2),
		.WMODE_A(ram_wmode_a2),
		.WMODE_B(ram_wmode_b2),
		.WEN_A(ram_wen_a2),
		.WEN_B(ram_wen_b2),
		.REN_A(ram_ren_a2),
		.REN_B(ram_ren_b2),
		.CLK_A(smux_clk_a2),
		.CLK_B(smux_clk_b2),
		.BE_A(ram_be_a2),
		.BE_B(ram_be_b2),
		.ADDR_A(ram_addr_a2),
		.ADDR_B(ram_addr_b2),
		.WDATA_A(ram_wdata_a2),
		.WDATA_B(ram_wdata_b2),
		.RDATA_A(ram_rdata_a2),
		.RDATA_B(ram_rdata_b2),
		.EMPTY(EMPTY2),
		.EPO(EPO2),
		.EWM(EWM2),
		.UNDERRUN(UNDERRUN2),
		.FULL(FULL2),
		.FMO(FMO2),
		.FWM(FWM2),
		.OVERRUN(OVERRUN2),
		.FLUSH(FLUSH2),
		.FMODE(ram_fmode2),
		.UPAF(UPAF2),
		.UPAE(UPAE2),
		.SYNC_FIFO(SYNC_FIFO2),
		.POWERDN(POWERDN2),
		.SLEEP(SLEEP2),
		.PROTECT(PROTECT2),
		.PL_INIT(PL_INIT_i),
		.PL_ENA(PL_ENA_i),
		.PL_WEN(PL_WEN_i[1]),
		.PL_REN(PL_REN_i),
		.PL_CLK(PL_CLK_i),
		.PL_ADDR(PL_ADDR_i),
		.PL_DATA_IN({PL_DATA_i[35:34], PL_DATA_i[31:16]}),
		.PL_DATA_OUT({PL_DATA_o[35:34], PL_DATA_o[31:16]}),
		.RAM_ID(RAM_ID_i)
	);
	always @(*) begin
		PL_ADDR_o = PL_ADDR_i;
		PL_INIT_o = PL_INIT_i;
		PL_ENA_o = PL_ENA_i;
		PL_WEN_o = PL_WEN_i;
		PL_REN_o = PL_REN_i;
		PL_CLK_o = PL_CLK_i;
	end
endmodule
