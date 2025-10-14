//========================================================================
// Register_8b_RTL
//========================================================================

`ifndef REGISTER_8B_RTL_V
`define REGISTER_8B_RTL_V

module Register_8b_RTL
(
  (* keep=1 *) input  logic       clk,
  (* keep=1 *) input  logic       rst,
  (* keep=1 *) input  logic       en,
  (* keep=1 *) input  logic [7:0] d,
  (* keep=1 *) output logic [7:0] q
);

  //If reset is high next q will be 0, otherwise if enable is high it will be d, otherwise retain q
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= {8{1'b0}};
    end else if(en) begin
      q <= d;
    end
  end

endmodule

`endif /* REGISTER_8B_RTL_V */

