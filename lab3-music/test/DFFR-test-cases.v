//========================================================================
// DFFR-test-cases
//========================================================================
// This file is meant to be included in a test bench.

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    clk rs d  q
  check( 0, 1, 0, 1'bx );
  check( 1, 1, 0, 0 );
  check( 0, 0, 0, 0 );
  check( 1, 0, 0, 0 );

endtask

//----------------------------------------------------------------------
// test_case_2_directed_reset
//----------------------------------------------------------------------

task test_case_2_directed_reset();
  t.test_case_begin( "test_case_2_directed_reset" );

  //    clk rs d  q
  check( 0, 1, 0, 1'bx );

  // ---- rising clock edge here ---

  check( 1, 1, 0, 0 );
  check( 1, 1, 1, 0 );
  check( 0, 1, 0, 0 );
  check( 0, 1, 1, 0 );

  // ---- rising clock edge here ---

  check( 1, 0, 0, 0 );

endtask

//----------------------------------------------------------------------
// test_case_3_directed
//----------------------------------------------------------------------

task test_case_3_directed();
  t.test_case_begin( "test_case_3_directed" );

  //    clk rs d  q
  check( 0, 1, 0, 1'bx ); // reset sequence
  check( 1, 0, 0, 0 );

  // ---- rising clock edge here ---
  //    clk rs d  q
  check( 1, 0, 0, 0 );
  check( 1, 0, 1, 0 );
  check( 0, 0, 0, 0 );
  check( 0, 0, 1, 0 );

  // ---- rising clock edge here ---
  //    clk rs d  q
  check( 1, 0, 0, 1 );
  check( 1, 0, 1, 1 );
  check( 0, 0, 0, 1 );
  check( 0, 0, 1, 1 );
  check( 0, 0, 0, 1 );

  // ---- rising clock edge here ---
  //    clk rs d  q
  check( 1, 0, 0, 0 );

endtask

