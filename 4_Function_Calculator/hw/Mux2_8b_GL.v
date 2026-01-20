//========================================================================
// Mux2_8b_GL
//========================================================================

`ifndef MUX2_8B_GL
`define MUX2_8B_GL

`include "Mux2_4b_GL.v"

module Mux2_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       sel,
  (* keep=1 *) output wire [7:0] out
);

  // Mux with 4 least significant bit 
  Mux2_4b_GL mux0(
    .in0(in0[3:0]),
    .in1(in1[3:0]),
    .sel(sel),
    .out(out[3:0])
  );

  // Mux with 4 most significant bit
  Mux2_4b_GL mux1(
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .sel(sel),
    .out(out[7:4])
  );

endmodule

`endif /* MUX2_8B_GL */

