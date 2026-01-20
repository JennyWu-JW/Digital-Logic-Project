//========================================================================
// Proc-addi-test-cases
//========================================================================
// Used ChatGPT to generate directed test cases

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"   );
  asm( 'h004, "addi x2, x1, 2"   );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0004 ); // addi x2, x1, 2

endtask

//------------------------------------------------------------------------
// test_case_2_negative_immediate
//------------------------------------------------------------------------

task test_case_2_negative_immediate();
  t.test_case_begin("test_case_2_negative_immediate");

  // Write assembly program into memory
  asm('h000, "addi x3, x0, -5"   );
  asm('h004, "addi x4, x3, 10"   );
  asm('h008, "addi x5, x4, -3"   );
  asm('h00C, "addi x6, x5, 1"    );

  // Check each executed instruction
  check_trace('h000, 'hffff_fffb); // addi x3, x0, -5 (x3 should be -5)
  check_trace('h004, 'h0000_0005); // addi x4, x3, 10 (x4 should be 5)
  check_trace('h008, 'h0000_0002); // addi x5, x4, -3 (x5 should be 2)
 check_trace('h00C, 'h0000_0003); // addi x6, x5, 1 (x6 should be 3)
  
endtask

//------------------------------------------------------------------------
// test_case_3_large_immediate
//------------------------------------------------------------------------

task test_case_3_large_immediate();
  t.test_case_begin("test_case_3_large_immediate");

  // Write assembly program into memory with allowed immediate range
  asm('h000, "addi x5, x0, 2047"   ); // x5 = 0 + 2047
  asm('h004, "addi x6, x5, -2047"  ); // x6 = x5 - 2047
  asm('h008, "addi x7, x6, 1024"   ); // x7 = x6 + 1024
  asm('h00C, "addi x8, x7, -1024"  ); // x8 = x7 - 1024

  // Check each executed instruction
  check_trace('h000, 'h0000_07ff); // Expected value of x5 is 2047
  check_trace('h004, 'h0000_0000); // Expected value of x6 is 0
  check_trace('h008, 'h0000_0400); // Expected value of x7 is 1024
  check_trace('h00C, 'h0000_0000); // Expected value of x8 is 0
  
endtask

//------------------------------------------------------------------------
// test_case_4_zero_immediate
//------------------------------------------------------------------------

task test_case_4_zero_immediate();
  t.test_case_begin("test_case_4_zero_immediate");

  // Write assembly program into memory
  asm('h000, "addi x7, x0, 0"     );
  asm('h004, "addi x8, x7, 1234"  );
  asm('h008, "addi x9, x8, 0"     );
  asm('h00C, "addi x10, x9, -1234");

  // Check each executed instruction
  check_trace('h000, 'h0000_0000); // addi x7, x0, 0 (x7 should be 0)
  check_trace('h004, 'h0000_04d2); // addi x8, x7, 1234 (x8 should be 1234)
  check_trace('h008, 'h0000_04d2); // addi x9, x8, 0 (x9 should be 1234)
  check_trace('h00C, 'h0000_0000); // addi x10, x9, -1234 (x10 should be 0)
   
endtask

//------------------------------------------------------------------------
// test_case_5_chain_addi_instructions
//------------------------------------------------------------------------

task test_case_5_chain_addi_instructions();
  t.test_case_begin("test_case_5_chain_addi_instructions");

  // Write assembly program into memory
  asm('h000, "addi x9, x0, 1"     );
  asm('h004, "addi x10, x9, 2"    );
  asm('h008, "addi x11, x10, 3"   );
  asm('h00C, "addi x12, x11, 4"   );
  asm('h010, "addi x13, x12, 5"   );

  // Check each executed instruction
  check_trace('h000, 'h0000_0001); // addi x9, x0, 1 (x9 should be 1)
  check_trace('h004, 'h0000_0003); // addi x10, x9, 2 (x10 should be 3)
  check_trace('h008, 'h0000_0006); // addi x11, x10, 3 (x11 should be 6)
  check_trace('h00C, 'h0000_000A); // addi x12, x11, 4 (x12 should be 10)
  check_trace('h010, 'h0000_000F); // addi x13, x12, 5 (x13 should be 15)

endtask

