//========================================================================
// DFFR_RTL
//========================================================================

`ifndef DFFR_RTL_V
`define DFFR_RTL_V

module DFFR_RTL
(
  (* keep=1 *) input  logic clk,
  (* keep=1 *) input  logic rst,
  (* keep=1 *) input  logic d,
  (* keep=1 *) output logic q
);

  // Same as DFF but with additional line to set output to 0 when reset is high
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= 1'b0;
    end
    else begin
      q <= d;
    end
  end

endmodule

`endif /* DFFR_RTL_V */

