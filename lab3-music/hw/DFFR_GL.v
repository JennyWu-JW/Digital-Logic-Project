//========================================================================
// DFFR_GL
//========================================================================

`ifndef DFFR_GL_V
`define DFFR_GL_V

`include "DFF_GL.v"

module DFFR_GL
(
  (* keep=1 *) input  wire clk,
  (* keep=1 *) input  wire rst,
  (* keep=1 *) input  wire d,
  (* keep=1 *) output wire q
);

  wire norst;
  not(norst, rst);

  // Input 0 when reset is high
  wire in;
  and(in, d, norst);

  // Flip flop where input is dependent on reset signal
  DFF_GL dff(
    .clk(clk),
    .d(in),
    .q(q)
  );

endmodule

`endif /* DFFR_GL_V */

