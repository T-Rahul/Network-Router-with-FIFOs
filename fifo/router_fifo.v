  module router_fifo (clock, resetn, soft_reset, write_enb, read_enb, lfd_state, data_in,
                      full, empty, data_out);
  
  input clock, resetn, soft_reset, write_enb, read_enb, lfd_state;
  input [7:0] data_in;
  output full, empty;
  output reg [7:0] data_out;
  
  reg [6:0] counter;
  reg [4:0] wr_ptr, rd_ptr;
  reg [8:0] mem [0:15];
  reg temp_lfd;
  
  integer i;
  
  assign empty = (wr_ptr == rd_ptr);
  assign full = (wr_ptr == {~rd_ptr[4], rd_ptr[3:0]});
  
  always@(posedge clock) 
  temp_lfd <= lfd_state;
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  wr_ptr <= 0;
  
  else if(soft_reset)
  wr_ptr <= 0;
  
  //else if(write_enb && ~full && temp_lfd)
  //wr_ptr <= 0;
  
  else if(write_enb && !full)
  begin
  wr_ptr <= lfd_state ? 5'd0 : wr_ptr + 1;
  end
  
  
  else
  wr_ptr <= wr_ptr;
  
  end
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  for(i=0;i<16;i=i+1)
  mem[i] <= 0;
  
  else if(soft_reset)
  for(i=0;i<16;i=i+1)
  mem[i] <= 0;
  
  //else if(write_enb && ~full && temp_lfd)
  //mem[wr_ptr[3:0]] <= {temp_lfd, data_in};
  
  else if(write_enb && !full)
  mem[wr_ptr[3:0]] <= {temp_lfd, data_in};
  
  else
  mem[wr_ptr[3:0]] <= mem[wr_ptr[3:0]];
  
  end
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  rd_ptr <= 0;
  
  else if(soft_reset)
  rd_ptr <= 0;
  
  else if(read_enb && !empty)
  rd_ptr <= rd_ptr + 1;
  
  else
  rd_ptr <= rd_ptr;
  
  end
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  begin
  counter <= 0;
  //dummy <= 0;
  end
  
  else if(soft_reset)
  begin
  counter <= 0;
  //dummy <= 0;
  end
  
  else if(temp_lfd)
  counter <= data_in[7:2] + 2;
  
  else if(read_enb && !empty && counter)
  //begin
  
  //if(mem[rd_ptr[3:0]][8] == 1)
  //begin
  //counter <= mem[rd_ptr[3:0]][7:2] + 1;
  //dummy <= mem[rd_ptr[3:0]][7:2] + 1;
  //end
  //else
  counter <= counter - 1;
  
  //end
  
  else
  counter <= counter;
  
  end
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  data_out <= 0;
  
  else if(soft_reset)
  data_out <= 8'hzz;
  
  else if(counter == 0)
  data_out <= 8'hzz;
  
  else if(read_enb && !empty)
  data_out <= /*(rd_ptr == dummy) ? 8'hzz :*/ mem[rd_ptr[3:0]][7:0];
  
  //else if(counter == 0)
  //data_out <= 8'hzz;
  
  else
  data_out <= data_out;
  
  
  end
  
  endmodule