module SIPO(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire shift,
  	input wire out,
  	input wire mode_select,
    input wire serial_in,
    output reg [7:0] parallel_out
);

  reg [7:0] shift_reg;

  // Always block for sequential logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the shift register
      shift_reg <= 8'b0;
    end
    else begin
      if(mode_select)	begin
      if (load) begin
        // Reset shift register on load
        shift_reg <= 8'b0;
      end
      if (shift) begin
        // Shift data into the shift register
        shift_reg <= {shift_reg[6:0], serial_in};
      end
      if (out) begin
         parallel_out <= shift_reg;
       end
    end
  end
end
endmodule: SIPO
