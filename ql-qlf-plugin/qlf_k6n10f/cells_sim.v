// Copyright (C) 2020-2021  The SymbiFlow Authors.
//
// Use of this source code is governed by a ISC-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/ISC
//
// SPDX-License-Identifier:ISC

(* abc9_flop, lib_whitebox *)
module sh_dff(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input C
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge C)
            Q <= D;
endmodule

(* abc9_box, lib_blackbox *)
module adder_carry(
    output sumout,
    output cout,
    input p,
    input g,
    input cin
);
    assign sumout = p ^ cin;
    assign cout = p ? cin : g;

endmodule

(* abc9_box, lib_whitebox *)
module adder_lut5(
   output lut5_out,
   (* abc9_carry *)
   output cout,
   input [0:4] in,
   (* abc9_carry *)
   input cin
);
    parameter [0:15] LUT=0;
    parameter IN2_IS_CIN = 0;

    wire [0:4] li = (IN2_IS_CIN) ? {in[0], in[1], cin, in[3], in[4]} : {in[0], in[1], in[2], in[3],in[4]};

    // Output function
    wire [0:15] s1 = li[0] ?
        {LUT[0], LUT[2], LUT[4], LUT[6], LUT[8], LUT[10], LUT[12], LUT[14], LUT[16], LUT[18], LUT[20], LUT[22], LUT[24], LUT[26], LUT[28], LUT[30]}:
        {LUT[1], LUT[3], LUT[5], LUT[7], LUT[9], LUT[11], LUT[13], LUT[15], LUT[17], LUT[19], LUT[21], LUT[23], LUT[25], LUT[27], LUT[29], LUT[31]};

    wire [0:7] s2 = li[1] ? {s1[0], s1[2], s1[4], s1[6], s1[8], s1[10], s1[12], s1[14]} :
                            {s1[1], s1[3], s1[5], s1[7], s1[9], s1[11], s1[13], s1[15]};

    wire [0:3] s3 = li[2] ? {s2[0], s2[2], s2[4], s2[6]} : {s2[1], s2[3], s2[5], s2[7]};
    wire [0:1] s4 = li[3] ? {s3[0], s3[2]} : {s3[1], s3[3]};

    assign lut5_out = li[4] ? s4[0] : s4[1];

    // Carry out function
    assign cout = (s3[2]) ? cin : s3[3];

endmodule



(* abc9_lut=1, lib_whitebox *)
module frac_lut6(
    input [0:5] in,
    output [0:3] lut4_out,
    output [0:1] lut5_out,
    output lut6_out
);
    parameter [0:63] LUT = 0;
    // Effective LUT input
    wire [0:5] li = in;

    // Output function
    wire [0:31] s1 = li[0] ?
    {LUT[0] , LUT[2] , LUT[4] , LUT[6] , LUT[8] , LUT[10], LUT[12], LUT[14], 
     LUT[16], LUT[18], LUT[20], LUT[22], LUT[24], LUT[26], LUT[28], LUT[30],
     LUT[32], LUT[34], LUT[36], LUT[38], LUT[40], LUT[42], LUT[44], LUT[46],
     LUT[48], LUT[50], LUT[52], LUT[54], LUT[56], LUT[58], LUT[60], LUT[62]}:
    {LUT[1] , LUT[3] , LUT[5] , LUT[7] , LUT[9] , LUT[11], LUT[13], LUT[15], 
     LUT[17], LUT[19], LUT[21], LUT[23], LUT[25], LUT[27], LUT[29], LUT[31],
     LUT[33], LUT[35], LUT[37], LUT[39], LUT[41], LUT[43], LUT[45], LUT[47],
     LUT[49], LUT[51], LUT[53], LUT[55], LUT[57], LUT[59], LUT[61], LUT[63]};

    wire [0:15] s2 = li[1] ?
    {s1[0] , s1[2] , s1[4] , s1[6] , s1[8] , s1[10], s1[12], s1[14],
     s1[16], s1[18], s1[20], s1[22], s1[24], s1[26], s1[28], s1[30]}:
    {s1[1] , s1[3] , s1[5] , s1[7] , s1[9] , s1[11], s1[13], s1[15],
     s1[17], s1[19], s1[21], s1[23], s1[25], s1[27], s1[29], s1[31]};

    wire [0:7] s3 = li[2] ?
    {s2[0], s2[2], s2[4], s2[6], s2[8], s2[10], s2[12], s2[14]}:
    {s2[1], s2[3], s2[5], s2[7], s2[9], s2[11], s2[13], s2[15]};

    wire [0:3] s4 = li[3] ? {s3[0], s3[2], s3[4], s3[6]}:
                            {s3[1], s3[3], s3[5], s3[7]};

    wire [0:1] s5 = li[4] ? {s4[0], s4[2]} : {s4[1], s4[3]};

    assign lut4_out[0] = s4[0];
    assign lut4_out[1] = s4[1];
    assign lut4_out[2] = s4[2];
    assign lut4_out[3] = s4[3];

    assign lut5_out[0] = s0[0];
    assign lut5_out[1] = s5[1];

    assign lut6_out = li[5] ? s5[0] : s5[1];

