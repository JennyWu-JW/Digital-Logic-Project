//========================================================================
// Multiplier_2x8b_RTL
//========================================================================

`ifndef MULTIPLIER_2x8b_RTL
`define MULTIPLIER_2x8b_RTL

module Multiplier_2x8b_RTL
(
  (* keep=1 *) input  logic [7:0] in0,
  (* keep=1 *) input  logic [1:0] in1,
  (* keep=1 *) output logic [7:0] prod
);

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement 2-bit x 8-bit multiplier using RTL modeling
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  assign prod = in1 * in0 ;

endmodule

`endif /* MULTIPLIER_2x8b_RTL */

