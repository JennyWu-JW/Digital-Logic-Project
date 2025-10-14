//========================================================================
// AccumXcel
//========================================================================

`ifndef ACCUM_XCEL_V
`define ACCUM_XCEL_V

`include "AccumXcelDpath.v"
`include "AccumXcelCtrl.v"

module AccumXcel
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  (* keep=1 *) input  logic        go,
  (* keep=1 *) input  logic [13:0] size,

  (* keep=1 *) output logic        result_val,
  (* keep=1 *) output logic [31:0] result,

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data
);

  logic load_done;

  // Instantiate/Connect Datapath and Control Unit

  AccumXcelCtrl ctrl
  (
    .*
  );

  AccumXcelDpath dpath
  (
    .*
  );

endmodule

`endif /* ACCUM_XCEL_V */

