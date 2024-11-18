module FSM(
  input wire clk,
  input wire start,
  input wire rst_n,
  input wire set_out,  // Đầu vào từ Counter
  
  output reg load,
  output reg shift,
  output reg out
);

typedef enum reg [1:0]{
   IDLE   = 2'b00,
   LOAD   = 2'b01,
   SHIFT  = 2'b10,
   OUTPUT = 2'b11
} state_t;

state_t current_state, next_state;

typedef struct packed {
  logic signal_load;
  logic signal_shift;
  logic signal_out;
} signal_t;

signal_t current_signal, next_signal;

// Sequential logic
always_ff @(posedge clk or negedge rst_n) begin: fsm_sequential
  if (!rst_n) begin
    current_state <= IDLE;
    current_signal <= '{default:0};
  end else begin
    current_state <= next_state;
    current_signal <= next_signal;
  end
end

// Combinational logic
always_comb begin: fsm_comb
  // Default values
  next_state = current_state;
  next_signal = current_signal;

  case (current_state)
    IDLE: begin
      next_signal = '{default:0}; // Reset signals
      if (start) begin
        next_state = LOAD;
        next_signal.signal_load = 1'b1; // Activate load signal
        next_signal.signal_shift = 1'b0;
        next_signal.signal_out = 1'b0;
      end
    end
    LOAD: begin
      next_signal.signal_load = 1'b0; // Activate load signal
      next_signal.signal_shift = 1'b1;
      next_signal.signal_out = 1'b0;
      next_state = SHIFT;
    end
    SHIFT: begin
      if (set_out) begin
        next_state = OUTPUT;
        next_signal.signal_load = 1'b0;
        next_signal.signal_shift = 1'b0; // Activate shift signal
        next_signal.signal_out = 1'b1;
      end else begin
        next_state = current_state;
        next_signal = current_signal;
      end
    end
    OUTPUT: begin
      next_signal.signal_load = 1'b0;
      next_signal.signal_shift = 1'b0;
      next_signal.signal_out = 1'b0; // Activate output signal
      next_state = IDLE; // Return to IDLE
    end
    default: begin
      next_state = IDLE;
      next_signal = '{default:0};
    end
  endcase
end

// Assign outputs
assign load = current_signal.signal_load;
assign shift = current_signal.signal_shift;
assign out = current_signal.signal_out;

endmodule
