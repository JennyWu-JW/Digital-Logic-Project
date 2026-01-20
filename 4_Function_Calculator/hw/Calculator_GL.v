//========================================================================
// Calculator_GL
//========================================================================

`ifndef CALCULATOR_GL
`define CALCULATOR_GL

`include "AdderCarrySelect_8b_GL.v"
`include "Multiplier_2x8b_GL.v"
`include "Mux2_8b_GL.v"

module Calculator_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       op,
  (* keep=1 *) output wire [7:0] result
);

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the calculator
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  wire [7:0]add;
  wire [7:0]multi;
  wire unused;
  assign unused = 1'b0;

  //AdderCarrySelect takes the inputs (in0 and in1) and computes a product (add)
  AdderCarrySelect_8b_GL adder (
    .in0(in0),
    .in1(in1), 
    .cin(1'b0),
    .cout(unused),
    .sum(add)
  );

  //Multiplier take inputs (in0 and in1) and computes a product (multi)
  Multiplier_2x8b_GL multiplier(
    .in0(in0),
    .in1(in1[1:0]),
    .prod(multi)
  );

  //Mux to select between addition and multiplication from op
  Mux2_8b_GL mux (
    .in0(add),
    .in1(multi),
    .sel(op),
    .out(result)
  );


endmodule

`endif /* CALCULATOR_GL */

