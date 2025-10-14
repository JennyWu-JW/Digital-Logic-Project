//========================================================================
// Adder_8b_RTL
//========================================================================

`ifndef ADDER_8B_RTL
`define ADDER_8B_RTL

module Adder_8b_RTL
(
  (* keep=1 *) input  logic [7:0] in0,
  (* keep=1 *) input  logic [7:0] in1,
  (* keep=1 *) input  logic       cin,
  (* keep=1 *) output logic       cout,
  (* keep=1 *) output logic [7:0] sum
);

  assign {cout,sum} = in0 + in1 + {7'b0,cin};

endmodule

`endif /* ADDER_8B_RTL */

