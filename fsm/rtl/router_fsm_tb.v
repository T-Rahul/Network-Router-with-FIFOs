  module router_fsm_tb();
  
  reg clock, resetn, pkt_valid, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done, low_packet_valid;
  reg [1:0] data_in;
  wire write_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy;
  
  parameter T = 10;
  
  router_fsm DUT (clock, resetn, pkt_valid, data_in, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done, low_packet_valid,
                     write_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy);
  
  always
  #(T/2) clock = ~clock;
  
  task reset();
  begin
  resetn = 1'b0;
  #10;
  resetn = ~resetn;
  end
  endtask
  
  task soft_reset0();
  begin
  soft_reset_0 = 1'b1;
  #10;
  soft_reset_0 = ~soft_reset_0;
  end
  endtask
  
  task soft_reset1();
  begin
  soft_reset_1 = 1'b1;
  #10;
  soft_reset_1 = ~soft_reset_1;
  end
  endtask
  
  task soft_reset2();
  begin
  soft_reset_2 = 1'b1;
  #10;
  soft_reset_2 = ~soft_reset_2;
  end
  endtask
  
  task initialize();
  begin
  
  clock = 1'b0;
  pkt_valid = 1'b0;
  data_in = 2'b00;
  fifo_full = 1'b0;
  fifo_empty_0 = 1'b1;
  fifo_empty_1 = 1'b1;
  fifo_empty_2 = 1'b1;
  parity_done = 1'b0;
  low_packet_valid = 1'b1;
  
  end
  endtask
  
  //Task1- DA-LFD-LD-LP-CPE-DA  0-1-2-3-7-0 if packet length is less than 16
  //TASK2 - DA-LFD-LD-FFS-LAF-LP-CPE-DA 0-1-2-4-5-3-7-0 if packet length is more than 16 but the 17th byte is parity
  //TASK3- DA-LFD-LD-FFS-LAF-LD-LP-CPE-DA 0-1-2-4-5-2-3-7-0 if packet length is more than 16
  //TASK4- DA-LFD-LD-LP-CPE-FFS-LAF-DA 0-1-2-3-7-4-5-0 if packet length is exactly 16
  
  task DA_LFD_LD_LP_CPE_DA();
  begin
  
  pkt_valid = 1'b1;
  low_packet_valid = 1'b0;
  data_in = 2'b01;
  #20;
  pkt_valid = 1'b0;
  low_packet_valid = 1'b1;
  #30;
  
  end
  endtask
  
  task DA_LFD_LD_FFS_LAF_LP_CPE_DA();
  begin
  
  pkt_valid = 1'b1;
  low_packet_valid = 1'b0;
  data_in = 2'b10;
  #20;
  fifo_full = 1'b1;
  #10;
  fifo_full = 1'b0;
  #10;
  low_packet_valid = 1'b1;
  pkt_valid = 1'b0;
  #30;
  
  end
  endtask
  
  task DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA();
  begin
  
  pkt_valid = 1'b1;
  low_packet_valid = 1'b0;
  data_in = 2'b10;
  #20;
  fifo_full = 1'b1;
  #10;
  fifo_full = 1'b0;
  #20;
  pkt_valid = 1'b0;
  low_packet_valid = 1'b1;
  #30;
  
  end
  endtask
  
  task DA_LFD_LD_LP_CPE_FFS_LAF_DA();
  begin
  
  pkt_valid = 1'b1;
  low_packet_valid = 1'b0;
  data_in = 2'b01;
  #20;
  pkt_valid = 1'b0;
  low_packet_valid = 1'b1;
  #20;
  fifo_full = 1'b1;
  #10;
  fifo_full = 1'b0;
  #10;
  parity_done = 1'b1;
  #10;
  
  end
  endtask
  
  initial
  begin
  
  initialize;
  reset;
  soft_reset0;
  soft_reset1;
  soft_reset2;
  DA_LFD_LD_LP_CPE_DA;
  
  initialize;
  reset;
  DA_LFD_LD_FFS_LAF_LP_CPE_DA;
  
  initialize;
  reset;
  DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
  
  initialize;
  reset;
  DA_LFD_LD_LP_CPE_FFS_LAF_DA;
  
  $finish;
  
  end
  
  endmodule