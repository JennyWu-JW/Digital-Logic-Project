//========================================================================
// DFF_GL
//========================================================================

`ifndef DFF_GL_V
`define DFF_GL_V

`include "DLatch_GL.v"

module DFF_GL
(
  (* keep=1 *) input  wire clk,
  (* keep=1 *) input  wire d,
  (* keep=1 *) output wire q
);

  wire leaderclk;
  not(leaderclk, clk);

  wire n1;

  // Instantiating 2 D Latches to create a D Flip-Flop with a not connected to one's clock
  DLatch_GL leader(
    .clk(leaderclk),
    .d(d),
    .q(n1)
  );

  DLatch_GL follower(
    .clk(clk),
    .d(n1),
    .q(q)
  );

endmodule

`endif /* DFF_GL_V */

