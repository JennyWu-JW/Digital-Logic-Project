//========================================================================
// Mux8_1b_RTL
//========================================================================
// Used ChatGPT to implement the combinational logic

`ifndef MUX8_1B_RTL
`define MUX8_1B_RTL

module Mux8_1b_RTL
(
  (* keep=1 *) input  logic       in0,
  (* keep=1 *) input  logic       in1,
  (* keep=1 *) input  logic       in2,
  (* keep=1 *) input  logic       in3,
  (* keep=1 *) input  logic       in4,
  (* keep=1 *) input  logic       in5,
  (* keep=1 *) input  logic       in6,
  (* keep=1 *) input  logic       in7,
  (* keep=1 *) input  logic [2:0] sel,
  (* keep=1 *) output logic       out
);

  // Implement 1-bit 8-to-1 MUX using RTL and a single always_comb block
  always_comb begin
    case (sel)
      3'b000: out = in0;  // If sel is 000, select in0
      3'b001: out = in1;  // If sel is 001, select in1
      3'b010: out = in2;  // If sel is 010, select in2
      3'b011: out = in3;  // If sel is 011, select in3
      3'b100: out = in4;  // If sel is 100, select in4
      3'b101: out = in5;  // If sel is 101, select in5
      3'b110: out = in6;  // If sel is 110, select in6
      3'b111: out = in7;  // If sel is 111, select in7
      default: out = 1'b0; // Default case
    endcase
  end

endmodule

`endif /* MUX8_1B_RTL */

