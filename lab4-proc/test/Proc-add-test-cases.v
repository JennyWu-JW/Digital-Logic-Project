//========================================================================
// Proc-add-test-cases
//========================================================================
// Used ChatGPT to generate directed test cases

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "add  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0003 ); // addi x1, x0, 3
  check_trace( 'h008, 'h0000_0005 ); // add  x3, x1, x2

endtask

//------------------------------------------------------------------------
// test_case_2_zero_addition
//------------------------------------------------------------------------

task test_case_2_zero_addition();
  t.test_case_begin( "test_case_2_zero_addition" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0"  );
  asm( 'h004, "addi x2, x0, 5"  );
  asm( 'h008, "add  x3, x1, x2" );
  asm( 'h00c, "add  x4, x3, x1" ); // additional add with zero

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0000 ); // addi x1, x0, 0
  check_trace( 'h004, 'h0000_0005 ); // addi x2, x0, 5
  check_trace( 'h008, 'h0000_0005 ); // add  x3, x1, x2
  check_trace( 'h00c, 'h0000_0005 ); // add  x4, x3, x1

endtask

//------------------------------------------------------------------------
// test_case_3_negative_addition
//------------------------------------------------------------------------

task test_case_3_negative_addition();
  t.test_case_begin( "test_case_3_negative_addition" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, -3" );
  asm( 'h004, "addi x2, x0, 7"  );
  asm( 'h008, "add  x3, x1, x2" );
  asm( 'h00c, "add  x4, x3, x2" ); // additional add with positive value

  // Check each executed instruction

  check_trace( 'h000, 'hffff_fffd ); // addi x1, x0, -3
  check_trace( 'h004, 'h0000_0007 ); // addi x2, x0, 7
  check_trace( 'h008, 'h0000_0004 ); // add  x3, x1, x2
  check_trace( 'h00c, 'h0000_000b ); // add  x4, x3, x2

endtask

//------------------------------------------------------------------------
// test_case_4_mixed_values
//------------------------------------------------------------------------

task test_case_4_mixed_values();
  t.test_case_begin( "test_case_4_mixed_values" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 15"   ); // Initialize x1 with 15
  asm( 'h004, "addi x2, x0, -5"   ); // Initialize x2 with -5
  asm( 'h008, "add  x3, x1, x2"   ); // Add x1 and x2 (15 + -5)
  asm( 'h00c, "addi x4, x0, 10"   ); // Initialize x4 with 10
  asm( 'h010, "add  x5, x3, x4"   ); // Add x3 and x4 (10 + result of x3)

  // Check each executed instruction

  check_trace( 'h000, 'h0000_000f ); // addi x1, x0, 15
  check_trace( 'h004, 'hffff_fffb ); // addi x2, x0, -5
  check_trace( 'h008, 'h0000_000a ); // add  x3, x1, x2 (15 + -5 = 10)
  check_trace( 'h00c, 'h0000_000a ); // addi x4, x0, 10
  check_trace( 'h010, 'h0000_0014 ); // add  x5, x3, x4 (10 + 10 = 20)

endtask

//------------------------------------------------------------------------
// test_case_5_same_registers
//------------------------------------------------------------------------

task test_case_5_same_registers();
  t.test_case_begin( "test_case_5_same_registers" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 4"  );
  asm( 'h004, "add  x1, x1, x1" );
  asm( 'h008, "add  x2, x1, x1" ); // additional add with the same register

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0004 ); // addi x1, x0, 4
  check_trace( 'h004, 'h0000_0008 ); // add  x1, x1, x1
  check_trace( 'h008, 'h0000_0010 ); // add  x2, x1, x1

endtask

