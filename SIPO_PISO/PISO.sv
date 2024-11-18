module PISO(
  input wire clk,
  input wire rst_n,
  input wire load,
  input wire shift,
  input wire mode_select,
  input wire [7:0] parallel_in,
  
  output reg serial_out
);
  reg [7:0] shift_reg;
  always@(posedge clk or negedge rst_n)	begin
    
    if(!rst_n)	begin
      serial_out<=0;
      shift_reg<=8'd0;
    end
    
    else	begin
      if(!mode_select)	begin
      
        if(load)	begin
        	shift_reg<= parallel_in;
      	end
      	else if(shift)	begin 
          serial_out <= shift_reg[0];            // Output MSB as serial output
          shift_reg <= shift_reg>>1;   // Shift left
      	end
        else begin
          serial_out<=0;
        end
   	 end
   end
 end
endmodule: PISO