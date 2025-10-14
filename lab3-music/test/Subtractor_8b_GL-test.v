//========================================================================
// Subtractor_8b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Subtractor_8b_GL.v"

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

  logic [7:0] dut_in0;
  logic [7:0] dut_in1;
  logic [7:0] dut_diff;

  Subtractor_8b_GL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .diff (dut_diff)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [7:0] in0,
    input logic [7:0] in1,
    input logic [7:0] diff
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b - %b (%4d - %4d) > %b (%4d)", t.cycles,
                  dut_in0, dut_in1,
                  $signed(dut_in0), $signed(dut_in1),
                  dut_diff, $signed(dut_diff) );
      end

      `ECE2300_CHECK_EQ( dut_diff, diff );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0           in1           diff
    check( 8'b0000_0000, 8'b0000_0000, 8'b0000_0000 );
    check( 8'b0000_0001, 8'b0000_0001, 8'b0000_0000 );
    check( 8'b0000_0010, 8'b0000_0001, 8'b0000_0001 );

  endtask

  task test_case_2_directed();
  t.test_case_begin( "test_case_2_directed" );

      //     in0           in1           diff
    check( 8'b0000_0100, 8'b0000_0011, 8'b0000_0001 ); // 4 - 3 = 1
    check( 8'b0000_1000, 8'b0000_0100, 8'b0000_0100 ); // 8 - 4 = 4
    check( 8'b0010_0000, 8'b0001_0000, 8'b0001_0000 ); // 32 - 16 = 16

  endtask

  logic [7:0] random_in0;
  logic [7:0] random_in1;
  logic [7:0] diff;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // for loop testing 50 cases 
    for ( int i = 0; i < 50; i = i+1 ) begin

    random_in0 = 8'($urandom(t.seed));
    random_in1 = 8'($urandom(t.seed));

    assign diff = random_in0 - random_in1;
    //     in0           in1      diff
    check(random_in0, random_in1, diff);
    end 
    
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();

    t.test_bench_end();
  end

endmodule
