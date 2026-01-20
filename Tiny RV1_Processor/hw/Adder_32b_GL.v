//========================================================================
// Adder_32b_GL
//========================================================================

`ifndef ADDER_32B_GL
`define ADDER_32B_GL

`include "AdderCarrySelect_8b_GL.v"

module Adder_32b_GL
(
  (* keep=1 *) input  wire [31:0] in0,
  (* keep=1 *) input  wire [31:0] in1,
  (* keep=1 *) output wire [31:0] sum
);

  // instatuated four CarrySelectAdders

  // Create wires for cout between the four CarrySelectAdders
  wire cout_add1;
  wire cout_add2;
  wire cout_add3;
  wire unused_cout;
  assign unused_cout = 1'b1;

  //Split 32 bits into four 8 bits
  AdderCarrySelect_8b_GL Adder1(
    .in0(in0[7:0]),
    .in1(in1[7:0]),
    .cin(1'b0),
    .cout(cout_add1),
    .sum(sum[7:0])
  );

  AdderCarrySelect_8b_GL Adder2(
    .in0(in0[15:8]),
    .in1(in1[15:8]),
    .cin(cout_add1),
    .cout(cout_add2),
    .sum(sum[15:8])
  );

  AdderCarrySelect_8b_GL Adder3(
    .in0(in0[23:16]),
    .in1(in1[23:16]),
    .cin(cout_add2),
    .cout(cout_add3),
    .sum(sum[23:16])
  );

  AdderCarrySelect_8b_GL Adder4(
    .in0(in0[31:24]),
    .in1(in1[31:24]),
    .cin(cout_add3),
    .cout(unused_cout),
    .sum(sum[31:24])
  );





endmodule

`endif /* ADDER_32B_GL */

