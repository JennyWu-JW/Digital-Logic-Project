//========================================================================
// Counter_8b-test-cases
//========================================================================
// This file is meant to be included in a test bench.
// Used ChatGPT to generate directed and random test cases

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    rst ld in           count         done
  check( 0, 0, 8'b0000_0000, 8'b0000_0000, 1 );
  check( 0, 1, 8'b0000_0011, 8'b0000_0000, 1 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0011, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0010, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0001, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0000, 1 );

endtask

//----------------------------------------------------------------------
// test_case_2_directed_small
//----------------------------------------------------------------------

task test_case_2_directed_small();
  t.test_case_begin( "test_case_2_directed_small" );

  // Load counter with 5
  //    rst ld in count done
  check( 0, 1, 5, 0, 1 );
  for ( int i = 5; i > 0; i = i-1 )
    check( 0, 0, 0, 8'(i), 0 );
  check( 0, 0, 0, 0, 1 );

  // Check count down from 10
  //   rst ld in count done
  check( 0, 1, 10, 0, 1 );
  for ( int i = 10; i > 0; i = i-1 )
    check( 0, 0, 0, 8'(i), 0 );
  check( 0, 0, 0, 0, 1 );

  // Check count down from 16
  //   rst ld in count done
  check( 0, 1, 16, 0, 1 );
  for ( int i = 16; i > 0; i = i-1 )
    //   rst ld in count done
    check( 0, 0, 0, 8'(i), 0 );
  //   rst ld in count done
  check( 0, 0, 0, 0, 1 );

endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_max
  //----------------------------------------------------------------------

task test_case_3_directed_max();
  t.test_case_begin( "test_case_3_directed_max" );

  // Load counter with maximum value
  //    rst ld in           count         done
  check( 0, 1, 8'b0111_1111, 8'b0000_0000, 1 );

  // Count down from 127
  for ( int i = 127; i > 0; i = i-1 )
  //    rst ld in              count done
    check( 0, 0, 8'b0000_0000, 8'(i), 0 );

  // Check when reaching zero
    //    rst ld in           count       done
  check( 0, 0, 8'b0000_0000, 8'b0000_0000, 1 );

endtask

  //----------------------------------------------------------------------
  // test_case_4_directed_consecutive_loads
  //----------------------------------------------------------------------

task test_case_4_directed_consecutive_loads();
  t.test_case_begin( "test_case_4_directed_consecutive_loads" );

  // Load the counter with 5
  //    rst ld in           count         done
  check( 0, 1, 8'b0000_0101, 8'b0000_0000, 1 );

  // Start counting down
  //    rst ld in           count         done
  check( 0, 0, 8'b0000_0000, 8'b0000_0101, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0100, 0 );

  // Before reaching zero, load a new value (4)
  //    rst ld in           count         done
  check( 0, 1, 8'b0000_0100, 8'b0000_0011, 0 );

  // Count down from the new value (4)
  //    rst ld in           count         done
  check( 0, 0, 8'b0000_0000, 8'b0000_0100, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0011, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0010, 0 );
  check( 0, 0, 8'b0000_0000, 8'b0000_0001, 0 );
  
  // Verify done signal when the count reaches zero
  //    rst ld in           count         done
  check( 0, 0, 8'b0000_0000, 8'b0000_0000, 1 );

endtask

