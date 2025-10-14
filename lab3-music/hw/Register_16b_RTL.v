//========================================================================
// Register_16b_RTL
//========================================================================

`ifndef REGISTER_16B_RTL_V
`define REGISTER_16B_RTL_V

module Register_16b_RTL
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,
  (* keep=1 *) input  logic        en,
  (* keep=1 *) input  logic [15:0] d,
  (* keep=1 *) output logic [15:0] q
);

  //If reset is high next q will be 0, otherwise if enable is high it will be d, otherwise retain q
  always_ff @(posedge clk) begin
    if(rst) begin
      q <= {16{1'b0}};
    end else if(en) begin
      q <= d;
    end
  end

endmodule

`endif /* REGISTER_16B_RTL_V */

