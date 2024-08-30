  module router_reg_tb ();
  
  reg clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
  reg [7:0] data_in;
  wire parity_done, low_pkt_valid, err;
  wire [7:0] dout;
  
  parameter T = 10;
  integer i;
  
  router_reg DUT (clock, resetn, pkt_valid, data_in, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state,
                     parity_done, low_pkt_valid, err, dout);
  
  always
  #(T/2) clock = ~clock;
  
  task initialize();
  begin
  

  pkt_valid = 1'b0;
  data_in = 8'b0;
  fifo_full = 1'b0;
  rst_int_reg = 1'b0;
  detect_add = 1'b0;
  ld_state = 1'b0;
  laf_state = 1'b0;
  full_state = 1'b0;
  lfd_state = 1'b0;
  
  end
  endtask
  
  task reset();
  begin
  
  resetn = 1'b0;
  #10;
  resetn = ~resetn;
  
  end
  endtask
  
  task generation();
  
  reg [7:0] payload_data, parity, header;
  reg [5:0] payload_len;
  reg [1:0] addr;
  
  begin
  
  payload_len = 6'd5;
  addr = 2'b10;
  pkt_valid = 1'b1;
  detect_add = 1'b1;
  header = {payload_len,addr};
  parity = 8'h00 ^ header;
  data_in = header;
  #10;
  detect_add = 1'b0;
  lfd_state = 1'b1;
  for(i=0; i<payload_len;i=i+1)
  begin
  #10;
  lfd_state = 1'b0;
  ld_state = 1'b1;
  payload_data = {$random} % 256;
  data_in = payload_data;
  parity = parity ^ data_in;
  end
  #10;
  pkt_valid = 1'b0;
  data_in = parity;
  #10;
  ld_state = 1'b0;
  
  end
  endtask
  
  task generation_err();
  
  reg [7:0] payload_data, parity, header;
  reg [5:0] payload_len;
  reg [1:0] addr;
  
  begin
  
  payload_len = 6'd5;
  addr = 2'b10;
  pkt_valid = 1'b1;
  detect_add = 1'b1;
  header = {payload_len,addr};
  parity = 8'h00 ^ header;
  data_in = header;
  #10;
  detect_add = 1'b0;
  lfd_state = 1'b1;
  for(i=0; i<payload_len;i=i+1)
  begin
  #10;
  lfd_state = 1'b0;
  ld_state = 1'b1;
  payload_data = {$random} % 256;
  data_in = payload_data;
  parity = parity ^ data_in;
  end
  #10;
  pkt_valid = 1'b0;
  data_in = ~parity;
  #10;
  ld_state = 1'b0;
  
  end
  endtask
  
  initial
  begin
  clock = 1'b0;
  initialize;
  reset;
  generation;
  initialize;
  reset;
  generation_err;
  $finish;
  
  end
  
  endmodule