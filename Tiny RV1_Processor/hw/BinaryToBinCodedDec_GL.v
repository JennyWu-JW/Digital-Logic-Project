//========================================================================
// BinaryToBinCodedDec_GL
//========================================================================

`ifndef BINARY_TO_BIN_CODED_DEC_GL_V
`define BINARY_TO_BIN_CODED_DEC_GL_V

module BinaryToBinCodedDec_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [3:0] tens,
  (* keep=1 *) output wire [3:0] ones
);

  wire a, b, c, d, e;

  assign a = in[4];
  assign b = in[3];
  assign c = in[2];
  assign d = in[1];
  assign e = in[0];

  wire min1, min2, min3, min4, min5, min6, min7, min8, min9, min10, min11, min12, min13, min14, min15;
  wire min16, min17, min18, min19, min20, min21, min22, min23, min24, min25, min26, min27, min28, min29, min30, min31;

  // Find min values
  assign min1 = ~a & ~b & ~c & ~d & e;
  assign min2 = ~a & ~b & ~c & d & ~e;
  assign min3 = ~a & ~b & ~c & d & e;
  assign min4 = ~a & ~b & c & ~d & ~e;
  assign min5 = ~a & ~b & c & ~d & e;
  assign min6 = ~a & ~b & c & d & ~e;
  assign min7 = ~a & ~b & c & d & e;
  assign min8 = ~a & b & ~c & ~d & ~e;
  assign min9 = ~a & b & ~c & ~d & e;
  assign min10 = ~a & b & ~c & d & ~e;
  assign min11 = ~a & b & ~c & d & e;
  assign min12 = ~a & b & c & ~d & ~e;
  assign min13 = ~a & b & c & ~d & e;
  assign min14 = ~a & b & c & d & ~e;
  assign min15 = ~a & b & c & d & e;
  assign min16 = a & ~b & ~c & ~d & ~e;
  assign min17 = a & ~b & ~c & ~d & e;
  assign min18 = a & ~b & ~c & d & ~e;
  assign min19 = a & ~b & ~c & d & e;
  assign min20 = a & ~b & c & ~d & ~e;
  assign min21 = a & ~b & c & ~d & e;
  assign min22 = a & ~b & c & d & ~e;
  assign min23 = a & ~b & c & d & e;
  assign min24 = a & b & ~c & ~d & ~e;
  assign min25 = a & b & ~c & ~d & e;
  assign min26 = a & b & ~c & d & ~e;
  assign min27 = a & b & ~c & d & e;
  assign min28 = a & b & c & ~d & ~e;
  assign min29 = a & b & c & ~d & e;
  assign min30 = a & b & c & d & ~e;
  assign min31 = a & b & c & d & e;

  // Sum of products
  assign tens[0] = min10 | min11 | min12 | min13 | min14 | min15 | min16 | min17 | min18 | min19 | min30 | min31;
  assign tens[1] = min20 | min21 | min22 | min23 | min24 | min25 | min26 | min27 | min28 | min29 | min30 | min31;
  assign tens[2] = 0;
  assign tens[3] = 0;

  assign ones[0] = min1 | min3 | min5 | min7 | min9 | min11 | min13 | min15 | min17 | min19 | min21 | min23 | min25 | min27 | min29 | min31;
  assign ones[1] = min2 | min3 | min6 | min7 | min12 | min13 | min16 | min17 | min22 | min23 | min26 | min27;
  assign ones[2] = min4 | min5 | min6 | min7 | min14 | min15 | min16 | min17 | min24 | min25 | min26 | min27;
  assign ones[3] = min8 | min9 | min18 | min19 | min28 | min29;

endmodule

`endif /* BINARY_TO_BIN_CODED_DEC_GL_V */

