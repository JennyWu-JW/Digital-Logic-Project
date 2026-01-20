//========================================================================
// Mux2_8b_RTL
//========================================================================
// Used ChatGPT to implement the combinational logic

`ifndef MUX2_8B_RTL
`define MUX2_8B_RTL

module Mux2_8b_RTL
(
  (* keep=1 *) input  logic [7:0] in0,
  (* keep=1 *) input  logic [7:0] in1,
  (* keep=1 *) input  logic       sel,
  (* keep=1 *) output logic [7:0] out
);

  // Implement the 2-to-1 MUX using RTL and a single always_comb block
  always_comb begin
    if (sel)
      out = in1;   // If sel is 1, select in1
    else
      out = in0;   // If sel is 0, select in0
  end

endmodule

`endif /* MUX2_8B_RTL */

