//========================================================================
// AdderRippleCarry_4b_GL
//========================================================================

`ifndef ADDER_RIPPLE_CARRY_4B_GL_V
`define ADDER_RIPPLE_CARRY_4B_GL_V

`include "FullAdder_GL.v"

module AdderRippleCarry_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [3:0] sum
);

  wire carry0, carry1, carry2;
  
  //Creating 4 full adders and chaining them, one cout corresponding to the next one's cin
  
  FullAdder_GL fa0 (
    .in0(in0[0]),
    .in1(in1[0]),
    .cin(cin),
    .cout(carry0),
    .sum(sum[0])
  ); 

  FullAdder_GL fa1 (
    .in0(in0[1]),
    .in1(in1[1]),
    .cin(carry0),
    .cout(carry1),
    .sum(sum[1])
  ); 

  FullAdder_GL fa2 (
    .in0(in0[2]),
    .in1(in1[2]),
    .cin(carry1),
    .cout(carry2),
    .sum(sum[2])
  ); 

  FullAdder_GL fa3 (
    .in0(in0[3]),
    .in1(in1[3]),
    .cin(carry2),
    .cout(cout),
    .sum(sum[3])
  ); 

endmodule

`endif /* ADDER_RIPPLE_CARRY_4B_GL_V */

