//========================================================================
// ClockDiv_RTL.v
//========================================================================
// A staff-provided clock divider that divides the clock frequency by a
// factor of 2^(p_factor)

`ifndef CLOCKDIV_RTL_V
`define CLOCKDIV_RTL_V

module ClockDiv_RTL
(
  input  logic clk_in,
  input  logic rst,
  output logic clk_out
);

  parameter p_factor = 11;

  logic [p_factor:0] count;

  always @( posedge clk_in ) begin
    if ( rst )
      count <= 0;
    else
      count <= count + 1;
  end

  assign clk_out = count[p_factor];

endmodule

`endif /* CLOCKDIV_RTL_V */