endmodule

(* abc9_flop, lib_whitebox *)
module dff(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C)
                Q <= D;
          1'b1:
            always @(negedge C)
                Q <= D;
    endcase
endmodule

(* abc9_flop, lib_whitebox *)
module dffr(
    output reg Q,
    input D,
    input R,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C or posedge R)
                if (R)
                        Q <= 1'b0;
                else
                        Q <= D;
          1'b1:
            always @(negedge C or posedge R)
                if (R)
                        Q <= 1'b0;
                else
                        Q <= D;
    endcase
endmodule

(* abc9_flop, lib_whitebox *)
module dffre(
    output reg Q,
    input D,
    input R,
    input E,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C or posedge R)
              if (R)
                Q <= 1'b0;
              else if(E)
                Q <= D;
          1'b1:
            always @(negedge C or posedge R)
              if (R)
                Q <= 1'b0;
              else if(E)
                Q <= D;
        endcase
endmodule

module dffs(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C,
    input S
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C or negedge S)
              if (S)
                Q <= 1'b1;
              else
                Q <= D;
          1'b1:
            always @(negedge C or negedge S)
              if (S)
                Q <= 1'b1;
              else
                Q <= D;
        endcase
endmodule

module dffse(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C,
    input S,
    input E,
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C or negedge S)
              if (S)
                Q <= 1'b1;
              else if(E)
                Q <= D;
          1'b1:
            always @(negedge C or negedge S)
              if (S)
                Q <= 1'b1;
              else if(E)
                Q <= D;
        endcase
endmodule

module dffsr(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_C_INVERTED" *)
    input C,
    input R,
    input S
);
    parameter [0:0] INIT = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    initial Q = INIT;
    case(|IS_C_INVERTED)
          1'b0:
            always @(posedge C or negedge S or negedge R)
              if (S)
                Q <= 1'b1;
              else if (R)
                Q <= 1'b0;
              else
                Q <= D;
          1'b1:
            always @(negedge C or negedge S or negedge R)
              if (S)
                Q <= 1'b1;
              else if (R)
                Q <= 1'b0;
              else
                Q <= D;
        endcase
endmodule

