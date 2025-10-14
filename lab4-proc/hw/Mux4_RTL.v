//========================================================================
// Mux4_RTL
//========================================================================

`ifndef MUX4_RTL
`define MUX4_RTL

module Mux4_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic [p_nbits-1:0] in2,
  (* keep=1 *) input  logic [p_nbits-1:0] in3,
  (* keep=1 *) input  logic         [1:0] sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  // Combinational logic block that selects one of the inputs based on the 2-b sel value
  always_comb begin
    case (sel)
    2'b00 : out = in0;
    2'b01 : out = in1;
    2'b10 : out = in2;
    default : out = in3;
    endcase
  end

endmodule

`endif /* MUX4_RTL */

