//========================================================================
// ALU_32b
//========================================================================
// Simple ALU which supports both addition and equality comparision. For
// equality comparison the least-significant bit will be one if in0
// equals in1 and zero otherwise; the remaining 31 bits will always be
// zero.
//
//  - op == 0 : add
//  - op == 1 : equality comparison
//

`ifndef ALU_32B_V
`define ALU_32B_V

`include "Adder_32b_GL.v"
`include "EqComparator_32b_RTL.v"
`include "Mux2_RTL.v"

module ALU_32b
(
  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) input  logic        op,
  (* keep=1 *) output logic [31:0] out
);

  // Instantiate adder
  logic [31:0] sum_32b;
  Adder_32b_GL adder_32b (
    .in0(in0),
    .in1(in1),
    .sum(sum_32b)
  );

  // Instantiate equality comparator
  logic if_equal;
  EqComparator_32b_RTL eqcomparator_32b (
    .in0(in0),
    .in1(in1),
    .eq(if_equal)
  );

  // Combinational logic to select between addition and equality comparison
  always_comb begin
    case (op)
      1'b0 : out = sum_32b;
      default : out = {31'd0, if_equal};
    endcase
  end

endmodule

`endif /* ALU_32B_V */

