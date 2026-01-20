//========================================================================
// Multiplier_2x8b_GL
//========================================================================

`ifndef MULTIPLIER_2x8b_GL
`define MULTIPLIER_2x8b_GL

`include "Multiplier_1x8b_GL.v"
`include "AdderCarrySelect_8b_GL.v"

module Multiplier_2x8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [1:0] in1,
  (* keep=1 *) output wire [7:0] prod
);

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement 2-bit x 8-bit multiplier by instantiating other modules
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  wire [7:0]zero; 
  wire [7:0]ones;
  wire carryout_unused;
  assign carryout_unused = 1'b0;
  wire unused;
  assign unused = ones[7];


  // Multipliers take the input and muliplies the least significant bit
  Multiplier_1x8b_GL Multi_Zero (
    .in0(in0),
    .in1(in1[0]),
    .prod(zero)
  ); 
  
  // Multipliers take the input and muliplies the second least significant bit
    Multiplier_1x8b_GL Multi_One (
    .in0(in0),
    .in1(in1[1]),
    .prod(ones)
  );

  // Adder takes the outputs from both multipliers and shifts multiplier_one 
  // by 1-bit then add the the values fron in0 and in1 with 0 carryin
    AdderCarrySelect_8b_GL adder (
      .in0(zero),
      .in1({ones[6:0], 1'b0}), 
      .cin(1'b0),
      .cout(carryout_unused),
      .sum(prod)
    );

endmodule

`endif /* MULTIPLIER_2x8b_GL */

