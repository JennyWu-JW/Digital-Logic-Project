//========================================================================
// CalculatorDisplay_GL
//========================================================================

`ifndef CALCULATOR_DISPLAY_GL
`define CALCULATOR_DISPLAY_GL

`include "Calculator_GL.v"
`include "Display_GL.v"

module CalculatorDisplay_GL
(
  (* keep=1 *) input  wire [4:0] in0,
  (* keep=1 *) input  wire [4:0] in1,
  (* keep=1 *) input  wire       op,
  (* keep=1 *) output wire [6:0] in0_seg_tens,
  (* keep=1 *) output wire [6:0] in0_seg_ones,
  (* keep=1 *) output wire [6:0] in1_seg_tens,
  (* keep=1 *) output wire [6:0] in1_seg_ones,
  (* keep=1 *) output wire [6:0] result_seg_tens,
  (* keep=1 *) output wire [6:0] result_seg_ones
);

  
  wire [7:0]total;
  wire [2:0]unused;
  assign unused = total[7:5];
  
  // Calculating the input in0 with 3-bit 0 entension with two operation
  // of multiplication and addition, outputting the result 
  Calculator_GL Calc(
    .in0({3'b0, in0}),
    .in1({3'b0, in1}),
    .op(op),
    .result(total)
  );

  // Display for HEX 5, HEX 4
  Display_GL display_one(
    .in(in0[4:0]),
    .seg_tens(in0_seg_tens),
    .seg_ones(in0_seg_ones)
  );

  // Display for HEX 3, HEX 2 
    Display_GL display_two(
    .in(in1[4:0]),
    .seg_tens(in1_seg_tens),
    .seg_ones(in1_seg_ones)
  );

  // Display for HEX 1, HEX 0 
    Display_GL display_result(
    .in(total[4:0]),
    .seg_tens(result_seg_tens),
    .seg_ones(result_seg_ones)
  );

endmodule

`endif /* CALCULATOR_GL */

