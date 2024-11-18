`include "FSM.sv"
`include "Counter.sv"

module Controller(
  input wire clk,
  input wire start,
  input wire rst_n,
  input wire set_out,
  
  output reg load,
  output reg shift,
  output reg out
);

  wire en;
  wire get_output;
  reg load_out;
  reg out_out;
  FSM fsm_inst (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .set_out(get_output),
    
    .load(load_out),
    .shift(en),
    .out(out_out)
  );

  Counter counter_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .set_out(get_output)
  );
  assign load=load_out;
  assign shift=en;
  assign out=out_out;

endmodule
