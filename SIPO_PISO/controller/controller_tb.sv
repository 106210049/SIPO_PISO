`timescale 1ns / 1ps

module Controller_tb;

  // Inputs
  reg clk;
  reg start;
  reg rst_n;
  reg mode_select;

  // Outputs
  wire load;
  wire shift;
  wire out;

  // Internal signal for observation
  wire set_out;

  // Instantiate the Unit Under Test (UUT)
  Controller uut (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .mode_select(mode_select),
    .set_out(set_out),
    .load(load),
    .shift(shift),
    .out(out)
  );

  // Clock generation
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock (10ns period)
  end

  // Test sequence
  initial begin
    // Initialize inputs
    rst_n = 0; // System in reset initially (active low)
    start = 0;

    // Release reset
    #10 rst_n = 1; // Deassert reset (active low -> high)

    // Test IDLE -> LOAD transition
    #10 start = 1; // Trigger start
    #30 start = 0;

    // Let the counter increment and check transitions
    #100; // Wait to let the counter reach its maximum value (8 clock cycles)
	
    #10 start = 1; // Trigger start
    #30 start = 0;

    // Let the counter increment and check transitions
    #100; // Wait to let the counter reach its maximum value (8 clock cycles)

    
    
	#10 start = 1; // Trigger start
    #30 start = 0;
    // Allow counter to cycle again and reset to IDLE
    #100;

   

    // End simulation
    #50 $finish;
  end

  // Monitor for debugging
  initial begin
    $monitor("Time: %0d | rst_n: %b | start: %b | mode_select: %b | set_out: %b | load: %b | shift: %b | out: %b", 
              $time, rst_n, start, mode_select, set_out, load, shift, out);
  end

endmodule
