//========================================================================
// DFFRE-test-cases
//========================================================================
// This file is meant to be included in a test bench.

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    clk rst  en d   q
  check( 0, 1,  1,  0,  1'bx );
  check( 1, 1,  1,  0,  0 );
  check( 0, 0,  1,  0,  0 );
  check( 1, 0,  1,  0,  0 );
  check( 0, 0,  1,  0,  0 );

endtask

//----------------------------------------------------------------------
// test_case_2_directed_reset
//----------------------------------------------------------------------

task test_case_2_directed_reset();
  t.test_case_begin( "test_case_2_directed_reset" );
  //    clk rs en d  q
  check( 0, 1, 1, 0, 1'bx );

  // ---- rising clock edge here ---

  check( 1, 1, 0, 0, 0 ); // every en,d when clk=1, rst=1
  check( 1, 1, 0, 1, 0 );
  check( 1, 1, 1, 0, 0 );
  check( 1, 1, 1, 1, 0 );

  check( 0, 1, 0, 0, 0 ); // every en,d when clk=0, rst=1
  check( 0, 1, 0, 1, 0 );
  check( 0, 1, 1, 0, 0 );
  check( 0, 1, 1, 1, 0 );

  // ---- rising clock edge here ---

  check( 1, 0, 0, 0, 0 );

  //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

endtask

//----------------------------------------------------------------------
// test_case_3_directed_en1
//----------------------------------------------------------------------

task test_case_3_directed_en1();
  t.test_case_begin( "test_case_3_directed_en1" );
  //    clk rs en d  q
  check( 0, 1, 0, 0, 1'bx ); // reset sequence
  check( 1, 0, 0, 0, 0 );

  // ---- rising clock edge here ---

  check( 1, 0, 1, 0, 0 ); // d=0, clk=1, ff is storing 0
  check( 1, 0, 1, 1, 0 ); // d=1, clk=1, ff is storing 0
  check( 0, 0, 1, 0, 0 ); // d=0, clk=0, ff is storing 0
  check( 0, 0, 1, 1, 0 ); // d=1, clk=0, ff is storing 0

  // ---- rising clock edge here ---

  check( 1, 0, 1, 0, 1 ); // d=0, clk=1, ff is storing 1
  check( 1, 0, 1, 1, 1 ); // d=1, clk=1, ff is storing 1
  check( 0, 0, 1, 0, 1 ); // d=0, clk=0, ff is storing 1
  check( 0, 0, 1, 1, 1 ); // d=1, clk=0, ff is storing 1
  check( 0, 0, 1, 0, 1 );

  // ---- rising clock edge here ---

  check( 1, 0, 1, 0, 0 ); // return to original state

endtask

//----------------------------------------------------------------------
// test_case_4_directed_en0
//----------------------------------------------------------------------

task test_case_4_directed_en0();
  t.test_case_begin( "test_case_4_directed_en0" );
//    clk rs en d  q
  check( 0, 1, 0, 0, 1'bx ); // reset sequence
  check( 1, 0, 0, 0, 0 );

  // ---- rising clock edge here ---

  check( 1, 0, 0, 0, 0 ); // d=0, clk=1, ff is storing 0
  check( 1, 0, 0, 1, 0 ); // d=1, clk=1, ff is storing 0
  check( 0, 0, 0, 0, 0 ); // d=0, clk=0, ff is storing 0
  check( 0, 0, 0, 1, 0 ); // d=1, clk=0, ff is storing 0

  // ---- rising clock edge here ---

  check( 1, 0, 0, 0, 0 ); // d=0, clk=1, ff is storing 0
  check( 1, 0, 0, 1, 0 ); // d=1, clk=1, ff is storing 0
  check( 0, 0, 0, 0, 0 ); // d=0, clk=0, ff is storing 0
  check( 0, 0, 0, 1, 0 ); // d=1, clk=0, ff is storing 0
  check( 0, 0, 0, 0, 0 );

  // ---- rising clock edge here ---

  check( 1, 0, 0, 0, 0 ); // return to original state

endtask

