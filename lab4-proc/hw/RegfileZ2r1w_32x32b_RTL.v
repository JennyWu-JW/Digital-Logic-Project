//========================================================================
// RegfileZ2r1w_32x32b_RTL
//========================================================================
// Register file with 32 32-bit entries, two read ports, and one write
// port. Reading register zero should always return zero. If waddr ==
// raddr then rdata should be the old data.
// Used ChatGPT to generate code for combinational logic

`ifndef REGFILE_Z_2R1W_32X32B_RTL
`define REGFILE_Z_2R1W_32X32B_RTL

module RegfileZ2r1w_32x32b_RTL
(
  (* keep=1 *) input  logic        clk,

  (* keep=1 *) input  logic        wen,
  (* keep=1 *) input  logic  [4:0] waddr,
  (* keep=1 *) input  logic [31:0] wdata,

  (* keep=1 *) input  logic  [4:0] raddr0,
  (* keep=1 *) output logic [31:0] rdata0,

  (* keep=1 *) input  logic  [4:0] raddr1,
  (* keep=1 *) output logic [31:0] rdata1
);

  logic [31:0] regfile [31:0];

  // If enable is high and the address is not 0, write data to the regfile
  always_ff @(posedge clk) begin
    if (wen && waddr != 5'b0) begin
      regfile[waddr] <= wdata;
    end
  end

  // Combinational read block for rdata0
  always_comb begin
    if (raddr0 == 5'd0) begin
      rdata0 = 32'b0; // Register 0 always reads as 0
    end
    else if (raddr0 == waddr && wen) begin
      rdata0 = regfile[raddr0]; // Return old data if waddr == raddr0
    end
    else begin
      rdata0 = regfile[raddr0]; // Normal read
    end
  end

  // Combinational read block for rdata1
  always_comb begin
    if (raddr1 == 5'd0) begin
      rdata1 = 32'b0; // Register 0 always reads as 0
    end
    else if (raddr1 == waddr && wen) begin
      rdata1 = regfile[raddr1]; // Return old data if waddr == raddr1
    end
    else begin
      rdata1 = regfile[raddr1]; // Normal read
    end
  end

endmodule

`endif /* REGFILE_Z_2R1W_32x32b_RTL */

