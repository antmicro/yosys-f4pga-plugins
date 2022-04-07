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

    assign lut5_out[0] = s5[0];
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
    input E
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

`default_nettype wire
module TDP36K (
	RESET_ni,
	SCAN_RESET_i,
	SCAN_CLK_i,
	SCAN_MODE_i,
	SCAN_EN_i,
	SCAN_i,
	SCAN_o,
	WEN_A1_i,
	WEN_B1_i,
	REN_A1_i,
	REN_B1_i,
	CLK_A1_i,
	CLK_B1_i,
	BE_A1_i,
	BE_B1_i,
	ADDR_A1_i,
	ADDR_B1_i,
	WDATA_A1_i,
	WDATA_B1_i,
	RDATA_A1_o,
	RDATA_B1_o,
	FLUSH1_i,
	SYNC_FIFO1_i,
	RMODE_A1_i,
	RMODE_B1_i,
	WMODE_A1_i,
	WMODE_B1_i,
	FMODE1_i,
	POWERDN1_i,
	SLEEP1_i,
	PROTECT1_i,
	UPAE1_i,
	UPAF1_i,
	WEN_A2_i,
	WEN_B2_i,
	REN_A2_i,
	REN_B2_i,
	CLK_A2_i,
	CLK_B2_i,
	BE_A2_i,
	BE_B2_i,
	ADDR_A2_i,
	ADDR_B2_i,
	WDATA_A2_i,
	WDATA_B2_i,
	RDATA_A2_o,
	RDATA_B2_o,
	FLUSH2_i,
	SYNC_FIFO2_i,
	RMODE_A2_i,
	RMODE_B2_i,
	WMODE_A2_i,
	WMODE_B2_i,
	FMODE2_i,
	POWERDN2_i,
	SLEEP2_i,
	PROTECT2_i,
	UPAE2_i,
	UPAF2_i,
	SPLIT_i,
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
	input RESET_ni;
	input SCAN_RESET_i;
	input SCAN_CLK_i;
	input SCAN_MODE_i;
	input SCAN_EN_i;
	input [5:0] SCAN_i;
	output wire [5:0] SCAN_o;
	input wire WEN_A1_i;
	input wire WEN_B1_i;
	input wire REN_A1_i;
	input wire REN_B1_i;
	(* clkbuf_sink *)
	input wire CLK_A1_i;
	(* clkbuf_sink *)
	input wire CLK_B1_i;
	input wire [1:0] BE_A1_i;
	input wire [1:0] BE_B1_i;
	input wire [14:0] ADDR_A1_i;
	input wire [14:0] ADDR_B1_i;
	input wire [17:0] WDATA_A1_i;
	input wire [17:0] WDATA_B1_i;
	output reg [17:0] RDATA_A1_o;
	output reg [17:0] RDATA_B1_o;
	input wire FLUSH1_i;
	input wire SYNC_FIFO1_i;
	input wire [2:0] RMODE_A1_i;
	input wire [2:0] RMODE_B1_i;
	input wire [2:0] WMODE_A1_i;
	input wire [2:0] WMODE_B1_i;
	input wire FMODE1_i;
	input wire POWERDN1_i;
	input wire SLEEP1_i;
	input wire PROTECT1_i;
	input wire [11:0] UPAE1_i;
	input wire [11:0] UPAF1_i;
	input wire WEN_A2_i;
	input wire WEN_B2_i;
	input wire REN_A2_i;
	input wire REN_B2_i;
	(* clkbuf_sink *)
	input wire CLK_A2_i;
	(* clkbuf_sink *)
	input wire CLK_B2_i;
	input wire [1:0] BE_A2_i;
	input wire [1:0] BE_B2_i;
	input wire [13:0] ADDR_A2_i;
	input wire [13:0] ADDR_B2_i;
	input wire [17:0] WDATA_A2_i;
	input wire [17:0] WDATA_B2_i;
	output reg [17:0] RDATA_A2_o;
	output reg [17:0] RDATA_B2_o;
	input wire FLUSH2_i;
	input wire SYNC_FIFO2_i;
	input wire [2:0] RMODE_A2_i;
	input wire [2:0] RMODE_B2_i;
	input wire [2:0] WMODE_A2_i;
	input wire [2:0] WMODE_B2_i;
	input wire FMODE2_i;
	input wire POWERDN2_i;
	input wire SLEEP2_i;
	input wire PROTECT2_i;
	input wire [10:0] UPAE2_i;
	input wire [10:0] UPAF2_i;
	input SPLIT_i;
	input [19:0] RAM_ID_i;
	input wire PL_INIT_i;
	input wire PL_ENA_i;
	input wire PL_REN_i;
	input wire PL_CLK_i;
	input wire [1:0] PL_WEN_i;
	input wire [31:0] PL_ADDR_i;
	input wire [35:0] PL_DATA_i;
	output reg PL_INIT_o;
	output reg PL_ENA_o;
	output reg PL_REN_o;
	output reg PL_CLK_o;
	output reg [1:0] PL_WEN_o;
	output reg [31:0] PL_ADDR_o;
	output reg [35:0] PL_DATA_o;
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
	wire [17:0] pl_dout0;
	wire [17:0] pl_dout1;
	wire sclk_a1;
	wire sclk_b1;
	wire sclk_a2;
	wire sclk_b2;
	wire sreset;
	wire flush1;
	wire flush2;
	wire preload1;
	wire preload2;
	wire my_id;
	assign sreset = (SCAN_MODE_i ? ~SCAN_RESET_i : RESET_ni);
	assign flush1 = ~(SCAN_MODE_i ? SCAN_RESET_i : FLUSH1_i);
	assign flush2 = ~(SCAN_MODE_i ? SCAN_RESET_i : FLUSH2_i);
	assign ram_fmode1 = FMODE1_i & SPLIT_i;
	assign ram_fmode2 = FMODE2_i & SPLIT_i;
	assign my_id = (PL_ADDR_i[31:12] == RAM_ID_i) | PL_INIT_i;
	assign preload1 = (PROTECT1_i ? 1'b0 : my_id & PL_ENA_i);
	assign preload2 = (PROTECT2_i ? 1'b0 : my_id & PL_ENA_i);
	assign smux_clk_a1 = (preload1 ? PL_CLK_i : CLK_A1_i);
	assign smux_clk_b1 = (FMODE1_i ? (SYNC_FIFO1_i ? CLK_A1_i : CLK_B1_i) : CLK_B1_i);
	assign smux_clk_a2 = (preload2 ? PL_CLK_i : (SPLIT_i ? CLK_A2_i : CLK_A1_i));
	assign smux_clk_b2 = (SPLIT_i ? (FMODE2_i ? (SYNC_FIFO2_i ? CLK_A2_i : CLK_B2_i) : CLK_B2_i) : (FMODE1_i ? (SYNC_FIFO1_i ? CLK_A1_i : CLK_B1_i) : CLK_B1_i));
	assign sclk_a1 = (SCAN_MODE_i ? SCAN_CLK_i : smux_clk_a1);
	assign sclk_a2 = (SCAN_MODE_i ? SCAN_CLK_i : smux_clk_a2);
	assign sclk_b1 = (SCAN_MODE_i ? SCAN_CLK_i : smux_clk_b1);
	assign sclk_b2 = (SCAN_MODE_i ? SCAN_CLK_i : smux_clk_b2);
	assign ram_ren_a1 = (SPLIT_i ? REN_A1_i : (FMODE1_i ? 0 : REN_A1_i));
	assign ram_ren_a2 = (SPLIT_i ? REN_A2_i : (FMODE1_i ? 0 : REN_A1_i));
	assign ram_ren_b1 = (SPLIT_i ? REN_B1_i : (FMODE1_i ? ren_o : REN_B1_i));
	assign ram_ren_b2 = (SPLIT_i ? REN_B2_i : (FMODE1_i ? ren_o : REN_B1_i));
	localparam MODE_36 = 3'b011;
	assign ram_wen_a1 = (SPLIT_i ? WEN_A1_i : (FMODE1_i ? ~FULL3 & WEN_A1_i : (WMODE_A1_i == MODE_36 ? WEN_A1_i : WEN_A1_i & ~ADDR_A1_i[4])));
	assign ram_wen_a2 = (SPLIT_i ? WEN_A2_i : (FMODE1_i ? ~FULL3 & WEN_A1_i : (WMODE_A1_i == MODE_36 ? WEN_A1_i : WEN_A1_i & ADDR_A1_i[4])));
	assign ram_wen_b1 = (SPLIT_i ? WEN_B1_i : (WMODE_B1_i == MODE_36 ? WEN_B1_i : WEN_B1_i & ~ADDR_B1_i[4]));
	assign ram_wen_b2 = (SPLIT_i ? WEN_B2_i : (WMODE_B1_i == MODE_36 ? WEN_B1_i : WEN_B1_i & ADDR_B1_i[4]));
	assign ram_addr_a1 = (SPLIT_i ? ADDR_A1_i[13:0] : (FMODE1_i ? {ff_waddr[11:2], ff_waddr[0], 3'b000} : {ADDR_A1_i[14:5], ADDR_A1_i[3:0]}));
	assign ram_addr_b1 = (SPLIT_i ? ADDR_B1_i[13:0] : (FMODE1_i ? {ff_raddr[11:2], ff_raddr[0], 3'b000} : {ADDR_B1_i[14:5], ADDR_B1_i[3:0]}));
	assign ram_addr_a2 = (SPLIT_i ? ADDR_A2_i[13:0] : (FMODE1_i ? {ff_waddr[11:2], ff_waddr[0], 3'b000} : {ADDR_A1_i[14:5], ADDR_A1_i[3:0]}));
	assign ram_addr_b2 = (SPLIT_i ? ADDR_B2_i[13:0] : (FMODE1_i ? {ff_raddr[11:2], ff_raddr[0], 3'b000} : {ADDR_B1_i[14:5], ADDR_B1_i[3:0]}));
	assign bwl = (SPLIT_i ? ADDR_A1_i[4:3] : (FMODE1_i ? ff_waddr[1:0] : ADDR_A1_i[4:3]));
	localparam MODE_18 = 3'b010;
	localparam MODE_9 = 3'b001;
	always @(*) begin : WDATA_SEL
		case (SPLIT_i)
			1: begin
				ram_wdata_a1 = WDATA_A1_i;
				ram_wdata_a2 = WDATA_A2_i;
				ram_wdata_b1 = WDATA_B1_i;
				ram_wdata_b2 = WDATA_B2_i;
				ram_be_a2 = BE_A2_i;
				ram_be_b2 = BE_B2_i;
				ram_be_a1 = BE_A1_i;
				ram_be_b1 = BE_B1_i;
			end
			0: begin
				case (WMODE_A1_i)
					MODE_36: begin
						ram_wdata_a1 = WDATA_A1_i;
						ram_wdata_a2 = WDATA_A2_i;
						ram_be_a2 = (FMODE1_i ? 2'b11 : BE_A2_i);
						ram_be_a1 = (FMODE1_i ? 2'b11 : BE_A1_i);
					end
					MODE_18: begin
						ram_wdata_a1 = WDATA_A1_i;
						ram_wdata_a2 = WDATA_A1_i;
						ram_be_a1 = (FMODE1_i ? (ff_waddr[1] ? 2'b00 : 2'b11) : BE_A1_i);
						ram_be_a2 = (FMODE1_i ? (ff_waddr[1] ? 2'b11 : 2'b00) : BE_A1_i);
					end
					MODE_9: begin
						ram_wdata_a1[7:0] = WDATA_A1_i[7:0];
						ram_wdata_a1[16] = WDATA_A1_i[16];
						ram_wdata_a1[15:8] = WDATA_A1_i[7:0];
						ram_wdata_a1[17] = WDATA_A1_i[16];
						ram_wdata_a2[7:0] = WDATA_A1_i[7:0];
						ram_wdata_a2[16] = WDATA_A1_i[16];
						ram_wdata_a2[15:8] = WDATA_A1_i[7:0];
						ram_wdata_a2[17] = WDATA_A1_i[16];
						case (bwl)
							0: {ram_be_a2, ram_be_a1} = 4'b0001;
							1: {ram_be_a2, ram_be_a1} = 4'b0010;
							2: {ram_be_a2, ram_be_a1} = 4'b0100;
							3: {ram_be_a2, ram_be_a1} = 4'b1000;
						endcase
					end
					default: begin
						ram_wdata_a1 = WDATA_A1_i;
						ram_wdata_a2 = WDATA_A1_i;
						ram_be_a2 = (FMODE1_i ? 2'b11 : BE_A1_i);
						ram_be_a1 = (FMODE1_i ? 2'b11 : BE_A1_i);
					end
				endcase
				case (WMODE_B1_i)
					MODE_36: begin
						ram_wdata_b1 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B1_i);
						ram_wdata_b2 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B2_i);
						ram_be_b2 = BE_B2_i;
						ram_be_b1 = BE_B1_i;
					end
					MODE_18: begin
						ram_wdata_b1 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B1_i);
						ram_wdata_b2 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B1_i);
						ram_be_b1 = BE_B1_i;
						ram_be_b2 = BE_B1_i;
					end
					MODE_9: begin
						ram_wdata_b1[7:0] = WDATA_B1_i[7:0];
						ram_wdata_b1[16] = WDATA_B1_i[16];
						ram_wdata_b1[15:8] = WDATA_B1_i[7:0];
						ram_wdata_b1[17] = WDATA_B1_i[16];
						ram_wdata_b2[7:0] = WDATA_B1_i[7:0];
						ram_wdata_b2[16] = WDATA_B1_i[16];
						ram_wdata_b2[15:8] = WDATA_B1_i[7:0];
						ram_wdata_b2[17] = WDATA_B1_i[16];
						case (ADDR_B1_i[4:3])
							0: {ram_be_b2, ram_be_b1} = 4'b0001;
							1: {ram_be_b2, ram_be_b1} = 4'b0010;
							2: {ram_be_b2, ram_be_b1} = 4'b0100;
							3: {ram_be_b2, ram_be_b1} = 4'b1000;
						endcase
					end
					default: begin
						ram_wdata_b1 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B1_i);
						ram_wdata_b2 = (FMODE1_i ? 18'b000000000000000000 : WDATA_B1_i);
						ram_be_b2 = BE_B1_i;
						ram_be_b1 = BE_B1_i;
					end
				endcase
			end
		endcase
	end
	always @(*)
		case (SPLIT_i)
			0: begin
				ram_rmode_a1 = (RMODE_A1_i == MODE_36 ? MODE_18 : RMODE_A1_i);
				ram_rmode_a2 = (RMODE_A1_i == MODE_36 ? MODE_18 : RMODE_A1_i);
				ram_wmode_a1 = (WMODE_A1_i == MODE_36 ? MODE_18 : (FMODE1_i ? MODE_18 : WMODE_A1_i));
				ram_wmode_a2 = (WMODE_A1_i == MODE_36 ? MODE_18 : (FMODE1_i ? MODE_18 : WMODE_A1_i));
				ram_rmode_b1 = (RMODE_B1_i == MODE_36 ? MODE_18 : (FMODE1_i ? MODE_18 : RMODE_B1_i));
				ram_rmode_b2 = (RMODE_B1_i == MODE_36 ? MODE_18 : (FMODE1_i ? MODE_18 : RMODE_B1_i));
				ram_wmode_b1 = (WMODE_B1_i == MODE_36 ? MODE_18 : WMODE_B1_i);
				ram_wmode_b2 = (WMODE_B1_i == MODE_36 ? MODE_18 : WMODE_B1_i);
			end
			1: begin
				ram_rmode_a1 = (RMODE_A1_i == MODE_36 ? MODE_18 : RMODE_A1_i);
				ram_rmode_a2 = (RMODE_A2_i == MODE_36 ? MODE_18 : RMODE_A2_i);
				ram_wmode_a1 = (WMODE_A1_i == MODE_36 ? MODE_18 : WMODE_A1_i);
				ram_wmode_a2 = (WMODE_A2_i == MODE_36 ? MODE_18 : WMODE_A2_i);
				ram_rmode_b1 = (RMODE_B1_i == MODE_36 ? MODE_18 : RMODE_B1_i);
				ram_rmode_b2 = (RMODE_B2_i == MODE_36 ? MODE_18 : RMODE_B2_i);
				ram_wmode_b1 = (WMODE_B1_i == MODE_36 ? MODE_18 : WMODE_B1_i);
				ram_wmode_b2 = (WMODE_B2_i == MODE_36 ? MODE_18 : WMODE_B2_i);
			end
		endcase
	always @(*) begin : FIFO_READ_SEL
		case (RMODE_B1_i)
			MODE_36: fifo_rdata = {ram_rdata_b2[17:16], ram_rdata_b1[17:16], ram_rdata_b2[15:0], ram_rdata_b1[15:0]};
			MODE_18: fifo_rdata = (ff_raddr[1] ? {18'b000000000000000000, ram_rdata_b2} : {18'b000000000000000000, ram_rdata_b1});
			MODE_9:
				case (ff_raddr[1:0])
					0: fifo_rdata = {19'b0000000000000000000, ram_rdata_b1[16], 8'b00000000, ram_rdata_b1[7:0]};
					1: fifo_rdata = {19'b0000000000000000000, ram_rdata_b1[17], 8'b00000000, ram_rdata_b1[15:8]};
					2: fifo_rdata = {19'b0000000000000000000, ram_rdata_b2[16], 8'b00000000, ram_rdata_b2[7:0]};
					3: fifo_rdata = {19'b0000000000000000000, ram_rdata_b2[17], 8'b00000000, ram_rdata_b2[15:8]};
				endcase
			default: fifo_rdata = {ram_rdata_b2, ram_rdata_b1};
		endcase
	end
	localparam MODE_1 = 3'b101;
	localparam MODE_2 = 3'b110;
	localparam MODE_4 = 3'b100;
	always @(*) begin : RDATA_SEL
		case (SPLIT_i)
			1: begin
				RDATA_A1_o = (FMODE1_i ? {10'b0000000000, EMPTY1, EPO1, EWM1, UNDERRUN1, FULL1, FMO1, FWM1, OVERRUN1} : ram_rdata_a1);
				RDATA_B1_o = ram_rdata_b1;
				RDATA_A2_o = (FMODE2_i ? {10'b0000000000, EMPTY2, EPO2, EWM2, UNDERRUN2, FULL2, FMO2, FWM2, OVERRUN2} : ram_rdata_a2);
				RDATA_B2_o = ram_rdata_b2;
			end
			0: begin
				if (FMODE1_i) begin
					RDATA_A1_o = {10'b0000000000, EMPTY3, EPO3, EWM3, UNDERRUN3, FULL3, FMO3, FWM3, OVERRUN3};
					RDATA_A2_o = 18'b000000000000000000;
				end
				else
					case (RMODE_A1_i)
						MODE_36: begin
							RDATA_A1_o = {ram_rdata_a1[17:0]};
							RDATA_A2_o = {ram_rdata_a2[17:0]};
						end
						MODE_18: begin
							RDATA_A1_o = (laddr_a1[4] ? ram_rdata_a2 : ram_rdata_a1);
							RDATA_A2_o = 18'b000000000000000000;
						end
						MODE_9: begin
							RDATA_A1_o = (laddr_a1[4] ? {{2 {ram_rdata_a2[16]}}, {2 {ram_rdata_a2[7:0]}}} : {{2 {ram_rdata_a1[16]}}, {2 {ram_rdata_a1[7:0]}}});
							RDATA_A2_o = 18'b000000000000000000;
						end
						MODE_4: begin
							RDATA_A2_o = 18'b000000000000000000;
							RDATA_A1_o[17:4] = 14'b00000000000000;
							RDATA_A1_o[3:0] = (laddr_a1[4] ? ram_rdata_a2[3:0] : ram_rdata_a1[3:0]);
						end
						MODE_2: begin
							RDATA_A2_o = 18'b000000000000000000;
							RDATA_A1_o[17:2] = 16'b0000000000000000;
							RDATA_A1_o[1:0] = (laddr_a1[4] ? ram_rdata_a2[1:0] : ram_rdata_a1[1:0]);
						end
						MODE_1: begin
							RDATA_A2_o = 18'b000000000000000000;
							RDATA_A1_o[17:1] = 17'b00000000000000000;
							RDATA_A1_o[0] = (laddr_a1[4] ? ram_rdata_a2[0] : ram_rdata_a1[0]);
						end
						default: begin
							RDATA_A1_o = {ram_rdata_a2[1:0], ram_rdata_a1[15:0]};
							RDATA_A2_o = {ram_rdata_a2[17:16], ram_rdata_a1[17:16], ram_rdata_a2[15:2]};
						end
					endcase
				case (RMODE_B1_i)
					MODE_36: begin
						RDATA_B1_o = {ram_rdata_b1};
						RDATA_B2_o = {ram_rdata_b2};
					end
					MODE_18: begin
						RDATA_B1_o = (FMODE1_i ? fifo_rdata[17:0] : (laddr_b1[4] ? ram_rdata_b2 : ram_rdata_b1));
						RDATA_B2_o = 18'b000000000000000000;
					end
					MODE_9: begin
						RDATA_B1_o = (FMODE1_i ? {fifo_rdata[17:0]} : (laddr_b1[4] ? {1'b0, ram_rdata_b2[16], 8'b00000000, ram_rdata_b2[7:0]} : {1'b0, ram_rdata_b1[16], 8'b00000000, ram_rdata_b1[7:0]}));
						RDATA_B2_o = 18'b000000000000000000;
					end
					MODE_4: begin
						RDATA_B2_o = 18'b000000000000000000;
						RDATA_B1_o[17:4] = 14'b00000000000000;
						RDATA_B1_o[3:0] = (laddr_b1[4] ? ram_rdata_b2[3:0] : ram_rdata_b1[3:0]);
					end
					MODE_2: begin
						RDATA_B2_o = 18'b000000000000000000;
						RDATA_B1_o[17:2] = 16'b0000000000000000;
						RDATA_B1_o[1:0] = (laddr_b1[4] ? ram_rdata_b2[1:0] : ram_rdata_b1[1:0]);
					end
					MODE_1: begin
						RDATA_B2_o = 18'b000000000000000000;
						RDATA_B1_o[17:1] = 17'b00000000000000000;
						RDATA_B1_o[0] = (laddr_b1[4] ? ram_rdata_b2[0] : ram_rdata_b1[0]);
					end
					default: begin
						RDATA_B1_o = ram_rdata_b1;
						RDATA_B2_o = ram_rdata_b2;
					end
				endcase
			end
		endcase
	end
	always @(posedge sclk_a1 or negedge sreset)
		if (sreset == 0)
			laddr_a1 <= 1'sb0;
		else
			laddr_a1 <= ADDR_A1_i;
	always @(posedge sclk_b1 or negedge sreset)
		if (sreset == 0)
			laddr_b1 <= 1'sb0;
		else
			laddr_b1 <= ADDR_B1_i;
	always @(*) begin
		case (WMODE_A1_i)
			default: fifo_wmode = 2'b00;
			MODE_36: fifo_wmode = 2'b00;
			MODE_18: fifo_wmode = 2'b01;
			MODE_9: fifo_wmode = 2'b10;
		endcase
		case (RMODE_B1_i)
			default: fifo_rmode = 2'b00;
			MODE_36: fifo_rmode = 2'b00;
			MODE_18: fifo_rmode = 2'b01;
			MODE_9: fifo_rmode = 2'b10;
		endcase
	end
	fifo_ctl #(
		.ADDR_WIDTH(12),
		.FIFO_WIDTH(3'd4),
		.DEPTH(7)
	) fifo36_ctl(
		.rclk(sclk_b1),
		.rst_R_n(flush1),
		.wclk(sclk_a1),
		.rst_W_n(flush1),
		.ren(REN_B1_i),
		.wen(ram_wen_a1),
		.sync(SYNC_FIFO1_i),
		.rmode(fifo_rmode),
		.wmode(fifo_wmode),
		.ren_o(ren_o),
		.fflags({FULL3, FMO3, FWM3, OVERRUN3, EMPTY3, EPO3, EWM3, UNDERRUN3}),
		.raddr(ff_raddr),
		.waddr(ff_waddr),
		.upaf(UPAF1_i),
		.upae(UPAE1_i)
	);
	TDP18K_FIFO u1(
		.RMODE_A_i(ram_rmode_a1),
		.RMODE_B_i(ram_rmode_b1),
		.WMODE_A_i(ram_wmode_a1),
		.WMODE_B_i(ram_wmode_b1),
		.WEN_A_i(ram_wen_a1),
		.WEN_B_i(ram_wen_b1),
		.REN_A_i(ram_ren_a1),
		.REN_B_i(ram_ren_b1),
		.CLK_A_i(sclk_a1),
		.CLK_B_i(sclk_b1),
		.BE_A_i(ram_be_a1),
		.BE_B_i(ram_be_b1),
		.ADDR_A_i(ram_addr_a1),
		.ADDR_B_i(ram_addr_b1),
		.WDATA_A_i(ram_wdata_a1),
		.WDATA_B_i(ram_wdata_b1),
		.RDATA_A_o(ram_rdata_a1),
		.RDATA_B_o(ram_rdata_b1),
		.EMPTY_o(EMPTY1),
		.EPO_o(EPO1),
		.EWM_o(EWM1),
		.UNDERRUN_o(UNDERRUN1),
		.FULL_o(FULL1),
		.FMO_o(FMO1),
		.FWM_o(FWM1),
		.OVERRUN_o(OVERRUN1),
		.FLUSH_ni(flush1),
		.FMODE_i(ram_fmode1),
		.UPAF_i(UPAF1_i[10:0]),
		.UPAE_i(UPAE1_i[10:0]),
		.SYNC_FIFO_i(SYNC_FIFO1_i),
		.POWERDN_i(POWERDN1_i),
		.SLEEP_i(SLEEP1_i),
		.PROTECT_i(PROTECT1_i),
		.PL_INIT_i(PL_INIT_i),
		.PL_ENA_i(PL_ENA_i),
		.PL_WEN_i(PL_WEN_i[0]),
		.PL_REN_i(PL_REN_i),
		.PL_CLK_i(PL_CLK_i),
		.PL_ADDR_i(PL_ADDR_i),
		.PL_DATA_IN_i({PL_DATA_i[33:32], PL_DATA_i[15:0]}),
		.PL_DATA_OUT_o(pl_dout0),
		.RAM_ID_i({RAM_ID_i})
	);
	TDP18K_FIFO u2(
		.RMODE_A_i(ram_rmode_a2),
		.RMODE_B_i(ram_rmode_b2),
		.WMODE_A_i(ram_wmode_a2),
		.WMODE_B_i(ram_wmode_b2),
		.WEN_A_i(ram_wen_a2),
		.WEN_B_i(ram_wen_b2),
		.REN_A_i(ram_ren_a2),
		.REN_B_i(ram_ren_b2),
		.CLK_A_i(sclk_a2),
		.CLK_B_i(sclk_b2),
		.BE_A_i(ram_be_a2),
		.BE_B_i(ram_be_b2),
		.ADDR_A_i(ram_addr_a2),
		.ADDR_B_i(ram_addr_b2),
		.WDATA_A_i(ram_wdata_a2),
		.WDATA_B_i(ram_wdata_b2),
		.RDATA_A_o(ram_rdata_a2),
		.RDATA_B_o(ram_rdata_b2),
		.EMPTY_o(EMPTY2),
		.EPO_o(EPO2),
		.EWM_o(EWM2),
		.UNDERRUN_o(UNDERRUN2),
		.FULL_o(FULL2),
		.FMO_o(FMO2),
		.FWM_o(FWM2),
		.OVERRUN_o(OVERRUN2),
		.FLUSH_ni(flush2),
		.FMODE_i(ram_fmode2),
		.UPAF_i(UPAF2_i),
		.UPAE_i(UPAE2_i),
		.SYNC_FIFO_i(SYNC_FIFO2_i),
		.POWERDN_i(POWERDN2_i),
		.SLEEP_i(SLEEP2_i),
		.PROTECT_i(PROTECT2_i),
		.PL_INIT_i(PL_INIT_i),
		.PL_ENA_i(PL_ENA_i),
		.PL_WEN_i(PL_WEN_i[1]),
		.PL_REN_i(PL_REN_i),
		.PL_CLK_i(PL_CLK_i),
		.PL_ADDR_i(PL_ADDR_i),
		.PL_DATA_IN_i({PL_DATA_i[35:34], PL_DATA_i[31:16]}),
		.PL_DATA_OUT_o(pl_dout1),
		.RAM_ID_i(RAM_ID_i)
	);
	always @(*) begin
		if (RAM_ID_i == PL_ADDR_i[31:12])
			PL_DATA_o = (PL_REN_i ? {pl_dout1[17:16], pl_dout0[17:16], pl_dout1[15:0], pl_dout0[15:0]} : PL_DATA_i);
		else
			PL_DATA_o = PL_DATA_i;
		PL_ADDR_o = PL_ADDR_i;
		PL_INIT_o = PL_INIT_i;
		PL_ENA_o = PL_ENA_i;
		PL_WEN_o = PL_WEN_i;
		PL_REN_o = PL_REN_i;
		PL_CLK_o = PL_CLK_i;
	end
endmodule
`default_nettype none

