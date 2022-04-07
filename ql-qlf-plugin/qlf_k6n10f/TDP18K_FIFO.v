// Copyright 2020-2022 F4PGA Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

`default_nettype wire
module TDP18K_FIFO (
	RMODE_A_i,
	RMODE_B_i,
	WMODE_A_i,
	WMODE_B_i,
	WEN_A_i,
	WEN_B_i,
	REN_A_i,
	REN_B_i,
	CLK_A_i,
	CLK_B_i,
	BE_A_i,
	BE_B_i,
	ADDR_A_i,
	ADDR_B_i,
	WDATA_A_i,
	WDATA_B_i,
	RDATA_A_o,
	RDATA_B_o,
	EMPTY_o,
	EPO_o,
	EWM_o,
	UNDERRUN_o,
	FULL_o,
	FMO_o,
	FWM_o,
	OVERRUN_o,
	FLUSH_ni,
	FMODE_i,
	PL_INIT_i,
	PL_ENA_i,
	PL_WEN_i,
	PL_REN_i,
	PL_CLK_i,
	PL_ADDR_i,
	PL_DATA_IN_i,
	PL_DATA_OUT_o,
	RAM_ID_i
);
	parameter SYNC_FIFO_i = 1'b0;
	parameter POWERDN_i = 1'b0;
	parameter SLEEP_i = 1'b0;
	parameter PROTECT_i = 1'b0;
	parameter UPAF_i = 11'b0;
	parameter UPAE_i = 11'b0;

	input wire [2:0] RMODE_A_i;
	input wire [2:0] RMODE_B_i;
	input wire [2:0] WMODE_A_i;
	input wire [2:0] WMODE_B_i;
	input wire WEN_A_i;
	input wire WEN_B_i;
	input wire REN_A_i;
	input wire REN_B_i;
	(* clkbuf_sink *)
	input wire CLK_A_i;
	(* clkbuf_sink *)
	input wire CLK_B_i;
	input wire [1:0] BE_A_i;
	input wire [1:0] BE_B_i;
	input wire [13:0] ADDR_A_i;
	input wire [13:0] ADDR_B_i;
	input wire [17:0] WDATA_A_i;
	input wire [17:0] WDATA_B_i;
	output reg [17:0] RDATA_A_o;
	output reg [17:0] RDATA_B_o;
	output wire EMPTY_o;
	output wire EPO_o;
	output wire EWM_o;
	output wire UNDERRUN_o;
	output wire FULL_o;
	output wire FMO_o;
	output wire FWM_o;
	output wire OVERRUN_o;
	input wire FLUSH_ni;
	input wire FMODE_i;
	input PL_INIT_i;
	input PL_ENA_i;
	input PL_WEN_i;
	input PL_REN_i;
	input PL_CLK_i;
	input [31:0] PL_ADDR_i;
	input [17:0] PL_DATA_IN_i;
	output reg [17:0] PL_DATA_OUT_o;
	input [19:0] RAM_ID_i;
	reg [17:0] wmsk_a;
	reg [17:0] wmsk_b;
	wire [8:0] addr_a;
	wire [8:0] addr_b;
	reg [4:0] addr_a_d;
	reg [4:0] addr_b_d;
	wire [17:0] ram_rdata_a;
	wire [17:0] ram_rdata_b;
	reg [17:0] aligned_wdata_a;
	reg [17:0] aligned_wdata_b;
	wire ren_o;
	wire [10:0] ff_raddr;
	wire [10:0] ff_waddr;
	wire [13:0] ram_addr_a;
	wire [13:0] ram_addr_b;
	wire [3:0] ram_waddr_a;
	wire [3:0] ram_waddr_b;
	wire preload;
	reg my_id;
	wire initn;
	wire smux_rclk;
	wire smux_wclk;
	wire real_fmode;
	wire [3:0] raw_fflags;
	reg [1:0] fifo_rmode;
	reg [1:0] fifo_wmode;
	wire smux_clk_a;
	wire smux_clk_b;
	wire ram_ren_a;
	wire ram_ren_b;
	wire ram_wen_a;
	wire ram_wen_b;
	wire cen_a;
	wire cen_b;
	wire cen_a_n;
	wire cen_b_n;
	wire ram_wen_a_n;
	wire ram_wen_b_n;
	localparam MODE_9 = 3'b001;
	always @(*) begin
		fifo_rmode = (RMODE_B_i == MODE_9 ? 2'b10 : 2'b01);
		fifo_wmode = (WMODE_A_i == MODE_9 ? 2'b10 : 2'b01);
	end
	always @(*) begin
		my_id = PL_INIT_i;
		if ((RAM_ID_i[19:10] == PL_ADDR_i[31:22]) | (RAM_ID_i[19:10] == 10'b0000000000))
			if ((RAM_ID_i[9:0] == PL_ADDR_i[21:12]) | (RAM_ID_i[9:0] == 10'b0000000000))
				my_id = 1'b1;
	end
	assign preload = (PROTECT_i ? 1'b0 : my_id & PL_ENA_i);
	assign smux_clk_a = CLK_A_i;
	assign smux_clk_b = CLK_B_i;
	assign real_fmode = (preload ? 1'b0 : FMODE_i);
	assign ram_ren_b = (preload ? PL_REN_i : (real_fmode ? ren_o : REN_B_i));
	assign ram_wen_a = (preload ? PL_WEN_i : (FMODE_i ? ~FULL_o & WEN_A_i : WEN_A_i));
	assign ram_ren_a = (preload ? 1'b1 : (FMODE_i ? 0 : REN_A_i));
	assign ram_wen_b = (preload ? 1'b1 : (FMODE_i ? 1'b0 : WEN_B_i));
	assign cen_b = ram_ren_b | ram_wen_b;
	assign cen_a = ram_ren_a | ram_wen_a;
	assign ram_waddr_b = (preload ? 4'b0000 : (real_fmode ? {ff_raddr[0], 3'b000} : ADDR_B_i[3:0]));
	assign ram_waddr_a = (preload ? 4'b0000 : (real_fmode ? {ff_waddr[0], 3'b000} : ADDR_A_i[3:0]));
	assign ram_addr_b = (preload ? {PL_ADDR_i[9:0], 4'h0} : (real_fmode ? {ff_raddr[10:0], 3'h0} : {ADDR_B_i[13:4], addr_b_d[3:0]}));
	assign ram_addr_a = (preload ? {PL_ADDR_i[9:0], 4'h0} : (real_fmode ? {ff_waddr[10:0], 3'h0} : {ADDR_A_i[13:4], addr_a_d[3:0]}));
	always @(posedge CLK_A_i) addr_a_d[3:0] <= ADDR_A_i[3:0];
	always @(posedge CLK_B_i) addr_b_d[3:0] <= ADDR_B_i[3:0];
	assign cen_a_n = ~cen_a;
	assign ram_wen_a_n = ~ram_wen_a;
	assign cen_b_n = ~cen_b;
	assign ram_wen_b_n = ~ram_wen_b;
	dti_dp_tm16fcll_1024x18_t8bw2x_m_hc uram(
		.DO_A(ram_rdata_a),
		.DO_B(ram_rdata_b),
		.A_A(ram_addr_a[13:4]),
		.A_B(ram_addr_b[13:4]),
		.T_A_A(ram_addr_a[13:4]),
		.T_A_B(ram_addr_b[13:4]),
		.DI_A(aligned_wdata_a),
		.DI_B(aligned_wdata_b),
		.T_DI_A(aligned_wdata_a),
		.T_DI_B(aligned_wdata_b),
		.T_BE_N(1'b1),
		.CE_N_A(cen_a_n),
		.CE_N_B(cen_b_n),
		.T_CE_N_A(cen_a_n),
		.T_CE_N_B(cen_b_n),
		.GWE_N_A(ram_wen_a_n),
		.GWE_N_B(ram_wen_b_n),
		.T_GWE_N_A(ram_wen_a_n),
		.T_GWE_N_B(ram_wen_b_n),
		.BWE_N_A(wmsk_a),
		.BWE_N_B(wmsk_b),
		.T_BWE_N_A(wmsk_a),
		.T_BWE_N_B(wmsk_b),
		.T_RWM_A(3'b011),
		.T_RWM_B(3'b011),
		.CLK_A(smux_clk_a),
		.CLK_B(smux_clk_b)
	);
	fifo_ctl #(
		.ADDR_WIDTH(11),
		.FIFO_WIDTH(2),
		.DEPTH(6)
	) fifo_ctl(
		.rclk(smux_clk_b),
		.rst_R_n(FLUSH_ni),
		.wclk(smux_clk_a),
		.rst_W_n(FLUSH_ni),
		.ren(REN_B_i),
		.wen(ram_wen_a),
		.sync(SYNC_FIFO_i),
		.rmode(fifo_rmode),
		.wmode(fifo_wmode),
		.ren_o(ren_o),
		.fflags({FULL_o, FMO_o, FWM_o, OVERRUN_o, EMPTY_o, EPO_o, EWM_o, UNDERRUN_o}),
		.raddr(ff_raddr),
		.waddr(ff_waddr),
		.upaf(UPAF_i),
		.upae(UPAE_i)
	);
	always @(*) begin : PRELOAD_DATA
		if (preload & ram_ren_a)
			PL_DATA_OUT_o = ram_rdata_a;
		else
			PL_DATA_OUT_o = PL_DATA_IN_i;
	end
	localparam MODE_1 = 3'b101;
	localparam MODE_18 = 3'b010;
	localparam MODE_2 = 3'b110;
	localparam MODE_4 = 3'b100;
	always @(*) begin : WDATA_MODE_SEL
		if (ram_wen_a == 1) begin
			if (preload) begin
				aligned_wdata_a = PL_DATA_IN_i;
				wmsk_a = 18'h00000;
			end
			else
				case (WMODE_A_i)
					MODE_18: begin
						aligned_wdata_a = WDATA_A_i;
						{wmsk_a[17], wmsk_a[15:8]} = (FMODE_i ? 9'h000 : (BE_A_i[1] ? 9'h000 : 9'h1ff));
						{wmsk_a[16], wmsk_a[7:0]} = (FMODE_i ? 9'h000 : (BE_A_i[0] ? 9'h000 : 9'h1ff));
					end
					MODE_9: begin
						aligned_wdata_a = {{2 {WDATA_A_i[16]}}, {2 {WDATA_A_i[7:0]}}};
						{wmsk_a[17], wmsk_a[15:8]} = (ram_waddr_a[3] ? 9'h000 : 9'h1ff);
						{wmsk_a[16], wmsk_a[7:0]} = (ram_waddr_a[3] ? 9'h1ff : 9'h000);
					end
					MODE_4: begin
						aligned_wdata_a = {2'b00, {4 {WDATA_A_i[3:0]}}};
						wmsk_a[17:16] = 2'b00;
						wmsk_a[15:12] = (ram_waddr_a[3:2] == 2'b11 ? 4'h0 : 4'hf);
						wmsk_a[11:8] = (ram_waddr_a[3:2] == 2'b10 ? 4'h0 : 4'hf);
						wmsk_a[7:4] = (ram_waddr_a[3:2] == 2'b01 ? 4'h0 : 4'hf);
						wmsk_a[3:0] = (ram_waddr_a[3:2] == 2'b00 ? 4'h0 : 4'hf);
					end
					MODE_2: begin
						aligned_wdata_a = {2'b00, {8 {WDATA_A_i[1:0]}}};
						wmsk_a[17:16] = 2'b00;
						wmsk_a[15:14] = (ram_waddr_a[3:1] == 3'b111 ? 2'h0 : 2'h3);
						wmsk_a[13:12] = (ram_waddr_a[3:1] == 3'b110 ? 2'h0 : 2'h3);
						wmsk_a[11:10] = (ram_waddr_a[3:1] == 3'b101 ? 2'h0 : 2'h3);
						wmsk_a[9:8] = (ram_waddr_a[3:1] == 3'b100 ? 2'h0 : 2'h3);
						wmsk_a[7:6] = (ram_waddr_a[3:1] == 3'b011 ? 2'h0 : 2'h3);
						wmsk_a[5:4] = (ram_waddr_a[3:1] == 3'b010 ? 2'h0 : 2'h3);
						wmsk_a[3:2] = (ram_waddr_a[3:1] == 3'b001 ? 2'h0 : 2'h3);
						wmsk_a[1:0] = (ram_waddr_a[3:1] == 3'b000 ? 2'h0 : 2'h3);
					end
					MODE_1: begin
						aligned_wdata_a = {2'b00, {16 {WDATA_A_i[0]}}};
						wmsk_a = 18'h0ffff;
						wmsk_a[{1'b0, ram_waddr_a[3:0]}] = 0;
					end
					default: wmsk_a = 18'h3ffff;
				endcase
		end
		else begin
			aligned_wdata_a = 18'h00000;
			wmsk_a = 18'h3ffff;
		end
		if (ram_wen_b == 1)
			case (WMODE_B_i)
				MODE_18: begin
					aligned_wdata_b = WDATA_B_i;
					{wmsk_b[17], wmsk_b[15:8]} = (BE_B_i[1] ? 9'h000 : 9'h1ff);
					{wmsk_b[16], wmsk_b[7:0]} = (BE_B_i[0] ? 9'h000 : 9'h1ff);
				end
				MODE_9: begin
					aligned_wdata_b = {{2 {WDATA_B_i[16]}}, {2 {WDATA_B_i[7:0]}}};
					{wmsk_b[17], wmsk_b[15:8]} = (ram_waddr_b[3] ? 9'h000 : 9'h1ff);
					{wmsk_b[16], wmsk_b[7:0]} = (ram_waddr_b[3] ? 9'h1ff : 9'h000);
				end
				MODE_4: begin
					aligned_wdata_b = {2'b00, {4 {WDATA_B_i[3:0]}}};
					wmsk_b[17:16] = 2'b00;
					wmsk_b[15:12] = (ram_waddr_b[3:2] == 2'b11 ? 4'h0 : 4'hf);
					wmsk_b[11:8] = (ram_waddr_b[3:2] == 2'b10 ? 4'h0 : 4'hf);
					wmsk_b[7:4] = (ram_waddr_b[3:2] == 2'b01 ? 4'h0 : 4'hf);
					wmsk_b[3:0] = (ram_waddr_b[3:2] == 2'b00 ? 4'h0 : 4'hf);
				end
				MODE_2: begin
					aligned_wdata_b = {2'b00, {8 {WDATA_B_i[1:0]}}};
					wmsk_b[17:16] = 2'b00;
					wmsk_b[15:14] = (ram_waddr_b[3:1] == 3'b111 ? 2'h0 : 2'h3);
					wmsk_b[13:12] = (ram_waddr_b[3:1] == 3'b110 ? 2'h0 : 2'h3);
					wmsk_b[11:10] = (ram_waddr_b[3:1] == 3'b101 ? 2'h0 : 2'h3);
					wmsk_b[9:8] = (ram_waddr_b[3:1] == 3'b100 ? 2'h0 : 2'h3);
					wmsk_b[7:6] = (ram_waddr_b[3:1] == 3'b011 ? 2'h0 : 2'h3);
					wmsk_b[5:4] = (ram_waddr_b[3:1] == 3'b010 ? 2'h0 : 2'h3);
					wmsk_b[3:2] = (ram_waddr_b[3:1] == 3'b001 ? 2'h0 : 2'h3);
					wmsk_b[1:0] = (ram_waddr_b[3:1] == 3'b000 ? 2'h0 : 2'h3);
				end
				MODE_1: begin
					aligned_wdata_b = {2'b00, {16 {WDATA_B_i[0]}}};
					wmsk_b = 18'h0ffff;
					wmsk_b[{1'b0, ram_waddr_b[3:0]}] = 0;
				end
				default: wmsk_b = 18'h3ffff;
			endcase
		else begin
			aligned_wdata_b = 18'b000000000000000000;
			wmsk_b = 18'h3ffff;
		end
	end
	always @(*) begin : RDATA_A_MODE_SEL
		case (RMODE_A_i)
			default: RDATA_A_o = 18'h00000;
			MODE_18: RDATA_A_o = ram_rdata_a;
			MODE_9: begin
				{RDATA_A_o[17], RDATA_A_o[15:8]} = 9'h000;
				{RDATA_A_o[16], RDATA_A_o[7:0]} = (ram_addr_a[3] ? {ram_rdata_a[17], ram_rdata_a[15:8]} : {ram_rdata_a[16], ram_rdata_a[7:0]});
			end
			MODE_4: begin
				RDATA_A_o[17:4] = 14'h0000;
				case (ram_addr_a[3:2])
					3: RDATA_A_o[3:0] = ram_rdata_a[15:12];
					2: RDATA_A_o[3:0] = ram_rdata_a[11:8];
					1: RDATA_A_o[3:0] = ram_rdata_a[7:4];
					0: RDATA_A_o[3:0] = ram_rdata_a[3:0];
				endcase
			end
			MODE_2: begin
				RDATA_A_o[17:2] = 16'h0000;
				case (ram_addr_a[3:1])
					7: RDATA_A_o[1:0] = ram_rdata_a[15:14];
					6: RDATA_A_o[1:0] = ram_rdata_a[13:12];
					5: RDATA_A_o[1:0] = ram_rdata_a[11:10];
					4: RDATA_A_o[1:0] = ram_rdata_a[9:8];
					3: RDATA_A_o[1:0] = ram_rdata_a[7:6];
					2: RDATA_A_o[1:0] = ram_rdata_a[5:4];
					1: RDATA_A_o[1:0] = ram_rdata_a[3:2];
					0: RDATA_A_o[1:0] = ram_rdata_a[1:0];
				endcase
			end
			MODE_1: begin
				RDATA_A_o[17:1] = 17'h00000;
				RDATA_A_o[0] = ram_rdata_a[ram_addr_a[3:0]];
			end
		endcase
	end
	always @(*)
		case (RMODE_B_i)
			default: RDATA_B_o = 18'h15566;
			MODE_18: RDATA_B_o = ram_rdata_b;
			MODE_9: begin
				{RDATA_B_o[17], RDATA_B_o[15:8]} = 9'b000000000;
				{RDATA_B_o[16], RDATA_B_o[7:0]} = (ram_addr_b[3] ? {ram_rdata_b[17], ram_rdata_b[15:8]} : {ram_rdata_b[16], ram_rdata_b[7:0]});
			end
			MODE_4:
				case (ram_addr_b[3:2])
					3: RDATA_B_o[3:0] = ram_rdata_b[15:12];
					2: RDATA_B_o[3:0] = ram_rdata_b[11:8];
					1: RDATA_B_o[3:0] = ram_rdata_b[7:4];
					0: RDATA_B_o[3:0] = ram_rdata_b[3:0];
				endcase
			MODE_2:
				case (ram_addr_b[3:1])
					7: RDATA_B_o[1:0] = ram_rdata_b[15:14];
					6: RDATA_B_o[1:0] = ram_rdata_b[13:12];
					5: RDATA_B_o[1:0] = ram_rdata_b[11:10];
					4: RDATA_B_o[1:0] = ram_rdata_b[9:8];
					3: RDATA_B_o[1:0] = ram_rdata_b[7:6];
					2: RDATA_B_o[1:0] = ram_rdata_b[5:4];
					1: RDATA_B_o[1:0] = ram_rdata_b[3:2];
					0: RDATA_B_o[1:0] = ram_rdata_b[1:0];
				endcase
			MODE_1: RDATA_B_o[0] = ram_rdata_b[{1'b0, ram_addr_b[3:0]}];
		endcase
endmodule
`default_nettype none
