//========================================================================
// ClockDiv_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "ClockDiv_RTL.v"

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

  logic dut_rst;
  logic dut_clk_out;

  ClockDiv_RTL clock_div
  (
    .clk_in  (clk),
    .rst     (reset || dut_rst),
    .clk_out (dut_clk_out)
  );

  // verilator lint_off DEFPARAM
  defparam clock_div.p_factor = 2;
  // verilator lint_on DEFPARAM

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  task check
  (
    input logic rst,
    input logic clk_out
  );
    if ( !t.failed ) begin

      dut_rst = rst;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b > %b", t.cycles,
                  dut_rst, dut_clk_out );
      end

      `ECE2300_CHECK_EQ( dut_clk_out, clk_out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    rst  clk_out
    check( 1,    1'bx );
    check( 0,       0 );
    check( 0,       0 );
    check( 0,       0 );
    check( 0,       0 );
    check( 0,       1 );
    check( 0,       1 );
    check( 0,       1 );
    check( 0,       1 );
    check( 0,       0 );

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    t.test_bench_end();
  end

endmodule

