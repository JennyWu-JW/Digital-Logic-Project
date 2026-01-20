//========================================================================
// DLatch_GL
//========================================================================

`ifndef DLATCH_GL_V
`define DLATCH_GL_V

// verilator lint_off UNOPTFLAT

module DLatch_GL
(
  (* keep=1 *) input  wire clk,
  (* keep=1 *) input  wire d,
  (* keep=1 *) output wire q
);

  // Implementing D Latch using logic gates
  wire dbar, s, r, x;
  not(dbar, d);

  and(s, d, clk);
  and(r, dbar, clk);
  nor(x, q, s);
  nor(q, x, r);

endmodule

// verilator lint_on UNOPTFLAT

`endif /* DLATCH_GL_V */