module BRAM2x18_TDP (A1ADDR, A1DATA, A1EN, B1ADDR, B1DATA, B1EN, C1ADDR, C1DATA, C1EN, CLK1, CLK2, CLK3, CLK4, D1ADDR, D1DATA, D1EN, E1ADDR, E1DATA, E1EN, F1ADDR, F1DATA, F1EN, G1ADDR, G1DATA, G1EN, H1ADDR, H1DATA, H1EN);
    parameter CFG_ABITS = 11;
    parameter CFG_DBITS = 18;
    parameter CFG_ENABLE_B = 4;
    parameter CFG_ENABLE_D = 4;
    parameter CFG_ENABLE_F = 4;
    parameter CFG_ENABLE_H = 4;

    parameter CLKPOL2 = 1;
    parameter CLKPOL3 = 1;
    parameter [18431:0] INIT0 = 18432'bx;
    parameter [18431:0] INIT1 = 18432'bx;

    localparam MODE_36 = 3'b011; // 36- or 32-bit
    localparam MODE_18 = 3'b010; // 18- or 16-bit
    localparam MODE_9 = 3'b001; // 9- or 8-bit
    localparam MODE_4 = 3'b100; // 4-bit
    localparam MODE_2 = 3'b110; // 2-bit
    localparam MODE_1 = 3'b101; // 1-bit

    input CLK1;
    input CLK2;
    input CLK3;
    input CLK4;

    input [CFG_ABITS-1:0] A1ADDR;
    output [CFG_DBITS-1:0] A1DATA;
    input A1EN;

    input [CFG_ABITS-1:0] B1ADDR;
    input [CFG_DBITS-1:0] B1DATA;
    input [CFG_ENABLE_B-1:0] B1EN;

    input [CFG_ABITS-1:0] C1ADDR;
    output [CFG_DBITS-1:0] C1DATA;
    input C1EN;

    input [CFG_ABITS-1:0] D1ADDR;
    input [CFG_DBITS-1:0] D1DATA;
    input [CFG_ENABLE_D-1:0] D1EN;

    input [CFG_ABITS-1:0] E1ADDR;
    output [CFG_DBITS-1:0] E1DATA;
    input E1EN;

    input [CFG_ABITS-1:0] F1ADDR;
    input [CFG_DBITS-1:0] F1DATA;
    input [CFG_ENABLE_F-1:0] F1EN;

    input [CFG_ABITS-1:0] G1ADDR;
    output [CFG_DBITS-1:0] G1DATA;
    input G1EN;

    input [CFG_ABITS-1:0] H1ADDR;
    input [CFG_DBITS-1:0] H1DATA;
    input [CFG_ENABLE_H-1:0] H1EN;

    wire FLUSH1;
    wire FLUSH2;
    wire SPLIT;
    wire [15:0] RAM_ID;

    wire PL_INIT_i;
    wire PL_ENA_i;
    wire PL_REN_i;
    wire PL_CLK_i;
    wire [1:0] PL_WEN_i;
    wire [23:0] PL_ADDR_i;
    wire [35:0] PL_DATA_i;
    wire PL_INIT_o;
    wire PL_ENA_o;
    wire PL_REN_o;
    wire PL_CLK_o;
    wire [1:0] PL_WEN_o;
    wire [23:0] PL_ADDR_o;
    wire [35:0] PL_DATA_o;

    wire [13:CFG_ABITS] A1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] B1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] C1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] D1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] E1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] F1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] G1ADDR_CMPL = {14-CFG_ABITS{1'b0}};
    wire [13:CFG_ABITS] H1ADDR_CMPL = {14-CFG_ABITS{1'b0}};

    wire [13:0] A1ADDR_TOTAL = {A1ADDR_CMPL, A1ADDR};
    wire [13:0] B1ADDR_TOTAL = {B1ADDR_CMPL, B1ADDR};
    wire [13:0] C1ADDR_TOTAL = {C1ADDR_CMPL, C1ADDR};
    wire [13:0] D1ADDR_TOTAL = {D1ADDR_CMPL, D1ADDR};
    wire [13:0] E1ADDR_TOTAL = {E1ADDR_CMPL, E1ADDR};
    wire [13:0] F1ADDR_TOTAL = {F1ADDR_CMPL, F1ADDR};
    wire [13:0] G1ADDR_TOTAL = {G1ADDR_CMPL, G1ADDR};
    wire [13:0] H1ADDR_TOTAL = {H1ADDR_CMPL, H1ADDR};

    wire [17:CFG_DBITS] A1_RDATA_CMPL;
    wire [17:CFG_DBITS] C1_RDATA_CMPL;
    wire [17:CFG_DBITS] E1_RDATA_CMPL;
    wire [17:CFG_DBITS] G1_RDATA_CMPL;

    wire [17:CFG_DBITS] B1_WDATA_CMPL;
    wire [17:CFG_DBITS] D1_WDATA_CMPL;
    wire [17:CFG_DBITS] F1_WDATA_CMPL;
    wire [17:CFG_DBITS] H1_WDATA_CMPL;

    wire [13:0] PORT_A1_ADDR;
    wire [13:0] PORT_A2_ADDR;
    wire [13:0] PORT_B1_ADDR;
    wire [13:0] PORT_B2_ADDR;

    case (CFG_DBITS)
        1: begin
            assign PORT_A1_ADDR = A1EN ? A1ADDR_TOTAL : (B1EN ? B1ADDR_TOTAL : 14'd0);
            assign PORT_B1_ADDR = C1EN ? C1ADDR_TOTAL : (D1EN ? D1ADDR_TOTAL : 14'd0);
            assign PORT_A2_ADDR = E1EN ? E1ADDR_TOTAL : (F1EN ? F1ADDR_TOTAL : 14'd0);
            assign PORT_B2_ADDR = G1EN ? G1ADDR_TOTAL : (H1EN ? H1ADDR_TOTAL : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_1;
            defparam bram_2x18k.WMODE_A2_i = MODE_1;
            defparam bram_2x18k.RMODE_A1_i = MODE_1;
            defparam bram_2x18k.RMODE_A2_i = MODE_1;
            defparam bram_2x18k.WMODE_B1_i = MODE_1;
            defparam bram_2x18k.WMODE_B2_i = MODE_1;
            defparam bram_2x18k.RMODE_B1_i = MODE_1;
            defparam bram_2x18k.RMODE_B2_i = MODE_1;
        end

        2: begin
            assign PORT_A1_ADDR = A1EN ? (A1ADDR_TOTAL << 1) : (B1EN ? (B1ADDR_TOTAL << 1) : 14'd0);
            assign PORT_B1_ADDR = C1EN ? (C1ADDR_TOTAL << 1) : (D1EN ? (D1ADDR_TOTAL << 1) : 14'd0);
            assign PORT_A2_ADDR = E1EN ? (E1ADDR_TOTAL << 1) : (F1EN ? (F1ADDR_TOTAL << 1) : 14'd0);
            assign PORT_B2_ADDR = G1EN ? (G1ADDR_TOTAL << 1) : (H1EN ? (H1ADDR_TOTAL << 1) : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_2;
            defparam bram_2x18k.WMODE_A2_i = MODE_2;
            defparam bram_2x18k.RMODE_A1_i = MODE_2;
            defparam bram_2x18k.RMODE_A2_i = MODE_2;
            defparam bram_2x18k.WMODE_B1_i = MODE_2;
            defparam bram_2x18k.WMODE_B2_i = MODE_2;
            defparam bram_2x18k.RMODE_B1_i = MODE_2;
            defparam bram_2x18k.RMODE_B2_i = MODE_2;
        end

        4: begin
            assign PORT_A1_ADDR = A1EN ? (A1ADDR_TOTAL << 2) : (B1EN ? (B1ADDR_TOTAL << 2) : 14'd0);
            assign PORT_B1_ADDR = C1EN ? (C1ADDR_TOTAL << 2) : (D1EN ? (D1ADDR_TOTAL << 2) : 14'd0);
            assign PORT_A2_ADDR = E1EN ? (E1ADDR_TOTAL << 2) : (F1EN ? (F1ADDR_TOTAL << 2) : 14'd0);
            assign PORT_B2_ADDR = G1EN ? (G1ADDR_TOTAL << 2) : (H1EN ? (H1ADDR_TOTAL << 2) : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_4;
            defparam bram_2x18k.WMODE_A2_i = MODE_4;
            defparam bram_2x18k.RMODE_A1_i = MODE_4;
            defparam bram_2x18k.RMODE_A2_i = MODE_4;
            defparam bram_2x18k.WMODE_B1_i = MODE_4;
            defparam bram_2x18k.WMODE_B2_i = MODE_4;
            defparam bram_2x18k.RMODE_B1_i = MODE_4;
            defparam bram_2x18k.RMODE_B2_i = MODE_4;
        end

        8, 9: begin
            assign PORT_A1_ADDR = A1EN ? (A1ADDR_TOTAL << 3) : (B1EN ? (B1ADDR_TOTAL << 3) : 14'd0);
            assign PORT_B1_ADDR = C1EN ? (C1ADDR_TOTAL << 3) : (D1EN ? (D1ADDR_TOTAL << 3) : 14'd0);
            assign PORT_A2_ADDR = E1EN ? (E1ADDR_TOTAL << 3) : (F1EN ? (F1ADDR_TOTAL << 3) : 14'd0);
            assign PORT_B2_ADDR = G1EN ? (G1ADDR_TOTAL << 3) : (H1EN ? (H1ADDR_TOTAL << 3) : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_9;
            defparam bram_2x18k.WMODE_A2_i = MODE_9;
            defparam bram_2x18k.RMODE_A1_i = MODE_9;
            defparam bram_2x18k.RMODE_A2_i = MODE_9;
            defparam bram_2x18k.WMODE_B1_i = MODE_9;
            defparam bram_2x18k.WMODE_B2_i = MODE_9;
            defparam bram_2x18k.RMODE_B1_i = MODE_9;
            defparam bram_2x18k.RMODE_B2_i = MODE_9;
        end

        16, 18: begin
            assign PORT_A1_ADDR = A1EN ? (A1ADDR_TOTAL << 4) : (B1EN ? (B1ADDR_TOTAL << 4) : 14'd0);
            assign PORT_B1_ADDR = C1EN ? (C1ADDR_TOTAL << 4) : (D1EN ? (D1ADDR_TOTAL << 4) : 14'd0);
            assign PORT_A2_ADDR = E1EN ? (E1ADDR_TOTAL << 4) : (F1EN ? (F1ADDR_TOTAL << 4) : 14'd0);
            assign PORT_B2_ADDR = G1EN ? (G1ADDR_TOTAL << 4) : (H1EN ? (H1ADDR_TOTAL << 4) : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_18;
            defparam bram_2x18k.WMODE_A2_i = MODE_18;
            defparam bram_2x18k.RMODE_A1_i = MODE_18;
            defparam bram_2x18k.RMODE_A2_i = MODE_18;
            defparam bram_2x18k.WMODE_B1_i = MODE_18;
            defparam bram_2x18k.WMODE_B2_i = MODE_18;
            defparam bram_2x18k.RMODE_B1_i = MODE_18;
            defparam bram_2x18k.RMODE_B2_i = MODE_18;
        end

        default: begin
            assign PORT_A1_ADDR = A1EN ? A1ADDR_TOTAL : (B1EN ? B1ADDR_TOTAL : 14'd0);
            assign PORT_B1_ADDR = C1EN ? C1ADDR_TOTAL : (D1EN ? D1ADDR_TOTAL : 14'd0);
            assign PORT_A2_ADDR = E1EN ? E1ADDR_TOTAL : (F1EN ? F1ADDR_TOTAL : 14'd0);
            assign PORT_B2_ADDR = G1EN ? G1ADDR_TOTAL : (H1EN ? H1ADDR_TOTAL : 14'd0);
            defparam bram_2x18k.WMODE_A1_i = MODE_36;
            defparam bram_2x18k.WMODE_A2_i = MODE_36;
            defparam bram_2x18k.RMODE_A1_i = MODE_36;
            defparam bram_2x18k.RMODE_A2_i = MODE_36;
            defparam bram_2x18k.WMODE_B1_i = MODE_36;
            defparam bram_2x18k.WMODE_B2_i = MODE_36;
            defparam bram_2x18k.RMODE_B1_i = MODE_36;
            defparam bram_2x18k.RMODE_B2_i = MODE_36;
        end
    endcase

    assign FLUSH1 = 1'b0;
    assign FLUSH2 = 1'b0;
    assign RAM_ID = 16'b0;

    wire [17:0] PORT_A1_RDATA = {A1_RDATA_CMPL, A1DATA};
    wire [17:0] PORT_B1_RDATA = {C1_RDATA_CMPL, C1DATA};
    wire [17:0] PORT_A2_RDATA = {E1_RDATA_CMPL, E1DATA};
    wire [17:0] PORT_B2_RDATA = {G1_RDATA_CMPL, G1DATA};

    wire [17:0] PORT_A1_WDATA = {B1_WDATA_CMPL, B1DATA};
    wire [17:0] PORT_B1_WDATA = {D1_WDATA_CMPL, D1DATA};
    wire [17:0] PORT_A2_WDATA = {F1_WDATA_CMPL, F1DATA};
    wire [17:0] PORT_B2_WDATA = {H1_WDATA_CMPL, H1DATA};

    wire PORT_A1_CLK = CLK1;
    wire PORT_A2_CLK = CLK3;
    wire PORT_B1_CLK = CLK2;
    wire PORT_B2_CLK = CLK4;

    wire PORT_A1_REN = A1EN;
    wire PORT_A1_WEN = B1EN[0];
    wire [CFG_ENABLE_B-1:0] PORT_A1_BE = {B1EN[1],B1EN[0]};

    wire PORT_A2_REN = E1EN;
    wire PORT_A2_WEN = F1EN[0];
    wire [CFG_ENABLE_F-1:0] PORT_A2_BE = {F1EN[1],F1EN[0]};

    wire PORT_B1_REN = C1EN;
    wire PORT_B1_WEN = D1EN[0];
    wire [CFG_ENABLE_D-1:0] PORT_B1_BE = {D1EN[1],D1EN[0]};

    wire PORT_B2_REN = G1EN;
    wire PORT_B2_WEN = H1EN[0];
    wire [CFG_ENABLE_H-1:0] PORT_B2_BE = {H1EN[1],H1EN[0]};

    assign PL_INIT_i = 1'b0;
    assign PL_ENA_i = 1'b0;
    assign PL_REN_i = 1'b0;
    assign PL_CLK_i = 1'b0;
    assign PL_WEN_i = 2'b0;
    assign PL_ADDR_i = 24'b0;
    assign PL_DATA_i = 36'b0;

    TDP36K #(
        .UPAE1_i(12'd10),
        .UPAF1_i(12'd10),
        .UPAE2_i(12'd10),
        .UPAF2_i(12'd10),
        .SYNC_FIFO1_i(1'b0),
        .SYNC_FIFO2_i(1'b0),
        .FMODE1_i(1'b0),
        .FMODE2_i(1'b0),
        .POWERDN1_i(1'b0),
        .POWERDN2_i(1'b0),
        .SLEEP1_i(1'b0),
        .SLEEP2_i(1'b0),
        .PROTECT1_i(1'b0),
        .PROTECT2_i(1'b0),
        .SPLIT_i(1'b1)
    ) bram_2x18k (
        .WDATA_A1_i(PORT_A1_WDATA),
        .RDATA_A1_o(PORT_A1_RDATA),
        .ADDR_A1_i(PORT_A1_ADDR),
        .CLK_A1_i(PORT_A1_CLK),
        .REN_A1_i(PORT_A1_REN),
        .WEN_A1_i(PORT_A1_WEN),
        .BE_A1_i(PORT_A1_BE),

        .WDATA_A2_i(PORT_A2_WDATA),
        .RDATA_A2_o(PORT_A2_RDATA),
        .ADDR_A2_i(PORT_A2_ADDR),
        .CLK_A2_i(PORT_A2_CLK),
        .REN_A2_i(PORT_A2_REN),
        .WEN_A2_i(PORT_A2_WEN),
        .BE_A2_i(PORT_A2_BE),

        .WDATA_B1_i(PORT_B1_WDATA),
        .RDATA_B1_o(PORT_B1_RDATA),
        .ADDR_B1_i(PORT_B1_ADDR),
        .CLK_B1_i(PORT_B1_CLK),
        .REN_B1_i(PORT_B1_REN),
        .WEN_B1_i(PORT_B1_WEN),
        .BE_B1_i(PORT_B1_BE),

        .WDATA_B2_i(PORT_B2_WDATA),
        .RDATA_B2_o(PORT_B2_RDATA),
        .ADDR_B2_i(PORT_B2_ADDR),
        .CLK_B2_i(PORT_B2_CLK),
        .REN_B2_i(PORT_B2_REN),
        .WEN_B2_i(PORT_B2_WEN),
        .BE_B2_i(PORT_B2_BE),

        .FLUSH1_i(FLUSH1),
        .FLUSH2_i(FLUSH2),
        .RAM_ID_i(RAM_ID),

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

module QL_DSP2 ( // TODO: Name subject to change
      input  [19:0] a,
      input  [17:0] b,
      input  [3:0] acc_fir,
      output [37:0] z,
      output [17:0] dly_b,

    (* clkbuf_sink *)
    input         clk,
    input         reset,

    input  [2:0]  feedback,
    input         load_acc,
    input         unsigned_a,
    input         unsigned_b,

    input         f_mode,
    input  [2:0]  output_select,
    input         saturate_enable,
    input  [5:0]  shift_right,
    input         round,
    input         subtract,
    input         register_inputs
);

    parameter [19:0] COEFF_0 = 20'd0;
    parameter [19:0] COEFF_1 = 20'd0;
    parameter [19:0] COEFF_2 = 20'd0;
    parameter [19:0] COEFF_3 = 20'd0;

      localparam NBITS_ACC = 64;
      localparam NBITS_A = 20;
      localparam NBITS_B = 18;
      localparam NBITS_Z = 38;
      localparam NBITS_COEF = 20;
      localparam NBITS_AF = 4;

      wire [NBITS_Z-1:0] dsp_full_z;
      wire [(NBITS_Z/2)-1:0] dsp_frac0_z;
      wire [(NBITS_Z/2)-1:0] dsp_frac1_z;

      wire [NBITS_B-1:0] dsp_full_dly_b;
      wire [(NBITS_B/2)-1:0] dsp_frac0_dly_b;
      wire [(NBITS_B/2)-1:0] dsp_frac1_dly_b;

      assign z = f_mode ? {dsp_frac1_z, dsp_frac0_z} : dsp_full_z;
      assign dly_b = f_mode ? {dsp_frac1_dly_b, dsp_frac0_dly_b} : dsp_full_dly_b;

    // Output used when fmode == 1
        dsp_t1_sim #(
        .NBITS_A(NBITS_A/2),
            .NBITS_B(NBITS_B/2),
            .NBITS_ACC(NBITS_ACC/2),
            .NBITS_Z(NBITS_Z/2),
            .NBITS_COEF(NBITS_COEF/2),
            .NBITS_AF(NBITS_AF/2)
        ) dsp_frac0 (
            .a_i(a[(NBITS_A/2)-1:0]),
            .b_i(b[(NBITS_B/2)-1:0]),
            .z_o(dsp_frac0_z),
            .dly_b_o(dsp_frac0_dly_b),

            .acc_fir_i(acc_fir[(NBITS_AF/2)-1:0]),
            .feedback_i(feedback),
            .load_acc_i(load_acc),

            .unsigned_a_i(unsigned_a),
            .unsigned_b_i(unsigned_b),

            .clock_i(clk),
            .reset_n_i(reset),

            .saturate_enable_i(saturate_enable),
            .output_select_i(output_select),
            .round_i(round),
            .shift_right_i(shift_right),
            .subtract_i(subtract),
            .register_inputs_i(register_inputs),
            .coef_0_i(COEFF_0[(NBITS_COEF/2)-1:0]),
            .coef_1_i(COEFF_1[(NBITS_COEF/2)-1:0]),
            .coef_2_i(COEFF_2[(NBITS_COEF/2)-1:0]),
            .coef_3_i(COEFF_3[(NBITS_COEF/2)-1:0])
        );

    // Output used when fmode == 1
        dsp_t1_sim #(
        .NBITS_A(NBITS_A/2),
            .NBITS_B(NBITS_B/2),
            .NBITS_ACC(NBITS_ACC/2),
            .NBITS_Z(NBITS_Z/2),
            .NBITS_COEF(NBITS_COEF/2),
            .NBITS_AF(NBITS_AF/2)
        ) dsp_frac1 (
            .a_i(a[NBITS_A-1:NBITS_A/2]),
            .b_i(b[NBITS_B-1:NBITS_B/2]),
            .z_o(dsp_frac1_z),
            .dly_b_o(dsp_frac1_dly_b),

            .acc_fir_i(acc_fir[NBITS_AF-1:NBITS_AF/2]),
            .feedback_i(feedback),
            .load_acc_i(load_acc),

            .unsigned_a_i(unsigned_a),
            .unsigned_b_i(unsigned_b),

            .clock_i(clk),
            .reset_n_i(reset),

            .saturate_enable_i(saturate_enable),
            .output_select_i(output_select),
            .round_i(round),
            .shift_right_i(shift_right),
            .subtract_i(subtract),
            .register_inputs_i(register_inputs),
            .coef_0_i(COEFF_0[NBITS_COEF-1:NBITS_COEF/2]),
            .coef_1_i(COEFF_1[NBITS_COEF-1:NBITS_COEF/2]),
            .coef_2_i(COEFF_2[NBITS_COEF-1:NBITS_COEF/2]),
            .coef_3_i(COEFF_3[NBITS_COEF-1:NBITS_COEF/2])
        );

    // Output used when fmode == 0
        dsp_t1_sim #(
             .NBITS_A(NBITS_A),
             .NBITS_B(NBITS_B),
             .NBITS_ACC(NBITS_ACC),
             .NBITS_Z(NBITS_Z),
             .NBITS_COEF(NBITS_COEF),
             .NBITS_AF(NBITS_AF)
        ) dsp_full (
            .a_i(a),
            .b_i(b),
            .z_o(dsp_full_z),
            .dly_b_o(dsp_full_dly_b),

            .acc_fir_i(acc_fir),
            .feedback_i(feedback),
            .load_acc_i(load_acc),

            .unsigned_a_i(unsigned_a),
            .unsigned_b_i(unsigned_b),

            .clock_i(clk),
            .reset_n_i(reset),

            .saturate_enable_i(saturate_enable),
            .output_select_i(output_select),
            .round_i(round),
            .shift_right_i(shift_right),
            .subtract_i(subtract),
            .register_inputs_i(register_inputs),
            .coef_0_i(COEFF_0),
            .coef_1_i(COEFF_1),
            .coef_2_i(COEFF_2),
            .coef_3_i(COEFF_3)
        );
endmodule

module dsp_t1_sim # (
    parameter NBITS_ACC  = 64,
    parameter NBITS_A    = 20,
    parameter NBITS_B    = 18,
    parameter NBITS_Z    = 38,
    parameter NBITS_COEF = 20,
    parameter NBITS_AF   = 4
)(
    input [NBITS_A-1:0] a_i,
    input [NBITS_B-1:0] b_i,
    output [NBITS_Z-1:0] z_o,
    output reg [NBITS_B-1:0] dly_b_o,

    input [NBITS_AF-1:0] acc_fir_i,
    input [2:0] feedback_i,
    input load_acc_i,

    input unsigned_a_i,
    input unsigned_b_i,

    input clock_i,
    input reset_n_i,

    input saturate_enable_i,
    input [2:0] output_select_i,
    input round_i,
    input [5:0] shift_right_i,
    input subtract_i,
    input register_inputs_i,
    input [NBITS_COEF-1:0] coef_0_i,
    input [NBITS_COEF-1:0] coef_1_i,
    input [NBITS_COEF-1:0] coef_2_i,
    input [NBITS_COEF-1:0] coef_3_i
);

// FIXME: The version of Icarus Verilog from Conda seems not to recognize the
// $error macro. Disable this sanity check for now because of that.
`ifndef __ICARUS__
    if (NBITS_ACC < NBITS_A + NBITS_B)
        $error("NBITS_ACC must be > NBITS_A + NBITS_B");
`endif

    // Input registers
    reg  [NBITS_A-1:0]  r_a;
    reg  [NBITS_B-1:0]  r_b;
    reg  [NBITS_AF-1:0] r_acc_fir;
    reg                 r_unsigned_a;
    reg                 r_unsigned_b;
    reg                 r_load_acc;
    reg  [2:0]          r_feedback;
    reg  [5:0]          r_shift_d1;
    reg  [5:0]          r_shift_d2;
    reg         r_subtract;
    reg         r_sat;
    reg         r_rnd;
    reg [NBITS_ACC-1:0] acc;

    initial begin
        r_a          <= 0;
        r_b          <= 0;

        r_acc_fir    <= 0;
        r_unsigned_a <= 0;
        r_unsigned_b <= 0;
        r_feedback   <= 0;
        r_shift_d1   <= 0;
        r_shift_d2   <= 0;
        r_subtract   <= 0;
        r_load_acc   <= 0;
        r_sat        <= 0;
        r_rnd        <= 0;
    end

    always @(posedge clock_i or negedge reset_n_i) begin
        if (~reset_n_i) begin

            r_a <= 'h0;
            r_b <= 'h0;

        r_acc_fir    <= 0;
            r_unsigned_a <= 0;
            r_unsigned_b <= 0;
            r_feedback   <= 0;
            r_shift_d1   <= 0;
            r_shift_d2   <= 0;
        r_subtract   <= 0;
            r_load_acc   <= 0;
            r_sat    <= 0;
            r_rnd    <= 0;

        end else begin

            r_a <= a_i;
            r_b <= b_i;

        r_acc_fir    <= acc_fir_i;
            r_unsigned_a <= unsigned_a_i;
            r_unsigned_b <= unsigned_b_i;
            r_feedback   <= feedback_i;
            r_shift_d1   <= shift_right_i;
            r_shift_d2   <= r_shift_d1;
        r_subtract   <= subtract_i;
            r_load_acc   <= load_acc_i;
            r_sat    <= r_sat;
            r_rnd    <= r_rnd;

        end
    end

    // Registered / non-registered input path select
    wire [NBITS_A-1:0]  a = register_inputs_i ? r_a : a_i;
    wire [NBITS_B-1:0]  b = register_inputs_i ? r_b : b_i;

    wire [NBITS_AF-1:0] acc_fir = register_inputs_i ? r_acc_fir : acc_fir_i;
    wire       unsigned_a = register_inputs_i ? r_unsigned_a : unsigned_a_i;
    wire       unsigned_b = register_inputs_i ? r_unsigned_b : unsigned_b_i;
    wire [2:0] feedback   = register_inputs_i ? r_feedback   : feedback_i;
    wire       load_acc   = register_inputs_i ? r_load_acc   : load_acc_i;
    wire       subtract   = register_inputs_i ? r_subtract   : subtract_i;
    wire       sat    = register_inputs_i ? r_sat : saturate_enable_i;
    wire       rnd    = register_inputs_i ? r_rnd : round_i;

    // Shift right control
    wire [5:0] shift_d1 = register_inputs_i ? r_shift_d1 : shift_right_i;
    wire [5:0] shift_d2 = output_select_i[1] ? shift_d1 : r_shift_d2;

    // Multiplier
    wire unsigned_mode = unsigned_a & unsigned_b;
    wire [NBITS_A-1:0] mult_a;
    assign mult_a = (feedback == 3'h0) ?   a :
                    (feedback == 3'h1) ?   a :
                    (feedback == 3'h2) ?   a :
                    (feedback == 3'h3) ?   acc[NBITS_A-1:0] :
                    (feedback == 3'h4) ?   coef_0_i :
                    (feedback == 3'h5) ?   coef_1_i :
                    (feedback == 3'h6) ?   coef_2_i :
                       coef_3_i;    // if feedback == 3'h7

    wire [NBITS_B-1:0] mult_b = (feedback == 2'h2) ? {NBITS_B{1'b0}}  : b;

    wire [NBITS_A-1:0] mult_sgn_a = mult_a[NBITS_A-1];
    wire [NBITS_A-1:0] mult_mag_a = (mult_sgn_a) ? (~mult_a + 1) : mult_a;
    wire [NBITS_B-1:0] mult_sgn_b = mult_b[NBITS_B-1];
    wire [NBITS_B-1:0] mult_mag_b = (mult_sgn_b) ? (~mult_b + 1) : mult_b;

    wire [NBITS_A+NBITS_B-1:0] mult_mag = mult_mag_a * mult_mag_b;
    wire mult_sgn = mult_sgn_a ^ mult_sgn_b;

    wire [NBITS_A+NBITS_B-1:0] mult = (unsigned_a && unsigned_b) ?
        (mult_a * mult_b) : (mult_sgn ? (~mult_mag + 1) : mult_mag);

    // Sign extension
    wire [NBITS_ACC-1:0] mult_xtnd = unsigned_mode ?
        {{(NBITS_ACC-NBITS_A-NBITS_B){1'b0}},                    mult[NBITS_A+NBITS_B-1:0]} :
        {{(NBITS_ACC-NBITS_A-NBITS_B){mult[NBITS_A+NBITS_B-1]}}, mult[NBITS_A+NBITS_B-1:0]};

    wire [NBITS_ACC-1:0] a_xtnd = (unsigned_a) ?
                  { {(NBITS_ACC - NBITS_A - NBITS_AF){1'b0}}, acc_fir, {a} } :
                  { {(NBITS_ACC - NBITS_A - NBITS_AF){acc_fir[NBITS_AF-1]}}, acc_fir, {a[NBITS_A-1:0]} };

    // Adder
    wire [NBITS_ACC-1:0] add_a = (subtract_i) ? (~mult_xtnd + 1) : mult_xtnd;
    wire [NBITS_ACC-1:0] add_b = (feedback_i == 3'h0) ? acc :
                                 (feedback_i == 3'h1) ? {{NBITS_ACC}{1'b0}} : a_xtnd;

    wire [NBITS_ACC-1:0] add_o = add_a + add_b;

    // Accumulator
    initial acc <= 0;

    always @(posedge clock_i or negedge reset_n_i)
        if (~reset_n_i) acc <= 'h0;
        else begin
            if (load_acc)
                acc <= add_o;
            else
                acc <= acc;
        end

    // Adder/accumulator output selection
    wire [NBITS_ACC-1:0] acc_out = (output_select_i[1]) ? add_o : acc;

    // Round, shift, saturate
    wire [NBITS_ACC-1:0] acc_rnd = (rnd && (shift_right_i != 0)) ? (acc_out + ({{(NBITS_ACC-1){1'b0}}, 1'b1} << (shift_right_i - 1))) :
                                                                    acc_out;

    wire [NBITS_ACC-1:0] acc_shr = (unsigned_mode) ? (acc_rnd  >> shift_right_i) :
                                                     (acc_rnd >>> shift_right_i);

    wire [NBITS_ACC-1:0] acc_sat_u = (acc_shr[NBITS_ACC-1:NBITS_Z] != 0) ? {{(NBITS_ACC-NBITS_Z){1'b0}},{NBITS_Z{1'b1}}} :
                                                                           {{(NBITS_ACC-NBITS_Z){1'b0}},{acc_shr[NBITS_Z-1:0]}};

    wire [NBITS_ACC-1:0] acc_sat_s = ((|acc_shr[NBITS_ACC-1:NBITS_Z-1] == 1'b0) ||
                                      (&acc_shr[NBITS_ACC-1:NBITS_Z-1] == 1'b1)) ? {{(NBITS_ACC-NBITS_Z){1'b0}},{acc_shr[NBITS_Z-1:0]}} :
                                                                                   {{(NBITS_ACC-NBITS_Z){1'b0}},{acc_shr[NBITS_ACC-1],{NBITS_Z-1{~acc_shr[NBITS_ACC-1]}}}};

    wire [NBITS_ACC-1:0] acc_sat = (sat) ? ((unsigned_mode) ? acc_sat_u : acc_sat_s) : acc_shr;

    // Output signals
    wire [NBITS_Z-1:0]  z0;
    reg  [NBITS_Z-1:0]  z1;
    wire [NBITS_Z-1:0]  z2;

    assign z0 = mult_xtnd[NBITS_Z-1:0];
    assign z2 = acc_sat[NBITS_Z-1:0];

    initial z1 <= 0;

    always @(posedge clock_i or negedge reset_n_i)
        if (!reset_n_i)
            z1 <= 0;
        else begin
            z1 <= (output_select_i == 3'b100) ? z0 : z2;
        end

    // Output mux
    assign z_o = (output_select_i == 3'h0) ?   z0 :
                 (output_select_i == 3'h1) ?   z2 :
                 (output_select_i == 3'h2) ?   z2 :
                 (output_select_i == 3'h3) ?   z2 :
                 (output_select_i == 3'h4) ?   z1 :
                 (output_select_i == 3'h5) ?   z1 :
                 (output_select_i == 3'h6) ?   z1 :
                           z1;  // if output_select_i == 3'h7

    // B input delayed passthrough
    initial dly_b_o <= 0;

    always @(posedge clock_i or negedge reset_n_i)
        if (!reset_n_i)
            dly_b_o <= 0;
        else
            dly_b_o <= b_i;

endmodule

module dsp_t1_20x18x64 (
    input  [19:0] a_i,
    input  [17:0] b_i,
    input  [ 3:0] acc_fir_i,
    output [37:0] z_o,
    output [17:0] dly_b_o,

    (* clkbuf_sink *)
    input         clock_i,
    input         reset_i,

    input  [2:0]  feedback_i,
    input         load_acc_i,
    input         unsigned_a_i,
    input         unsigned_b_i,

    input  [2:0]  output_select_i,
    input         saturate_enable_i,
    input  [5:0]  shift_right_i,
    input         round_i,
    input         subtract_i,
    input         register_inputs_i
);

    parameter [19:0] COEFF_0 = 20'd0;
    parameter [19:0] COEFF_1 = 20'd0;
    parameter [19:0] COEFF_2 = 20'd0;
    parameter [19:0] COEFF_3 = 20'd0;

   QL_DSP2 #(
        .COEFF_0(COEFF_0),
        .COEFF_1(COEFF_1),
        .COEFF_2(COEFF_2),
        .COEFF_3(COEFF_3)
   ) dsp (
    .a(a_i),
    .b(b_i),
    .z(z_o),
    .dly_b(dly_b_o),

    .f_mode(1'b0),  // 20x18x64 DSP

    .acc_fir(acc_fir_i),
    .feedback(feedback_i),
    .load_acc(load_acc_i),

    .unsigned_a(unsigned_a_i),
    .unsigned_b(unsigned_b_i),

    .clk(clock_i),
    .reset(reset_i),

    .saturate_enable(saturate_enable_i),
    .output_select(output_select_i),
    .round(round_i),
    .shift_right(shift_right_i),
    .subtract(subtract_i),
    .register_inputs(register_inputs_i)
    );
endmodule

module dsp_t1_10x9x32 (
    input  [ 9:0] a_i,
    input  [ 8:0] b_i,
    input  [ 1:0] acc_fir_i,
    output [18:0] z_o,
    output [ 8:0] dly_b_o,

    (* clkbuf_sink *)
    input         clock_i,
    input         reset_i,

    input  [2:0]  feedback_i,
    input         load_acc_i,
    input         unsigned_a_i,
    input         unsigned_b_i,

    input  [2:0]  output_select_i,
    input         saturate_enable_i,
    input  [5:0]  shift_right_i,
    input         round_i,
    input         subtract_i,
    input         register_inputs_i
);

    parameter [9:0] COEFF_0 = 10'd0;
    parameter [9:0] COEFF_1 = 10'd0;
    parameter [9:0] COEFF_2 = 10'd0;
    parameter [9:0] COEFF_3 = 10'd0;

    wire [18:0] z_rem;
    wire [8:0] dly_b_rem;

    QL_DSP2 #(
        .COEFF_0({10'd0, COEFF_0}),
        .COEFF_1({10'd0, COEFF_1}),
        .COEFF_2({10'd0, COEFF_2}),
        .COEFF_3({10'd0, COEFF_3})
   ) dsp (
    .a({10'd0, a_i}),
    .b({9'd0, b_i}),
    .z({z_rem, z_o}),
    .dly_b({dly_b_rem, dly_b_o}),

    .f_mode(1'b1),  // 10x9x32 DSP

    .acc_fir({2'd0, acc_fir_i}),
    .feedback(feedback_i),
    .load_acc(load_acc_i),

    .unsigned_a(unsigned_a_i),
    .unsigned_b(unsigned_b_i),

    .clk(clock_i),
    .reset(reset_i),

    .saturate_enable(saturate_enable_i),
    .output_select(output_select_i),
    .round(round_i),
    .shift_right(shift_right_i),
    .subtract(subtract_i),
    .register_inputs(register_inputs_i)
    );
endmodule
