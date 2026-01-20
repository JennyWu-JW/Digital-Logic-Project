//========================================================================
// Mux2_RTL
//========================================================================

`ifndef MUX2_RTL
`define MUX2_RTL

module Mux2_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic               sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  // Combinational logic block that selects one of the inputs based on the 1-b sel value
  always_comb begin
    case (sel)
    1'b0 : out = in0;
    1'b1 : out = in1;
    default : out = 'x;
    endcase
  end

endmodule

`endif /* MUX2_RTL */

