//========================================================================
// Proc-lw-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "lw   x2, 0(x1)"     );

  // Write data into memory

  data( 'h100, 'hdead_beef );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 'hdead_beef ); // lw   x2, 0(x1)

endtask

// AI was used for test case 
task test_case_2_positive_offset();
  t.test_case_begin("test_case_2_positive_offset");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x100" ); // Load base address 0x100 into x1
  asm('h004, "lw   x2, 4(x1)"     ); // Load word at 0x104 into x2

  // Write data into memory
  data('h100, 32'h00000000 );
  data('h104, 32'h12345678 ); // Data at offset 4

  // Check each executed instruction
  check_trace('h000, 'h0000_0100); // addi x1, x0, 0x100
  check_trace('h004, 'h12345678);  // lw x2, 4(x1)

endtask

// AI was used for test case 
task test_case_3_negative_offset();
  t.test_case_begin("test_case_3_negative_offset");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x108" ); // Load base address 0x108 into x1
  asm('h004, "lw   x2, -4(x1)"    ); // Load word at 0x104 into x2

  // Write data into memory
  data('h104, 32'habcdef12 ); // Data at offset -4

  // Check each executed instruction
  check_trace('h000, 'h0000_0108); // addi x1, x0, 0x108
  check_trace('h004, 'habcdef12);  // lw x2, -4(x1)

endtask

// AI was used for test case 
task test_case_4_aligned_address();
  t.test_case_begin("test_case_4_aligned_address");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x200" ); // Load base address 0x200 into x1
  asm('h004, "lw   x2, 0(x1)"     ); // Load word at 0x200 into x2

  // Write data into memory
  data('h200, 32'hcafebabe ); // Data at aligned address 0x200

  // Check each executed instruction
  check_trace('h000, 'h0000_0200); // addi x1, x0, 0x200
  check_trace('h004, 'hcafebabe);  // lw x2, 0(x1)

endtask

// AI was used for test case 
task test_case_5_unaligned_address();
  t.test_case_begin("test_case_5_unaligned_address");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x202" ); // Load base address 0x202 into x1
  asm('h004, "lw   x2, 0(x1)"     ); // Load word at 0x202 into x2

  // Write data into memory
  data('h202, 32'h87654321 ); // Data at unaligned address 0x202

  // Check each executed instruction
  check_trace('h000, 'h0000_0202); // addi x1, x0, 0x202
  check_trace('h004, 'h87654321);  // lw x2, 0(x1)

endtask

// AI was used for test case 
task test_case_6_max_positive_offset();
  t.test_case_begin("test_case_6_max_positive_offset");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x100"   ); // Load base address 0x100 into x1
  asm('h004, "lw   x2, 0x7ff(x1)"   ); // Load word at 0x8ff into x2

  // Write data into memory
  data('h8ff, 32'h13579bdf ); // Data at max positive offset

  // Check each executed instruction
  check_trace('h000, 'h0000_0100); // addi x1, x0, 0x100
  check_trace('h004, 'h13579bdf);  // lw x2, 0x7ff(x1)

endtask
