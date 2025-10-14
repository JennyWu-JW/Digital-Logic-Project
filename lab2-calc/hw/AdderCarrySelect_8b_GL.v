//========================================================================
// AdderCarrySelect_8b_GL
//========================================================================

`ifndef ADDER_CARRY_SELECT_8B_GL
`define ADDER_CARRY_SELECT_8B_GL

`include "AdderRippleCarry_4b_GL.v"
`include "Mux2_4b_GL.v"

module AdderCarrySelect_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [7:0] sum
);

  wire carrylower;
  wire carry0;
  wire carry1;
  wire [3:0] sum0;
  wire [3:0] sum1;

  //Ripple-Carry Adder for the lower 4 bits
  AdderRippleCarry_4b_GL lower(
    .in0(in0[3:0]),
    .in1(in1[3:0]),
    .cin(cin),
    .cout(carrylower),
    .sum(sum[3:0])
  );

  //Ripple-Carry Adder for the upper 4 bits assuming no carry
  AdderRippleCarry_4b_GL upperzero(
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .cin(1'b0),
    .cout(carry0),
    .sum(sum0[3:0])
  );

  //Ripple-Carry Adder for the upper 4 bits assuming with carry
  AdderRippleCarry_4b_GL upperone(
    .in0(in0[7:4]),
    .in1(in1[7:4]),
    .cin(1'b1),
    .cout(carry1),
    .sum(sum1[3:0])
  );

  //Mux to select correct cout value
  Mux2_1b_GL mux1b(
    .in0(carry0),
    .in1(carry1),
    .sel(carrylower),
    .out(cout)
  );

  //Mux to select correct value for the upper 4 bits of the sum output
  Mux2_4b_GL mux4b(
    .in0(sum0[3:0]),
    .in1(sum1[3:0]),
    .sel(carrylower),
    .out(sum[7:4])
  );

endmodule

`endif /* ADDER_CARRY_SELECT_8B_GL */

