//========================================================================
// NotePlayer-test-cases
//========================================================================
// This file is meant to be included in a test bench.
// Used ChatGPT to generate directed and random test cases

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //    rst      period    state note
  check( 0, 8'b00000101, 4'b0000,   0 );
  check( 0, 8'b00000101, 4'b1000,   1 ); // load
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000101
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000100
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000011
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000010
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000001
  check( 0, 8'b00000101, 4'b0100,   1 ); // count = 00000000
  check( 0, 8'b00000101, 4'b0010,   0 ); // load
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000101
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000100
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000011
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000010
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000001
  check( 0, 8'b00000101, 4'b0001,   0 ); // count = 00000000
  check( 0, 8'b00000101, 4'b1000,   1 );

endtask


task test_case_2_reset_behavior();
  t.test_case_begin( "test_case_2_reset_behavior" );

  // Apply reset and ensure FSM remains in RESET state
  //    rst      period    state  note
  check( 1, 8'b00000101, 4'b0000,   0 );  // Reset asserted, FSM in RESET
  check( 1, 8'b00000101, 4'b0000,   0 );  // Reset still asserted, state should still be RESET
  check( 1, 8'b00001000, 4'b0000,   0 );  // Reset asserted, period changes but still in RESET

  // Now, deassert reset and expect FSM to remain in RESET for one more cycle
  check( 0, 8'b00001000, 4'b0000,   0 );  // Deassert reset, FSM still in RESET for one cycle

  // In the next cycle, FSM should transition to LOAD_HIGH
  check( 0, 8'b00001000, 4'b1000,   1 );  // After the extra cycle, FSM moves to LOAD_HIGH
  check( 0, 8'b00001000, 4'b0100,   1 );  // FSM should now be in WAIT_HIGH

endtask

logic [7:0] random_period;

task test_case_3_random();
  t.test_case_begin( "test_case_3_random" );

  for (int i = 0; i < 20; i = i + 1) begin
    random_period = 8'($urandom(t.seed));  // Random period between 1 and 255

    // Apply reset and random period
    check( 1, random_period, 4'b0000, 0 );  // Reset asserted, FSM in RESET
    check( 1, random_period, 4'b0000, 0 );  // Reset asserted, FSM still in RESET

    // Deassert reset but FSM stays in RESET for one more cycle
    check( 0, random_period, 4'b0000, 0 );  // Reset deasserted, still in RESET for one cycle

    // After reset processing, FSM should move to LOAD_HIGH
    check( 0, random_period, 4'b1000, 1 );  // FSM transitions to LOAD_HIGH, note = 1
    check( 0, random_period, 4'b0100, 1 );  // FSM moves to WAIT_HIGH, note = 1, count starts

    // Period changes but FSM should still be in WAIT_HIGH for this cycle
    check( 1, random_period, 4'b0100, 1 );  // FSM still in WAIT_HIGH, note = 1, ignoring period change
  end

endtask


