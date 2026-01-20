//========================================================================
// Mux2_1b_GL
//========================================================================

`ifndef MUX2_1B_GL
`define MUX2_1B_GL

module Mux2_1b_GL
(
  (* keep=1 *) input  in0,
  (* keep=1 *) input  in1,
  (* keep=1 *) input  sel,
  (* keep=1 *) output out
);

  assign out = (in0 & in1) | (in0 & ~sel) | (in1 & sel);

endmodule

`endif /* MUX2_1B_GL */

