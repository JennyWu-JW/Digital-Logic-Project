//========================================================================
// Proc-jr-test-cases
//========================================================================
// Used ChatGPT to generate directed test cases

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x00c" );
  asm( 'h004, "jr   x1" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_000c ); // addi x1, x0, 0x00c
  check_trace( 'h004, 'x          ); // jr   x1
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

//------------------------------------------------------------------------
// test_case_2_jump_to_middle
//------------------------------------------------------------------------

task test_case_2_jump_to_middle();
  t.test_case_begin( "test_case_2_jump_to_middle" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x008" ); // Set x1 to 0x008
  asm( 'h004, "jr   x1"            ); // Jump to 0x008
  asm( 'h008, "addi x2, x0, 4"     ); // Execute at 0x008
  asm( 'h00c, "addi x3, x0, 5"     ); // Follow-up instruction

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0008 ); // addi x1, x0, 0x008
  check_trace( 'h004, 'x          ); // jr   x1
  check_trace( 'h008, 'h0000_0004 ); // addi x2, x0, 4
  check_trace( 'h00c, 'h0000_0005 ); // addi x3, x0, 5

endtask

//------------------------------------------------------------------------
// test_case_3_jump_to_start
//------------------------------------------------------------------------

task test_case_3_jump_to_start();
  t.test_case_begin( "test_case_3_jump_to_start" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x000" ); // Set x1 to 0x000
  asm( 'h004, "addi x2, x0, 5"     );
  asm( 'h008, "jr   x1"            ); // Jump to 0x000
  asm( 'h00c, "addi x3, x0, 3"     );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0000 ); // addi x1, x0, 0x000
  check_trace( 'h004, 'h0000_0005 ); // addi x2, x0, 5
  check_trace( 'h008, 'x          ); // jr   x1
  check_trace( 'h000, 'h0000_0000 ); // addi x1, x0, 0x000 (re-executed after jump)

endtask

//------------------------------------------------------------------------
// test_case_4_jump_to_self
//------------------------------------------------------------------------

task test_case_4_jump_to_self();
  t.test_case_begin( "test_case_4_jump_to_self" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x004" ); // Set x1 to 0x004
  asm( 'h004, "jr   x1"            ); // Jump to 0x004 (self-loop)

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0004 ); // addi x1, x0, 0x004
  check_trace( 'h004, 'x          ); // jr   x1 (loop)

endtask

//------------------------------------------------------------------------
// test_case_5_jump_forward
//------------------------------------------------------------------------

task test_case_5_jump_forward();
  t.test_case_begin( "test_case_5_jump_forward" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x00c" ); // Set x1 to 0x00c
  asm( 'h004, "jr   x1"            ); // Jump to 0x00c
  asm( 'h008, "addi x2, x0, 7"     ); // Skipped
  asm( 'h00c, "addi x3, x0, 9"     ); // Execute after jump

  // Check each executed instruction

  check_trace( 'h000, 'h0000_000c ); // addi x1, x0, 0x00c
  check_trace( 'h004, 'x          ); // jr   x1
  check_trace( 'h00c, 'h0000_0009 ); // addi x3, x0, 9

endtask

