//========================================================================
// DFFRE_RTL_V
//========================================================================

`ifndef DFFRE_RTL_V
`define DFFRE_RTL_V

module DFFRE_RTL
(
  (* keep=1 *) input  logic clk,
  (* keep=1 *) input  logic rst,
  (* keep=1 *) input  logic en,
  (* keep=1 *) input  logic d,
  (* keep=1 *) output logic q
);

  // Input only passed to output if enable is high
  always_ff @(posedge clk) begin
    if(rst) begin
      q <= 1'b0;
    end else if(en) begin
      q <= d;
    end
  end
  
endmodule

`endif /* DFFRE_RTL_V */

