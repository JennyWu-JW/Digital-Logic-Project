//========================================================================
// DFF-test-cases
//========================================================================
// This file is meant to be included in a test bench.

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    clk d  q
  check( 0, 0, 1'bx );
  check( 1, 0,    0 );
  check( 0, 1,    0 );
  check( 1, 1,    1 );

endtask

//----------------------------------------------------------------------
// test_case_2_exhaustive
//----------------------------------------------------------------------

task test_case_2_exhaustive();
  t.test_case_begin( "test_case_2_exhaustive" );

  //    clk d  q
  check( 0, 0, 1'bx ); // q is unknown

  //---- rising clock edge here ---
  //    clk d  q
  check( 1, 0, 0 );
  check( 1, 1, 0 );
  check( 0, 0, 0 );
  check( 0, 1, 0 );

  //---- rising clock edge here ---
  //    clk d  q
  check( 1, 0, 1 );
  check( 1, 1, 1 );
  check( 0, 0, 1 );
  check( 0, 1, 1 );
  check( 0, 0, 1 );

  //---- rising clock edge here ---
  //    clk d  q
  check( 1, 0, 0 );

endtask

