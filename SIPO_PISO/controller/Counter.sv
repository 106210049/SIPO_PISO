module Counter(
  input wire clk,
  input wire rst_n,
  input wire en,
  
  output reg set_out
);

  reg [2:0] count;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 3'b000;
    end else if (en) begin
      count <= count + 1;
    end
    else begin
      count <= 3'b000;
    end
  end

  assign set_out = (count == 3'b111);

endmodule
