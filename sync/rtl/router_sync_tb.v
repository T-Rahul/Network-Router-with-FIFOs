  module router_sync_tb();
  
  reg clock, resetn, detect_add, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, read_enb_2;
  reg [1:0] data_in;
  wire vld_out_0, vld_out_1, vld_out_2;
  wire fifo_full, soft_reset_0, soft_reset_1, soft_reset_2;
  wire [2:0] write_enb;
  
  parameter T = 10;
  
  router_sync DUT (clock, resetn, detect_add, data_in, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, read_enb_2,
                      write_enb, fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2);
  
  always
  #(T/2) clock = ~clock;
  
  task initialize();
  begin
  
  clock = 1'b0;
  detect_add = 1'b0;
  full_0 = 1'b0;
  full_1 = 1'b0;
  full_2 = 1'b0;
  empty_0 = 1'b1;
  empty_1 = 1'b1;
  empty_2 = 1'b1;
  write_enb_reg = 1'b0;
  read_enb_0 = 1'b0;
  read_enb_1 = 1'b0;
  read_enb_2 = 1'b0;
  data_in = 2'b00;
  
  end
  endtask
  
  task reset();
  begin
  resetn = 1'b0;
  #10;
  resetn = ~resetn;
  end
  endtask
  
  initial
  begin
  
  initialize;
  reset;
  detect_add = 1'b1;
  #10;
  data_in = 2'b01;
  #10;
  write_enb_reg = 1'b1;
  #10;
  empty_1 = 1'b0;
  #10;
  full_1 = 1'b0;
  read_enb_0 = 1'b1;
  read_enb_2 = 1'b1;
  #340;
  read_enb_1 = 1'b1;
  
  end
  
  endmodule