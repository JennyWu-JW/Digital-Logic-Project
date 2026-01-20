//========================================================================
// Multiplier_1x8b_GL
//========================================================================

`ifndef MULTIPLIER_1x8b_GL
`define MULTIPLIER_1x8b_GL

module Multiplier_1x8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire       in1,
  (* keep=1 *) output wire [7:0] prod
);

  // Assign each bit of prob with in1 and each bit of in0
  assign prod[0] = in1 & in0[0];
  assign prod[1] = in1 & in0[1];
  assign prod[2] = in1 & in0[2];
  assign prod[3] = in1 & in0[3];
  assign prod[4] = in1 & in0[4];
  assign prod[5] = in1 & in0[5];
  assign prod[6] = in1 & in0[6];
  assign prod[7] = in1 & in0[7];

endmodule

`endif /* MULTIPLIER_1x8b_GL */

