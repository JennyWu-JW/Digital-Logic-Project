//========================================================================
// Register_RTL
//========================================================================

`ifndef REGISTER_RTL_V
`define REGISTER_RTL_V

module Register_RTL
#(
  parameter p_nbits = 1
)(
  input  logic               clk,
  input  logic               rst,
  input  logic               en,
  input  logic [p_nbits-1:0] d,
  output logic [p_nbits-1:0] q
);

  // If reset is high next q will be 0, otherwise if enable is high it will be d, otherwise retain q
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= {p_nbits{1'd0}};
    end else if(en) begin
      q <= d;
    end
  end

endmodule

`endif /* REGISTER_RTL_V */

