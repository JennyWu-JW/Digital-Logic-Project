//========================================================================
// BinaryToSevenSeg_GL
//========================================================================

`ifndef BINARY_TO_SEVEN_SEG_GL_V
`define BINARY_TO_SEVEN_SEG_GL_V

module BinaryToSevenSeg_GL
(
  (* keep=1 *) input  wire [3:0] in,
  (* keep=1 *) output wire [6:0] seg
);

  wire a, b, c, d;
  assign a = in[3];
  assign b = in[2];
  assign c = in[1];
  assign d = in[0];
  
  assign seg[0] = (~a & b & ~c & ~d) | (~a & ~b & ~c & d);
  assign seg[1] = (~a & b & ~c & d) | (~a & b & c & ~d);
  assign seg[2] = ~a & ~b & c & ~d;
  assign seg[3] = (~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & c & d);
  assign seg[4] = (~a & d) | (~a & b & ~c) | (~b & ~c & d);
  assign seg[5] = (~a & ~b & d) | (~a & c & d) | (~a & ~b & c);
  assign seg[6] = (~a & ~b & ~c) | (~a & b & c & d);

endmodule

`endif /* BINARY_TO_SEVEN_SEG_GL_V */

