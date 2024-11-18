`timescale 1ns / 1ps

module Data_Transmitter_tb;

  // Inputs
  reg clk;
  reg rst_n;
  reg mode_select;
  reg start;
  reg serial_in;
  reg [7:0] parallel_in;

  // Outputs
  wire serial_out;
  wire [7:0] parallel_out;

  // Instantiate the Data_Transmitter module
  Data_Transmitter uut (
    .clk(clk),
    .rst_n(rst_n),
    .mode_select(mode_select),
    .start(start),
    .serial_in(serial_in),
    .parallel_in(parallel_in),
    .serial_out(serial_out),
    .parallel_out(parallel_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Generate a clock with a period of 10ns
  end

  // Test sequence
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    // Initialize inputs
    rst_n = 0;
    mode_select = 0;
    start = 0;
    serial_in = 0;
    parallel_in = 8'b0;

    // Reset the system
    #10;
    rst_n = 1; // Release reset

    // Test 1: Check reset functionality
    if (parallel_out != 8'b0)
      $display("Test failed: Reset did not clear parallel_out");
    else
      $display("Test passed: Reset functionality verified");

    // Test 2: Serial-In Parallel-Out (SIPO) mode
    mode_select = 1; // Select SIPO mode
    start = 1;
    #10;
    start = 0;
    #10
    // Load data bit by bit into the SIPO register
    serial_in = 1; #10; // First bit
    serial_in = 0; #10; // Second bit
    serial_in = 1; #10; // Third bit
    serial_in = 1; #10; // Fourth bit
    serial_in = 0; #10; // Fifth bit
    serial_in = 1; #10; // Sixth bit
    serial_in = 0; #10; // Seventh bit
    serial_in = 1; #10; // Eighth bit
    // Check the parallel output
    if (parallel_out != 8'b10110101)
      $display("Test failed: SIPO mode parallel_out = %b, expected 10100101", parallel_out);
    else
      $display("Test passed: SIPO mode verified");
	#20
    rst_n=0;
    #5
    rst_n=1;
    #5
    // Test 3: Parallel-In Serial-Out (PISO) mode (if implemented)
    mode_select = 0; // Select PISO mode
    parallel_in = 8'b11001100; // Load parallel data
    #10
    start = 1; #10; // Start signal active
    start = 0;
    // Monitor serial output for each clock cycle
    
    #100
    // End simulation
    $display("All tests completed");
    $stop;
  end

endmodule
