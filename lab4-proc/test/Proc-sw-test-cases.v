//========================================================================
// Proc-sw-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" );
  asm( 'h004, "addi x2, x0, 0x42"  );
  asm( 'h008, "sw   x2, 0(x1)"     );
  asm( 'h00c, "lw   x3, 0(x1)"     );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 'h0000_0042 ); // addi x1, x0, 0x42
  check_trace( 'h008, 'x          ); // sw   x2, 0(x1)
  check_trace( 'h00c, 'h0000_0042 ); // lw   x3, 0(x1)

endtask

// AI was used for this test case 
task test_case_2_positive_offset();
  t.test_case_begin("test_case_2_positive_offset");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x100" ); // Load base address 0x100 into x1
  asm('h004, "addi x2, x0, 0x55"  ); // Load value 0x55 into x2
  asm('h008, "sw   x2, 4(x1)"     ); // Store x2 at 0x104 (base + offset 4)
  asm('h00c, "lw   x3, 4(x1)"     ); // Load from 0x104 to confirm store

  // Check each executed instruction
  check_trace('h000, 'h0000_0100); // addi x1, x0, 0x100
  check_trace('h004, 'h0000_0055); // addi x2, x0, 0x55
  check_trace('h008, 'x          ); // sw   x2, 4(x1)
  check_trace('h00c, 'h0000_0055); // lw   x3, 4(x1)

endtask

// AI was used for this test case
task test_case_3_negative_offset();
  t.test_case_begin("test_case_3_negative_offset");

  // Write assembly program into memory
  asm('h000, "addi x1, x0, 0x108" ); // Load base address 0x108 into x1
  asm('h004, "addi x2, x0, 0x77"  ); // Load value 0x77 into x2
  asm('h008, "sw   x2, -4(x1)"    ); // Store x2 at 0x104 (base - offset 4)
  asm('h00c, "lw   x3, -4(x1)"    ); // Load from 0x104 to confirm store

  // Check each executed instruction
  check_trace('h000, 'h0000_0108); // addi x1, x0, 0x108
  check_trace('h004, 'h0000_0077); // addi x2, x0, 0x77
  check_trace('h008, 'x          ); // sw   x2, -4(x1)
  check_trace('h00c, 'h0000_0077); // lw   x3, -4(x1)

endtask

// AI was use for this test case
task test_case_4_sw_consecutive();
  t.test_case_begin( "test_case_4_sw_consecutive" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0x100" ); // Set x1 to 0x100 as the base address (within range)
  asm( 'h004, "addi x2, x0, 0x123"  ); // Set x2 to 0x123 (within range for addi)
  asm( 'h008, "addi x4, x0, 0x456"  ); // Set x4 to 0x456 (within range for addi)
  asm( 'h00c, "sw   x2, 0(x1)"      ); // Store x2 at address 0x100
  asm( 'h010, "sw   x4, 4(x1)"      ); // Store x4 at address 0x104
  asm( 'h014, "lw   x3, 0(x1)"      ); // Load from 0x100 into x3
  asm( 'h018, "lw   x5, 4(x1)"      ); // Load from 0x104 into x5

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0100 ); // addi x1, x0, 0x100
  check_trace( 'h004, 'h0000_0123 ); // addi x2, x0, 0x123
  check_trace( 'h008, 'h0000_0456 ); // addi x4, x0, 0x456
  check_trace( 'h00c, 'x          ); // sw   x2, 0(x1)
  check_trace( 'h010, 'x          ); // sw   x4, 4(x1)
  check_trace( 'h014, 'h0000_0123 ); // lw   x3, 0(x1)
  check_trace( 'h018, 'h0000_0456 ); // lw   x5, 4(x1)

endtask


