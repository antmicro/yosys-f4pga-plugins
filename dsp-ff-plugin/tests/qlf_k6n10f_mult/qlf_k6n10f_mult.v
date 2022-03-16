// Copyright (C) 2020-2021  The SymbiFlow Authors.
//
// Use of this source code is governed by a ISC-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/ISC
//
// SPDX-License-Identifier:ISC

module mult_ireg (
    input  wire        CLK,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output wire [15:0] Z
);

    reg [7:0] ra;
    reg [7:0] rb;

    always @(posedge CLK) begin
        ra <= A;
        rb <= B;
    end

    assign Z = ra * rb;

endmodule

module mult_oreg (
    input  wire        CLK,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);

    always @(posedge CLK)
        Z <= A * B;

endmodule

module mult_all (
    input  wire        CLK,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);

    reg [7:0] ra;
    reg [7:0] rb;

    always @(posedge CLK) begin
        ra <= A;
        rb <= B;
    end

    always @(posedge CLK)
        Z <= ra * rb;

endmodule

