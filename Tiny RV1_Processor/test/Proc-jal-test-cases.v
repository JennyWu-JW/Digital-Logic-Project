//========================================================================
// Proc-jal-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "jal  x2, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0008 ); // jal  x2, 0x00c
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

// ALu 
task test_case_2_max_positive_offset();
  t.test_case_begin("test_case_2_max_positive_offset");

  asm('h000, "addi x1, x0, 1");
  asm('h004, "jal  x2, 0x014");  // Jump to maximum positive offset
  asm('h008, "addi x1, x0, 2");
  asm('h014, "addi x1, x0, 3");

  check_trace('h000, 'h0000_0001);
  check_trace('h004, 'h0000_0008);
  check_trace('h014, 'h0000_0003);
endtask

// AI was used for this test case
task test_case_3_jump_to_x0();
  t.test_case_begin("test_case_3_jump_to_x0");

  asm('h000, "addi x1, x0, 1");
  asm('h004, "jal  x0, 0x00c");  // Jump but don't store return address
  asm('h008, "addi x1, x0, 2");
  asm('h00c, "addi x1, x0, 3");

  check_trace('h000, 'h0000_0001);
  check_trace('h004, 'x         );  // x0 should remain 0
  check_trace('h00c, 'h0000_0003);
endtask

// AI was used for this test case
task test_case_4_jump_backwards();
  t.test_case_begin("test_case_4_jump_backwards");

  asm('h000, "addi x1, x0, 1");
  asm('h004, "jal  x2, 0x010");
  asm('h008, "addi x1, x0, 2");
  asm('h00c, "addi x1, x0, 3");
  asm('h010, "jal  x3, -0x010");  // Jump back to the beginning
  asm('h014, "addi x1, x0, 4");

  check_trace('h000, 'h0000_0001);
  check_trace('h004, 'h0000_0008);
  check_trace('h010, 'h0000_0014);
  check_trace('h000, 'h0000_0001);
endtask
