//========================================================================
// Register_8b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Register_8b_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic reset;

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic       dut_rst;
  logic       dut_en;
  logic [7:0] dut_d;
  logic [7:0] dut_q;

  Register_8b_GL register
  (
    .clk (clk),
    .rst (reset || dut_rst),
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
    input logic       rst,
    input logic       en,
    input logic [7:0] d,
    input logic [7:0] q
  );
    if ( !t.failed ) begin

      dut_rst = rst;
      dut_en  = en;
      dut_d   = d;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b > %b", t.cycles,
                  dut_rst, dut_en, dut_d, dut_q );
      end

      `ECE2300_CHECK_EQ( dut_q, q );

      #2;

    end
  endtask

  `include "Register_8b-test-cases.v"

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_ones();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_values();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_enable();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_directed_reset();

    t.test_bench_end();
  end

endmodule

