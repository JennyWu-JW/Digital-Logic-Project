//========================================================================
// DFF_RTL
//========================================================================

`ifndef DFF_RTL_V
`define DFF_RTL_V

module DFF_RTL
(
  (* keep=1 *) input  logic clk,
  (* keep=1 *) input  logic d,
  (* keep=1 *) output logic q
);

// Transfers input to output on positive clock edge
  always_ff @(posedge clk) begin
    q <= d;
  end

endmodule

`endif /* DFF_RTL_V */

