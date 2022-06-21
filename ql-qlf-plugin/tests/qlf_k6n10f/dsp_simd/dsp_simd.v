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

module simd_mult (
    input  wire         clk,

    input  wire [ 7:0]  a0,
    input  wire [ 7:0]  b0,
    output wire [15:0]  z0,

    input  wire [ 7:0]  a1,
    input  wire [ 7:0]  b1,
    output wire [15:0]  z1
);

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_0 (
        .a_i    (a0),
        .b_i    (b0),
        .z_o    (z0),

        .clock_i            (clk),

	.acc_fir_i          (6'b0),
        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),
        .subtract_i         (1'b0)
    );

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_1 (
        .a_i    (a1),
        .b_i    (b1),
        .z_o    (z1),

        .clock_i            (clk),

	.acc_fir_i          (6'b0),
        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),
        .subtract_i         (1'b0)
    );

endmodule

module simd_mult_inferred (
    input  wire         clk,

    input  wire [ 7:0]  a0,
    input  wire [ 7:0]  b0,
    output reg  [15:0]  z0,

    input  wire [ 7:0]  a1,
    input  wire [ 7:0]  b1,
    output reg  [15:0]  z1
);

    always @(posedge clk)
        z0 <= a0 * b0;

    always @(posedge clk)
        z1 <= a1 * b1;

endmodule

module simd_mult_odd (
    input  wire         clk,

    input  wire [ 7:0]  a0,
    input  wire [ 7:0]  b0,
    output wire [15:0]  z0,

    input  wire [ 7:0]  a1,
    input  wire [ 7:0]  b1,
    output wire [15:0]  z1,

    input  wire [ 7:0]  a2,
    input  wire [ 7:0]  b2,
    output wire [15:0]  z2
);

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_0 (
        .a_i    (a0),
        .b_i    (b0),
        .z_o    (z0),

        .clock_i            (clk),

        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),

        .subtract_i         (1'b0)
    );

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_1 (
        .a_i    (a1),
        .b_i    (b1),
        .z_o    (z1),

        .clock_i            (clk),

        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),

        .subtract_i         (1'b0)
    );

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_2 (
        .a_i    (a2),
        .b_i    (b2),
        .z_o    (z2),

        .clock_i            (clk),

        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),

        .subtract_i         (1'b0)
    );

endmodule

module simd_mult_conflict (
    input  wire         clk0,
    input  wire         clk1,

    input  wire [ 7:0]  a0,
    input  wire [ 7:0]  b0,
    output wire [15:0]  z0,

    input  wire [ 7:0]  a1,
    input  wire [ 7:0]  b1,
    output wire [15:0]  z1
);

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_0 (
        .a_i    (a0),
        .b_i    (b0),
        .z_o    (z0),

        .clock_i            (clk0),

        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),

        .subtract_i         (1'b0)
    );

    dsp_t1_10x9x32 #(
        .OUTPUT_SELECT      (3'd0),
        .SATURATE_ENABLE    (1'd0),
        .SHIFT_RIGHT        (6'd0),
        .ROUND              (1'd0),
        .REGISTER_INPUTS    (1'd1)
    ) dsp_1 (
        .a_i    (a1),
        .b_i    (b1),
        .z_o    (z1),

        .clock_i            (clk1),

        .feedback_i         (3'd0),
        .load_acc_i         (1'b0),
        .unsigned_a_i       (1'b1),
        .unsigned_b_i       (1'b1),

        .subtract_i         (1'b0)
    );

endmodule

