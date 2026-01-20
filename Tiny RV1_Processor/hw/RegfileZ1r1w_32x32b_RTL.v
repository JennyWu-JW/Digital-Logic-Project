//========================================================================
// RegfileZ1r1w_32x32b_RTL
//========================================================================
// Register file with 32 32-bit entries, one read port, and one write
// port. Reading register zero should always return zero. If waddr ==
// raddr then rdata should be the old data.
// Used ChatGPT to generate code for combinational logic

`ifndef REGFILE_Z_1R1W_32X32B_RTL
`define REGFILE_Z_1R1W_32X32B_RTL

module RegfileZ1r1w_32x32b_RTL
(
  (* keep=1 *) input  logic        clk,

  (* keep=1 *) input  logic        wen,
  (* keep=1 *) input  logic  [4:0] waddr,
  (* keep=1 *) input  logic [31:0] wdata,

  (* keep=1 *) input  logic  [4:0] raddr,
  (* keep=1 *) output logic [31:0] rdata
);

  logic [31:0] regfile [31:0];

  // If enable is high and the address is not 0, write data to the regfile
  always_ff @(posedge clk) begin
    if (wen && waddr != 5'b0_0000) begin
      regfile[waddr] <= wdata;
    end
  end

  // Register zero always zero
  always_comb begin
    if (raddr == 5'd0)
      rdata = 32'b0;
    else if (raddr == waddr && wen)
      rdata = regfile[raddr]; // Return old data if waddr == raddr
    else
      rdata = regfile[raddr]; // Outputs data from the corresponding regfile
  end

endmodule

`endif /* REGFILE_Z_1R1W_32x32b_RTL */

