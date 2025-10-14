//========================================================================
// Subtractor_8b_GL
//========================================================================

`ifndef SUBTRACTOR_8B_GL_V
`define SUBTRACTOR_8B_GL_V

`include "AdderRippleCarry_8b_GL.v"

module Subtractor_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) output wire [7:0] diff
);

  wire unused;

  // Adder adds two's compliment of in1 to in0  with a cin 1'b1
  AdderRippleCarry_8b_GL complement(
    .in0(in0),
    .in1(~in1),
    .cin(1'b1),
    .cout(unused),
    .sum(diff)
  );

endmodule

`endif /* SUBTRACTOR_8B_GL_V */

