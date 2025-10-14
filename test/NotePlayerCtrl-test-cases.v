//========================================================================
// NotePlayerCtrl-test-cases
//========================================================================
// This file is meant to be included in a test bench.
// Used ChatGPT to generate directed test cases

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    rst done    state  note  load
  check( 0,    0, 4'b0000,    0,    0 );
  check( 0,    0, 4'b1000,    1,    1 );
  check( 0,    0, 4'b0100,    1,    0 );
  check( 0,    0, 4'b0100,    1,    0 );
  check( 0,    1, 4'b0100,    1,    0 );
  check( 0,    1, 4'b0010,    0,    1 );
  check( 0,    0, 4'b0001,    0,    0 );
  check( 0,    0, 4'b0001,    0,    0 );
  check( 0,    0, 4'b0001,    0,    0 );
  check( 0,    0, 4'b0001,    0,    0 );
  check( 0,    1, 4'b0001,    0,    0 );
  check( 0,    0, 4'b1000,    1,    1 );

endtask

//----------------------------------------------------------------------
// test_case_2_reset
//----------------------------------------------------------------------

task test_case_2_reset();
  t.test_case_begin( "test_case_2_reset" );

  // Test the reset functionality
  // When reset is active, the state should always return to RESET (4'b0000)

  //    rst done    state  note  load
  check( 1,    0, 4'b0000,    0,    0 );  // Reset active
  check( 1,    0, 4'b0000,    0,    0 );  // Keep reset active, check if the state is reset
  check( 1,    1, 4'b0000,    0,    0 );  // Keep reset active with count_done, ensure state is still reset
  check( 0,    0, 4'b0000,    0,    0 );
  check( 0,    0, 4'b1000,    1,    1 );  // Deassert reset, FSM should move to LOAD_HIGH

endtask

//----------------------------------------------------------------------
// test_case_3_done_signal
//----------------------------------------------------------------------

task test_case_3_done_signal();
  t.test_case_begin( "test_case_3_done_signal" );

  // Test the behavior when done signal becomes 1
  //    rst done    state  note  load
  check( 0,    0, 4'b0000,    0,    0 );  // Initially in RESET
  check( 0,    0, 4'b1000,    1,    1 );  // LOAD_HIGH, note = 1, load = 1
  check( 0,    0, 4'b0100,    1,    0 );  // WAIT_HIGH, waiting for count_done
  check( 0,    1, 4'b0100,    1,    0 );  // done signal = 1, but still in WAIT_HIGH
  check( 0,    1, 4'b0010,    0,    1 );  // Transition to LOAD_LOW
  check( 0,    0, 4'b0001,    0,    0 );  // WAIT_LOW state
  check( 0,    1, 4'b0001,    0,    0 );  // done signal = 1, should move back to LOAD_HIGH

endtask

//----------------------------------------------------------------------
// test_case_4_full_cycle
//----------------------------------------------------------------------

task test_case_4_full_cycle();
  t.test_case_begin( "test_case_4_full_cycle" );

  // A full cycle from reset through all states

  //    rst done    state  note  load
  check( 0,    0, 4'b0000,    0,    0 );  // Initially in RESET
  check( 0,    0, 4'b1000,    1,    1 );  // LOAD_HIGH, note = 1, load = 1
  check( 0,    0, 4'b0100,    1,    0 );  // WAIT_HIGH, waiting for count_done
  check( 0,    1, 4'b0100,    1,    0 );  // done signal = 1, move to LOAD_LOW
  check( 0,    1, 4'b0010,    0,    1 );  // LOAD_LOW, note = 0, load = 1
  check( 0,    0, 4'b0001,    0,    0 );  // WAIT_LOW, waiting for count_done
  check( 0,    1, 4'b0001,    0,    0 );  // done signal = 1, move back to LOAD_HIGH
  check( 0,    0, 4'b1000,    1,    1 );  // Back to LOAD_HIGH, full cycle complete

endtask

