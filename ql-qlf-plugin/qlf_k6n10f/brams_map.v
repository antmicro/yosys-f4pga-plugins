// Copyright (C) 2020-2021  The SymbiFlow Authors.
//
// Use of this source code is governed by a ISC-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/ISC
//
// SPDX-License-Identifier:ISC

module \$__QLF_FACTOR_BRAM36_TDP (CLK2, CLK3, A1ADDR, A1DATA, A1EN, B1ADDR, B1DATA, B1EN);
	parameter CFG_ABITS = 10;
	parameter CFG_DBITS = 36;
	parameter CFG_ENABLE_B = 4;

	parameter CLKPOL2 = 1;
	parameter CLKPOL3 = 1;
	parameter [36863:0] INIT = 36864'bx;

	localparam MODE_36  = 3'b111;	// 36 or 32-bit
	localparam MODE_18  = 3'b110;	// 18 or 16-bit
	localparam MODE_9   = 3'b101;	// 9 or 8-bit
	localparam MODE_4   = 3'b100;	// 4-bit
	localparam MODE_2   = 3'b010;	// 32-bit
	localparam MODE_1   = 3'b001;	// 32-bit

	input CLK2;
	input CLK3;

	input [CFG_ABITS-1:0] A1ADDR;
	output [CFG_DBITS-1:0] A1DATA;
	input A1EN;

	input [CFG_ABITS-1:0] B1ADDR;
	input [CFG_DBITS-1:0] B1DATA;
	input [CFG_ENABLE_B-1:0] B1EN;

	wire [14:0] A1ADDR_15;
	wire [14:0] B1ADDR_15; 

	wire [35:0] DOBDO;

	wire FLUSH1;
	wire FLUSH2;
	wire SPLIT;
	wire [10:0] UPAE1;
	wire [10:0] UPAF1;
	wire [10:0] UPAE2;
	wire [10:0] UPAF2;
	wire SYNC_FIFO1;
	wire SYNC_FIFO2;
	wire FMODE1;
	wire FMODE2;
	wire POWERDN1;
	wire POWERDN2;
	wire SLEEP1;
	wire SLEEP2;
	wire PROTECT1;
	wire PROTECT2;
	wire [8:0] RAM_ID_i;

	wire PL_INIT_i;
	wire PL_ENA_i;
	wire PL_REN_i;
	wire PL_CLK_i;
	wire [1:0] PL_WEN_i;
	wire [23:0] PL_ADDR_i;
	wire [35:0] PL_DATA_i;
	reg PL_INIT_o;
	reg PL_ENA_o;
	reg PL_REN_o;
	reg PL_CLK_o;
	reg [1:0] PL_WEN_o;
	reg [23:0] PL_ADDR_o;
	wire [35:0] PL_DATA_o;

	wire [2:0] WMODE_A1;
	wire [2:0] WMODE_A2;
	wire [2:0] WMODE_B1;
	wire [2:0] WMODE_B2;
	wire [2:0] RMODE_A1;
	wire [2:0] RMODE_A2;
	wire [2:0] RMODE_B1;
	wire [2:0] RMODE_B2;

        assign A1ADDR_15[14:CFG_ABITS]  = 0;
        assign A1ADDR_15[CFG_ABITS-1:0] = A1ADDR;
        assign B1ADDR_15[14:CFG_ABITS]  = 0;
        assign B1ADDR_15[CFG_ABITS-1:0] = B1ADDR;

	assign WMODE_A1 = 3'b0;
	assign WMODE_A2 = 3'b0;
	assign WMODE_B1 = MODE_36;
	assign WMODE_B2 = MODE_36;
	assign RMODE_A1 = MODE_36;
	assign RMODE_A2 = MODE_36;
	assign RMODE_B1 = MODE_36;
	assign RMODE_B2 = MODE_36;

	assign SPLIT = 1'b0;
	assign FLUSH1 = 1'b0;
	assign FLUSH2 = 1'b0;
	assign UPAE1 = 11'd10;
	assign UPAF1 = 11'd10;
	assign UPAE2 = 11'd10;
	assign UPAF2 = 11'd10;
	assign SYNC_FIFO1 = 1'b0;
	assign SYNC_FIFO2 = 1'b0;
	assign FMODE1 = 1'b0;
	assign FMODE2 = 1'b0;
	assign POWERDN1 = 1'b0;
	assign POWERDN2 = 1'b0;
	assign SLEEP1 = 1'b0;
	assign SLEEP2 = 1'b0;
	assign PROTECT1 = 1'b0;
	assign PROTECT2 = 1'b0;
	assign RAM_ID_i = 9'b0;

	assign PL_INIT_i = 1'b0;
	assign PL_ENA_i = 1'b0;
	assign PL_REN_i = 1'b0;
	assign PL_CLK_i = 1'b0;
	assign PL_WEN_i = 2'b0;
	assign PL_ADDR_i = 24'b0;
	assign PL_DATA_i = 36'b0;

	/*if (CFG_DBITS == 1) begin
	  assign WRITEDATAWIDTHB = 3'b000;
	  assign READDATAWIDTHA = 3'b000;
	end else if (CFG_DBITS == 2) begin
          assign WRITEDATAWIDTHB = 3'b001;
          assign READDATAWIDTHA = 3'b001;
        end else if (CFG_DBITS > 2 && CFG_DBITS <= 4) begin
          assign WRITEDATAWIDTHB = 3'b010;
          assign READDATAWIDTHA = 3'b010;
        end else if (CFG_DBITS > 4 && CFG_DBITS <= 9) begin
          assign WRITEDATAWIDTHB = 3'b011;
          assign READDATAWIDTHA = 3'b011;
        end else if (CFG_DBITS > 9 && CFG_DBITS <= 18) begin
          assign WRITEDATAWIDTHB = 3'b100;
          assign READDATAWIDTHA = 3'b100;
        end else if (CFG_DBITS > 18 && CFG_DBITS <= 36) begin
          assign WRITEDATAWIDTHB = 3'b101;
          assign READDATAWIDTHA = 3'b101;
	end*/

	TDP_BRAM36 #() _TECHMAP_REPLACE_ (
		.WMODE_A1(WMODE_A1),
		.WMODE_A2(WMODE_A2),
		.RMODE_A1(RMODE_A1),
		.RMODE_A2(RMODE_A2),

		.WDATA_A1(18'h3FFFF),
		.WDATA_A2(18'h3FFFF),
		.RDATA_A1(A1DATA[17:0]),
		.RDATA_A2(A1DATA[35:18]),
		.ADDR_A1(A1ADDR_15),
		.ADDR_A2(A1ADDR_15),
		.CLK_A1(CLK2),
		.CLK_A2(CLK2),
		.REN_A1(A1EN),
		.REN_A2(A1EN),
		.WEN_A1(1'b0),
		.WEN_A2(1'b0),
		.BE_A1({A1EN, A1EN}),
		.BE_A2({A1EN, A1EN}),


		.WMODE_B1(WMODE_B1),
		.WMODE_B2(WMODE_B2),
		.RMODE_B1(RMODE_B1),
		.RMODE_B2(RMODE_B2),

		.WDATA_B1(B1DATA[17:0]),
		.WDATA_B2(B1DATA[35:18]),
		.RDATA_B1(DOBDO[17:0]),
		.RDATA_B2(DOBDO[35:18]),
		.ADDR_B1(B1ADDR_15),
		.ADDR_B2(B1ADDR_15),
		.CLK_B1(CLK3),
		.CLK_B2(CLK3),
		.REN_B1(1'b0),
		.REN_B2(1'b0),
		.WEN_B1(B1EN[0]),
		.WEN_B2(B1EN[0]),
		.BE_B1(B1EN[1:0]),
		.BE_B2(B1EN[3:2]),


		.SPLIT(SPLIT),
		.FLUSH1(FLUSH1),
		.FLUSH2(FLUSH2),
		.UPAE1(UPAE1),
		.UPAF1(UPAF1),
		.UPAE2(UPAE2),
		.UPAF2(UPAF2),
		.SYNC_FIFO1(SYNC_FIFO1),
		.SYNC_FIFO2(SYNC_FIFO2),
		.FMODE1(FMODE1),
		.FMODE2(FMODE2),
		.POWERDN1(POWERDN1),
		.POWERDN2(POWERDN2),
		.SLEEP1(SLEEP1),
		.SLEEP2(SLEEP2),
		.PROTECT1(PROTECT1),
		.PROTECT2(PROTECT2),
		.RAM_ID_i(RAM_ID_i),

		.PL_INIT_i(PL_INIT_i),
		.PL_ENA_i(PL_ENA_i),
		.PL_WEN_i(PL_WEN_i),
		.PL_REN_i(PL_REN_i),
		.PL_CLK_i(PL_CLK_i),
		.PL_ADDR_i(PL_ADDR_i),
		.PL_DATA_i(PL_DATA_i),
		.PL_INIT_o(PL_INIT_o),
		.PL_ENA_o(PL_ENA_o),
		.PL_WEN_o(PL_WEN_o),
		.PL_REN_o(PL_REN_o),
		.PL_CLK_o(PL_CLK_o),
		.PL_ADDR_o(),
		.PL_DATA_o(PL_DATA_o)

	);
endmodule

// ------------------------------------------------------------------------

module \$__QLF_FACTOR_BRAM18_TDP (CLK2, CLK3, A1ADDR, A1DATA, A1EN, B1ADDR, B1DATA, B1EN);
	parameter CFG_ABITS = 10;
	parameter CFG_DBITS = 18;
	parameter CFG_ENABLE_B = 2;

	parameter CLKPOL2 = 1;
	parameter CLKPOL3 = 1;
	parameter [18431:0] INIT = 18432'bx;

	input CLK2;
	input CLK3;

	input [CFG_ABITS-1:0] A1ADDR;
	output [CFG_DBITS-1:0] A1DATA;
	input A1EN;

	input [CFG_ABITS-1:0] B1ADDR;
	input [CFG_DBITS-1:0] B1DATA;
	input [CFG_ENABLE_B-1:0] B1EN;

	wire [13:0] A1ADDR_14;
	wire [13:0] B1ADDR_14;
	//wire [3:0] B1EN_4 = B1EN;

	wire [1:0] DIP, DOP;
	wire [15:0] DI, DO;

	wire [15:0] DOBDO;
	wire [1:0] DOPBDOP;

	assign A1DATA = { DOP[1], DO[15: 8], DOP[0], DO[ 7: 0] };
	assign { DIP[1], DI[15: 8], DIP[0], DI[ 7: 0] } = B1DATA;
        
        assign A1ADDR_14[13:CFG_ABITS]  = 0;
        assign A1ADDR_14[CFG_ABITS-1:0] = A1ADDR;
        assign B1ADDR_14[13:CFG_ABITS]  = 0;
        assign B1ADDR_14[CFG_ABITS-1:0] = B1ADDR;

	/*if (CFG_DBITS == 1) begin
	  assign WRITEDATAWIDTHB = 3'b000;
	  assign READDATAWIDTHA = 3'b000;
	end else if (CFG_DBITS == 2) begin
          assign WRITEDATAWIDTHB = 3'b001;
          assign READDATAWIDTHA = 3'b001;
        end else if (CFG_DBITS > 2 && CFG_DBITS <= 4) begin
          assign WRITEDATAWIDTHB = 3'b010;
          assign READDATAWIDTHA = 3'b010;
        end else if (CFG_DBITS > 4 && CFG_DBITS <= 9) begin
          assign WRITEDATAWIDTHB = 3'b011;
          assign READDATAWIDTHA = 3'b011;
        end else if (CFG_DBITS > 9 && CFG_DBITS <= 18) begin
          //assign WRITEDATAWIDTHB = 3'b100;
          assign READDATAWIDTHA = 3'b100;
	end*/
	generate if (CFG_DBITS > 8) begin
		TDP_BRAM18 #(
			//`include "brams_init_18.vh"
                        .READ_WIDTH_A(CFG_DBITS),
                        .READ_WIDTH_B(CFG_DBITS),
                        .WRITE_WIDTH_A(CFG_DBITS),
                        .WRITE_WIDTH_B(CFG_DBITS),
		) _TECHMAP_REPLACE_ (
			.WRITEDATAA(16'hFFFF),
			.WRITEDATAAP(2'b11),
			.READDATAA(DO[15:0]),
			.READDATAAP(DOP[2:0]),
			.ADDRA(A1ADDR_14),
			.CLOCKA(CLK2),
			.READENABLEA(A1EN),
			.WRITEENABLEA(1'b0),
			.BYTEENABLEA(2'b0),
			//.WRITEDATAWIDTHA(3'b0),
			//.READDATAWIDTHA(READDATAWIDTHA),

			.WRITEDATAB(DI),
			.WRITEDATABP(DIP),
			.READDATAB(DOBDO),
			.READDATABP(DOPBDOP),
			.ADDRB(B1ADDR_14),
			.CLOCKB(CLK3),
			.READENABLEB(1'b0),
			.WRITEENABLEB(1'b1),
			.BYTEENABLEB(B1EN)
			//.WRITEDATAWIDTHB(WRITEDATAWIDTHB),
			//.READDATAWIDTHB(3'b0)
		);
	end else begin
		TDP_BRAM18 #(
			//`include "brams_init_16.vh"
		) _TECHMAP_REPLACE_ (
			.WRITEDATAA(16'hFFFF),
			.WRITEDATAAP(2'b11),
			.READDATAA(DO[15:0]),
			.READDATAAP(DOP[2:0]),
			.ADDRA(A1ADDR_14),
			.CLOCKA(CLK2),
			.READENABLEA(A1EN),
			.WRITEENABLEA(1'b0),
			.BYTEENABLEA(2'b0),
			//.WRITEDATAWIDTHA(3'b0),
		//	.READDATAWIDTHA(READDATAWIDTHA),

			.WRITEDATAB(DI),
			.WRITEDATABP(DIP),
			.READDATAB(DOBDO),
			.READDATABP(DOPBDOP),
			.ADDRB(B1ADDR_14),
			.CLOCKB(CLK3),
			.READENABLEB(1'b0),
			.WRITEENABLEB(1'b1),
			.BYTEENABLEB(B1EN)
			//.WRITEDATAWIDTHB(WRITEDATAWIDTHB),
			//.READDATAWIDTHB(3'b0)
		);
	end endgenerate
endmodule
