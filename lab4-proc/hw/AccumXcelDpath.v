//========================================================================
// AccumXcelDpath
//========================================================================

`ifndef ACCUM_XCEL_DPATH_V
`define ACCUM_XCEL_DPATH_V

`include "Register_RTL.v"
`include "Adder_32b_GL.v"
`include "Mux2_RTL.v"

module AccumXcelDpath
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // I/O Interface

  (* keep=1 *) output logic [31:0] result,

  // Memory Interface

  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data,

  // Control signal for when the array is full

  (* keep=1 *) input  logic        load_done,

  // Control signal for when memory is accessed
  (* keep=1 *) input  logic        memreq_val
);

  // Accumulator
  logic [31:0] sum, sum_next, sum_accum, result_next;

  // Register for updating sum, only enabled while still loading
  Register_RTL #(32) sum_reg(
    .clk(clk),
    .rst(rst),
    .en(~load_done),
    .d(sum_next),
    .q(sum)
  );

  // Adding value from memory to sum
  Adder_32b_GL adder_accum(
    .in0(sum),
    .in1(memresp_data),
    .sum(sum_accum)
  );

  // Mux for sum, when reading (select between 0 and accumulated sum)
  Mux2_RTL #(32) if_accumulating(
    .in0(32'b0),
    .in1(sum_accum),
    .sel(memreq_val),
    .out(sum_next)
  );

  // Mux to keep returning sum if there is no reset
  Mux2_RTL #(32) done_value(
    .in0(32'b0),
    .in1(sum),
    .sel(load_done),
    .out(result_next)
  );

  // Register for result output
  Register_RTL #(32) result_reg(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(result_next),
    .q(result)
  );

  // Register for memory address
  logic [31:0] mem_addr;
  logic [15:0] mem_addr_next;
  logic [15:0] unused_mem_addr;
  assign unused_mem_addr = mem_addr[31:16];

  Register_RTL #(16) mem_addr_reg(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(mem_addr_next),
    .q(memreq_addr)
  );

  // Increment by 4 to get to next memory address with value
  Adder_32b_GL adder_addr(
    .in0({16'b0, memreq_addr}),
    .in1(32'd4),
    .sum(mem_addr)
  );

  // Mux to select correct address, depending on memreq_val (whether to get next address)
  Mux2_RTL #(16) load_status(
    .in0(memreq_addr),
    .in1(mem_addr[15:0]),
    .sel(memreq_val),
    .out(mem_addr_next)
  );

endmodule

`endif /* ACCUM_XCEL_DPATH_V */

