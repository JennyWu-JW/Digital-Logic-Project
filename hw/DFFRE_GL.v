//========================================================================
// DFFRE_GL
//========================================================================

`ifndef DFFRE_GL_V
`define DFFRE_GL_V

`include "DFF_GL.v"
`include "Mux2_1b_GL.v"

// verilator lint_off UNOPTFLAT

module DFFRE_GL
(
  (* keep=1 *) input  wire clk,
  (* keep=1 *) input  wire rst,
  (* keep=1 *) input  wire en,
  (* keep=1 *) input  wire d,
  (* keep=1 *) output wire q
);

  wire enable_out;

  // Mux for enable
  Mux2_1b_GL enable(
    .in0(q),
    .in1(d),
    .sel(en),
    .out(enable_out)
  );

  wire in, out;
  not(in, rst);
  and(out, enable_out, in); // Using and gate the output depends both on result from enable mux and reset

  DFF_GL dff(
    .clk(clk),
    .d(out),
    .q(q)
  );


endmodule

// verilator lint_on UNOPTFLAT

`endif /* DFFRE_GL_V */

