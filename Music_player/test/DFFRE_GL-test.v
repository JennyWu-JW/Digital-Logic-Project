//========================================================================
// DFFRE_GL-test
//========================================================================

`include "ece2300-test.v"
`include "DFFRE_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic dut_clk;
  logic dut_rst;
  logic dut_en;
  logic dut_d;
  logic dut_q;

  DFFRE_GL dffre
  (
    .clk (dut_clk),
    .rst (dut_rst),
    .en  (dut_en),
    .d   (dut_d),
    .q   (dut_q)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic _clk,
    input logic rst,
    input logic en,
    input logic d,
    input logic q
  );
    if ( !t.failed ) begin

      dut_clk = _clk;

      #1;

      dut_rst = rst;
      dut_en  = en;
      dut_d   = d;

      #7;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b %b > %b", t.cycles,
                  dut_clk, dut_rst, dut_en, dut_d, dut_q );
      end

      `ECE2300_CHECK_EQ( dut_q, q );

      #2;

    end
  endtask

  `include "DFFRE-test-cases.v"

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_reset();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_en1();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_en0();

    t.test_bench_end();
  end

endmodule

