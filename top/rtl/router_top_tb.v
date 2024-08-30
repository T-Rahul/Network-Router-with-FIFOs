  module router_top_tb();
  
  reg clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
  reg [7:0] data_in;
  wire valid_out_0, valid_out_1, valid_out_2, error, busy;
  wire [7:0] data_out_0, data_out_1, data_out_2;
  
  parameter T = 10;
  integer i;
  
  router_top DUT (clock, resetn, read_enb_0, read_enb_1, read_enb_2, data_in, pkt_valid,
                     data_out_0, data_out_1, data_out_2, valid_out_0, valid_out_1, valid_out_2, error, busy);
  
  always
  #(T/2) clock = ~clock;
  
  task reset();
  begin
  resetn = 1'b0;
  #10;
  resetn = ~resetn;
  end
  endtask
  
  task initialize();
  begin
  
  read_enb_0 = 1'b0;
  read_enb_1 = 1'b0;
  read_enb_2 = 1'b0;
  pkt_valid = 1'b0;
  data_in = 8'b0;
  
  end
  endtask
  
  /*task packet_gen(input [5:0] len, input [1:0] add);
  
  reg [7:0] payload_data, parity, header;
  reg [5:0] payload_len;
  reg [1:0] addr;
  
  begin
  #10;
  wait(~busy)
  payload_len = len;
  addr = add;
  header = {payload_len, add};
  parity = 0;
  data_in = header;
  pkt_valid = 1;
  parity = parity ^ header;
  
  #10;
  wait(~busy)
  #5;
  
  for(i=0;i<payload_len;i=i+1)
  
  if(busy)
  begin
  #5;
  read_enb_2 = 1;
  wait(~busy)
  #5;
  end
  
  wait(~busy)
  payload_data = {$random} % 256;
  data_in = payload_data;
  parity = parity ^ payload_data;
  #10;
  
  wait(~busy)
  pkt_valid = 0;
  data_in = parity;
  wait(busy)
  #5;
  read_enb_2 = 1;
  #10;
  
  end
  
  endtask*/
  
  /*task packet_gen(input [5:0] length, input [1:0] address);
  
  reg [7:0] payload_data, parity, header;
  reg [5:0] payload_len;
  reg [1:0] addr;
  
  begin
  #10;
  //pkt_valid = 1'b1;
  wait(~busy)
  payload_len = length;
  addr = address;
  header = {payload_len, addr};
  parity = 0;
  data_in = header;
  pkt_valid = 1;
  //read_enb_2 = 1'b1;
  parity = parity ^ header;
  
  @(negedge clock);
  
  wait(~busy)
  
  for(i=0;i<payload_len;i=i+1)
  begin
  
  //if (DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 =  ~DUT.SYNC.write_enb[2] ? 1:0;
  if(i>16)
  begin
  #15;
  read_enb_2 = 1;
  wait(~busy)
  #5;
  end*/
  
  /*if(busy)
  begin
  wait(~busy)
  #5;
  end*/
  
  /*@(negedge clock);
  
  wait(~busy)
  payload_data = {$random} % 256;
  data_in = payload_data;
  parity = parity ^ payload_data;
  
  //if((i > 14) && pkt_valid)
  //read_enb_2 = 1;
  end
  
  @(negedge clock);
  
  //read_enb_2 =  ~DUT.SYNC.write_enb[2] ? 1:0;
  wait(~busy)
  pkt_valid = 0;
  data_in = parity;
  //if (DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 =  1;
  wait(busy)
  #15;
  read_enb_2 = 1;
  
  @(negedge clock);
  
  end
  
  endtask*/
  
   task packet_gen(input [5:0] len, input [1:0] add);
   reg [7:0] header, payload, parity;
   reg [5:0] payload_len;
   reg [1:0] addr;
   begin
   //lfd_state = 1'b1;
   //#10;
   wait(~busy)
   @(negedge clock)
   payload_len = len;
   addr = add;
   header = {payload_len, addr};
   parity = 8'd0;
   data_in = header;
   //lfd_state = 1'b0;
   pkt_valid = 1'b1;
   //write_enb = 1'b1;
   parity = parity^header;
   @(negedge clock)
   wait(~busy)
   //lfd_state = 1'b0;
   for(i=0;i<payload_len;i=i+1)
   begin
   payload = {$random}%256;
   read_enb_1 = (DUT.FIFO_1.full || !pkt_valid) ? 1:read_enb_1;
   //wait(!full)
   //#(delay);
   @(negedge clock)
   wait(~busy)
   data_in = payload;
   parity = parity^data_in;
   //#10;
   end
   
   //parity = {$random}%256;
   read_enb_1 = (DUT.FIFO_1.full || !pkt_valid) ? 1:read_enb_1;
   //wait(!full)
   @(negedge clock)
   wait(~busy)
   pkt_valid=0;
   data_in = parity;
   //#10;
   //write_enb = 1'b0;
   wait(busy)
   @(negedge clock)
   read_enb_1 = 1'b1;
   
   end
   
   endtask
  
  initial
  begin
  clock = 1'b0;
  initialize;
  reset;
  packet_gen(6'd14, 2'd1);
  //wait(DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 = 1;
  wait(DUT.FIFO_1.counter == 0)
  #15;
  initialize;
  reset;
  packet_gen(6'd5, 2'd1);
  //wait(DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 = 1;
  wait(DUT.FIFO_1.counter == 0)
  #15;
  initialize;
  reset;
  packet_gen(6'd15, 2'd1);
  //wait(DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 = 1;
  wait(DUT.FIFO_1.counter == 0)
  #15;
  initialize;
  reset;
  packet_gen(6'd20, 2'd1);
  //wait(DUT.FIFO_2.full || !pkt_valid)
  //read_enb_2 = 1;
  $finish;
  //read_enb_2 = 1'b1;
  
  end
  
  /*always@(negedge clock)
  begin
  
  read_enb_2 = DUT.FIFO_2.full || !pkt_valid ? 1: 0;
  
  end*/
  
  endmodule