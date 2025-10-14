//========================================================================
// Display_GL
//========================================================================

`ifndef DISPLAY_GL_V
`define DISPLAY_GL_V

`include "BinaryToBinCodedDec_GL.v"
`include "BinaryToSevenSeg_GL.v"

module Display_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [6:0] seg_tens,
  (* keep=1 *) output wire [6:0] seg_ones
);

  wire [3:0] tensplace;
  wire [3:0] onesplace;

  BinaryToBinCodedDec_GL tens_ones (
    .in(in),
    .tens(tensplace),
    .ones(onesplace)
  );

  BinaryToSevenSeg_GL ones(
    .in(onesplace),
    .seg(seg_ones)
  );

  BinaryToSevenSeg_GL tens(
    .in(tensplace),
    .seg(seg_tens)
  );

endmodule

`endif /* DISPLAY_GL_V */

