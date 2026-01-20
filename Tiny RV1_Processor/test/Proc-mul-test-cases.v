//========================================================================
// Proc-mul-test-cases
//========================================================================

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "mul  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h000, 'h0000_0002 ); // addi x1, x0, 2
  check_trace( 'h004, 'h0000_0003 ); // addi x1, x0, 3
  check_trace( 'h008, 'h0000_0006 ); // mul  x3, x1, x2

endtask

task test_case_2_negative_values();
  t.test_case_begin("test_case_2_negative_values");
  
  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, -3" ); // small neg value
  asm( 'h004, "addi x2, x0, 4"  );
  asm( 'h008, "mul  x3, x1, x2" );

  asm( 'h00c, "addi x4, x0, -480" ); // large neg value 
  asm( 'h010, "mul  x5, x2, x4"   ); 

  asm('h014, "mul  x5, x1, x4"   ); // double neg

  // check each executed instruction (show negative value)
  
  check_trace( 'h000, 'hffff_fffd); // addi x1, x0, -3
  check_trace( 'h004, 'h0000_0004 ); // addi x1, x0, 4
  check_trace( 'h008, 'hffff_fff4 ); // mul  x3, x1, x2 (-3 * 4 = -12)

  check_trace( 'h00c, 'hfffffe20 ); // addi x4, x0, -480 
  check_trace( 'h010, 'hfffff880 ); // mul  x5, x2, x4 (-480 * 4 = -1920)

  check_trace( 'h014, 'h0000_05A0); // mul  x5, x1, x4 (-480 * -3 = 1440)

endtask

task test_case_3_large_values();
  t.test_case_begin("test_case_3_large_values");

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1020" ); // large value in x1
  asm( 'h004, "addi x2, x0, 2"    ); // small value in x2
  asm( 'h008, "mul  x3, x1, x2"   ); // result is a large value 

  asm( 'h00c, "addi x4, x0, 50"   ); 
  asm( 'h010, "addi x5, x0, 25"   );
  asm( 'h014, "mul  x6, x4, x5"   ); // result is a large value 

  // check each executed instruction (show a large value)

  check_trace( 'h000, 'h0000_03FC ); // addi x1, x0, 1020 
  check_trace( 'h004, 'h0000_0002 ); // addi x1, x0, 2 
  check_trace( 'h008, 'h0000_07F8 ); // mul  x3, x1, x2 (1020 * 2 = 2040)

  check_trace( 'h00c, 'h0000_0032 ); // addi x4, x0, 50
  check_trace( 'h010, 'h0000_0019 ); // addi x5, x0, 25
  check_trace( 'h014, 'h0000_04E2 ); // mul  x6, x4, x5 (50 * 25 = 1250)


endtask

task test_case_4_zeros();
  t.test_case_begin("test_case_4_zeros");

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1020" );
  asm( 'h004, "mul  x2, x0, x1"   );

  // check each executed instruction 

  check_trace( 'h000, 'h0000_03FC ); // addi x1, x0, 1020 ( x1 should be 1020)
  check_trace( 'h004, 'h0000_0000 ); // mul  x2, x0, x1 (1020 * 0 = 0; x2 should be 0)

endtask

task test_case_5_ones();
  t.test_case_begin("test_case_5_ones");
  
  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1" ); // small neg value
  asm( 'h004, "addi x2, x0, 1"  );
  asm( 'h008, "mul  x3, x1, x2" );

  // check each instruction 

  check_trace( 'h000, 'h0000_0001 ); // addi x1, x0, 1
  check_trace( 'h004, 'h0000_0001 ); // addi x2, x0, 2
  check_trace( 'h008, 'h0000_0001 ); // mul x3, x1, x2 (1*1=1)

endtask


