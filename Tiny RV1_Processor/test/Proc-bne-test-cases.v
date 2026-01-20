//========================================================================
// Proc-bne-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "bne  x1, x0, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'x          ); // bne  x1, x0, 0x00c
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask

task test_case_2_equal();
  t.test_case_begin( "test_case_2_equal" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" );
  asm( 'h004, "addi x2, x0, 1" );
  asm( 'h008, "bne  x1, x2, 0x010" );
  asm( 'h00c, "addi x1, x0, 2" );
  asm( 'h010, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0001 ); // addi x2, x0, 1
  check_trace( 'h008, 'x ); // bne  x1, x2, 0x010
  check_trace( 'h00c, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h010, 'h0000_0003 ); // addi x1, x0, 3

endtask

task test_case_3_negative();
  t.test_case_begin( "test_case_3_negative" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, -1" ); // assign -1 
  asm( 'h004, "addi x2, x0, -1" ); // asign -1 
  asm( 'h008, "bne  x0, x1, 0x010" ); // 0 = -1

  asm( 'h00c, "addi x1, x0, 5" ); // no execute 
  asm( 'h010, "bne  x1, x2, 0x008" );// -1 = -1
  asm( 'h014, "addi x1, x0, 2" ); // execute

  // Check each executed instruction

  check_trace( 'h000, 'hFFFFFFFF ); // addi x1, x0, -1
  check_trace( 'h004, 'hFFFFFFFF ); // addi x2, x0, -1
  check_trace( 'h008, 'x ); // bne  x1, x2, 0x010 (0 = -1)

  check_trace( 'h010, 'x ); // bne  x1, x2, 0x010 (-1 = -1)
  check_trace( 'h014, 'h0000_0002 ); // addi x1, x0, 2

endtask

task test_case_4_large_values();
  t.test_case_begin( "test_case_4_large_values" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2000" ); // assign  
  asm( 'h004, "addi x2, x0, 2000" ); // asign -1 
  asm( 'h008, "bne  x0, x1, 0x010" ); // 0 = 2000

  asm( 'h00c, "addi x1, x0, 5" ); // no execute 
  asm( 'h010, "bne  x1, x2, 0x008" );// 2000 = 2000
  asm( 'h014, "addi x1, x0, 2" ); // execute

  // Check each executed instruction

  check_trace( 'h000, 'h7D0 ); // addi x1, x0, 2000
  check_trace( 'h004, 'h7D0 ); // addi x2, x0, 2000
  check_trace( 'h008, 'x ); // bne  x1, x2, 0x010 (0 = 2000)

  check_trace( 'h010, 'x ); // bne  x1, x2, 0x010 (2000 = 2000)
  check_trace( 'h014, 'h0000_0002 ); // addi x1, x0, 2

endtask

task test_case_5_zeros();
  t.test_case_begin( "test_case_5_zeros" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 0" );
  asm( 'h004, "bne  x1, x0, 0x00c" );
  asm( 'h008, "addi x1, x0, 2" );
  asm( 'h00c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0000 ); // addi x1, x0, 1
  check_trace( 'h004, 'x          ); // bne  x1, x0, 0x00c
  check_trace( 'h008, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h00c, 'h0000_0003 ); // addi x1, x0, 3

endtask
