//========================================================================
// AdderRippleCarry_8b_GL
//========================================================================

`ifndef ADDER_RIPPLE_CARRY_8B_GL
`define ADDER_RIPPLE_CARRY_8B_GL

`include "AdderRippleCarry_4b_GL.v"

module AdderRippleCarry_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [7:0] sum
);

  wire carry;

  // Two 4 bit ripple-carry adders chained together
  AdderRippleCarry_4b_GL adder0 (
    .in0(in0[3:0]),
    .in1(in1[3:0]),
    .cin(cin),
    .cout(carry),
    .sum(sum[3:0])
  );

  AdderRippleCarry_4b_GL adder1 (
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .cin(carry),
    .cout(cout),
    .sum(sum[7:4])
  );

endmodule

`endif /* ADDER_RIPPLE_CARRY_8B_GL */

