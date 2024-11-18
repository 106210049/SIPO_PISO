`include "controller.sv"
`include "SIPO.sv"
`include "PISO.sv"
// Code your design here
module Data_Transmitter(
  input wire clk,
  input wire rst_n,
  input wire mode_select,
  input wire start,
  input wire serial_in,
  input wire [7:0] parallel_in,
  
  output reg serial_out,
  output reg [7:0] parallel_out
);
  wire load_signal, shift_signal, out_signal;
  wire set_out;
  Controller controller_inst (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .set_out(set_out),
    .load(load_signal),
    .shift(shift_signal),
    .out(out_signal)
  );
  
  
  SIPO sipo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load_signal),
    .shift(shift_signal),
    .out(out_signal),
    .mode_select(mode_select),
    .serial_in(serial_in),
    .parallel_out(parallel_out)
  );
  
  PISO piso_inst(
    .clk(clk),
    .rst_n(rst_n),
    .load(load_signal),
    .shift(shift_signal),
    .mode_select(mode_select),
    .parallel_in(parallel_in),
    .serial_out(serial_out)
  );
endmodule