module dffsre(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input C,
    input E,
    input R,
    input S
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

        always @(posedge C or negedge S or negedge R)
          if (!R)
            Q <= 1'b0;
          else if (!S)
            Q <= 1'b1;
          else if (E)
            Q <= D;
        
endmodule

module dffnsre(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input C,
    input E,
    input R,
    input S
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

        always @(negedge C or negedge S or negedge R)
          if (!R)
            Q <= 1'b0;
          else if (!S)
            Q <= 1'b1;
          else if (E)
            Q <= D;
        
endmodule

(* abc9_flop, lib_whitebox *)
module latchsre (
    output reg Q,
    input S,
    input R,
    input D,
    input G,
    input E
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
    always @*
      begin
        if (!R) 
          Q <= 1'b0;
        else if (!S) 
          Q <= 1'b1;
        else if (E && G) 
          Q <= D;
      end
endmodule

(* abc9_flop, lib_whitebox *)
module latchnsre (
    output reg Q,
    input S,
    input R,
    input D,
    input G,
    input E
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
    always @*
      begin
        if (!R) 
          Q <= 1'b0;
        else if (!S) 
          Q <= 1'b1;
        else if (E && !G) 
          Q <= D;
      end
endmodule

(* abc9_flop, lib_whitebox *)
module scff(
    output reg Q,
    input D,
    input clk
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge clk)
            Q <= D;
endmodule

module TDP_BRAM18 (
    (* clkbuf_sink *)
    input CLOCKA,
    (* clkbuf_sink *)
    input CLOCKB,
    input READENABLEA,
    input READENABLEB,
    input [13:0] ADDRA,
    input [13:0] ADDRB,
    input [15:0] WRITEDATAA,
    input [15:0] WRITEDATAB,
    input [1:0] WRITEDATAAP,
    input [1:0] WRITEDATABP,
    input WRITEENABLEA,
    input WRITEENABLEB,
    input [1:0] BYTEENABLEA,
    input [1:0] BYTEENABLEB,
    //input [2:0] WRITEDATAWIDTHA,
    //input [2:0] WRITEDATAWIDTHB,
    //input [2:0] READDATAWIDTHA,
    //input [2:0] READDATAWIDTHB,
    output [15:0] READDATAA,
    output [15:0] READDATAB,
    output [1:0] READDATAAP,
    output [1:0] READDATABP
);
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter integer READ_WIDTH_A = 0;
    parameter integer READ_WIDTH_B = 0;
    parameter integer WRITE_WIDTH_A = 0;
    parameter integer WRITE_WIDTH_B = 0;

endmodule

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
	(* clkbuf_sink *)
	input wire CLK_A1;
	(* clkbuf_sink *)
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
	(* clkbuf_sink *)
	input wire CLK_A2;
	(* clkbuf_sink *)
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

(* blackbox *)
module QL_DSP1 (
    input  [19:0] a,
    input  [17:0] b,
    (* clkbuf_sink *)
    input  clk0,
    (* clkbuf_sink *)
    input  clk1,
    input  [ 1:0] feedback0,
    input  [ 1:0] feedback1,
    input  load_acc0,
    input  load_acc1,
    input  reset0,
    input  reset1,
    output reg [37:0] z
);
    parameter MODE_BITS = 27'b00000000000000000000000000;
endmodule  /* QL_DSP1 */

(* blackbox *)
module QL_DSP2 ( // TODO: Name subject to change
    input  [19:0] a,
    input  [17:0] b,
    input  [ 3:0] acc_fir,
    output [37:0] z,
    output [17:0] dly_b,

    (* clkbuf_sink *)
    input         clk,
    input         reset,

    input  [1:0]  feedback,
    input         load_acc,
    input         unsigned_a,
    input         unsigned_b,

    input         f_mode,
    input  [2:0]  output_select,
    input         saturate_enable,
    input  [5:0]  shift_right,
    input         round,
    input         subtract,
    input         register_inputs,
    input  [19:0] coeff_0,
    input  [19:0] coeff_1,
    input  [19:0] coeff_2,
    input  [19:0] coeff_3
);

endmodule

(* blackbox *) // TODO: add sim model
module dsp_t1_20x18x64 (
    input  [19:0] a_i,
    input  [17:0] b_i,
    input  [ 3:0] acc_fir_i,
    output [37:0] z_o,
    output [17:0] dly_b_o,

    (* clkbuf_sink *)
    input         clock_i,
    input         reset_i,

    input  [1:0]  feedback_i,
    input         load_acc_i,
    input         unsigned_a_i,
    input         unsigned_b_i,

    input  [2:0]  output_select_i,
    input         saturate_enable_i,
    input  [5:0]  shift_right_i,
    input         round_i,
    input         subtract_i,
    input         register_inputs_i,
    input  [19:0] coeff_0_i,
    input  [19:0] coeff_1_i,
    input  [19:0] coeff_2_i,
    input  [19:0] coeff_3_i
);
endmodule

(* blackbox *) // TODO: add sim model
module dsp_t1_10x9x32 (
    input  [ 9:0] a_i,
    input  [ 8:0] b_i,
    input  [ 3:0] acc_fir_i,
    output [18:0] z_o,
    output [ 8:0] dly_b_o,

    (* clkbuf_sink *)
    input         clock_i,
    input         reset_i,

    input  [1:0]  feedback_i,
    input         load_acc_i,
    input         unsigned_a_i,
    input         unsigned_b_i,

    input  [2:0]  output_select_i,
    input         saturate_enable_i,
    input  [5:0]  shift_right_i,
    input         round_i,
    input         subtract_i,
    input         register_inputs_i,
    input  [ 9:0] coeff_0_i,
    input  [ 9:0] coeff_1_i,
    input  [ 9:0] coeff_2_i,
    input  [ 9:0] coeff_3_i
);
endmodule
