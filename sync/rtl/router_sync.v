  module router_sync (clock, resetn, detect_add, data_in, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, read_enb_2,
                      write_enb, fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2);
  
  input clock, resetn, detect_add, full_0, full_1, full_2, empty_0, empty_1, empty_2, write_enb_reg, read_enb_0, read_enb_1, read_enb_2;
  input [1:0] data_in;
  output vld_out_0, vld_out_1, vld_out_2;
  output reg fifo_full, soft_reset_0, soft_reset_1, soft_reset_2;
  output reg [2:0] write_enb;
  
  reg [1:0] data_in_reg;
  reg [4:0] count_rst0, count_rst1, count_rst2;
  
  always@(posedge clock)
  begin
  
  if(detect_add)
  data_in_reg = data_in;
  
  end
  
  always@(*)
  begin
  
  case(data_in_reg)
  2'b00: fifo_full = full_0;
  2'b01: fifo_full = full_1;
  2'b10: fifo_full = full_2;
  default: fifo_full = 0;
  endcase
  
  if(write_enb_reg)
  begin
  case(data_in_reg)
  2'b00: write_enb = 3'b001;
  2'b01: write_enb = 3'b010;
  2'b10: write_enb = 3'b100;
  default: write_enb = 3'b000;
  endcase
  end
  else
  write_enb = 3'b000;
  
  end
  
  assign {vld_out_0, vld_out_1, vld_out_2} = {~empty_0, ~empty_1, ~empty_2};
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  begin
    soft_reset_0 = 0;
    count_rst0 = 0;
  end
  
  else
  begin
  
    if(vld_out_0)
    begin
  
      if(count_rst0 == 5'd29)
      begin
        soft_reset_0 = 1;
        count_rst0 = 0;
      end
  
      else
      begin
  
        if(read_enb_0)
        begin
          count_rst0 = 0;
          soft_reset_0 = 0;
        end
	
        else
		begin
          count_rst0 = count_rst0 +1;
		  soft_reset_0 = 0;
        end
	  end
  
    end
  
    else 
    begin
      count_rst0 = 0;
      soft_reset_0 = 0;
    end
  
  end
  
  end
  
  //reset2
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  begin
    soft_reset_1 = 0;
    count_rst1 = 0;
  end
  
  else
  begin
  
    if(vld_out_1)
    begin
  
      if(count_rst1 == 5'd29)
      begin
        soft_reset_1 = 1;
        count_rst1 = 0;
      end
  
      else
      begin
  
        if(read_enb_1)
        begin
          count_rst1 = 0;
          soft_reset_1 = 0;
        end
	
        else
		begin
          count_rst1 = count_rst1 +1;
		  soft_reset_1 = 0;
        end
	  end
  
    end
  
    else 
    begin
      count_rst1 = 0;
      soft_reset_1 = 0;
    end
  
  end
  
  end
  
  //reset3
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  begin
    soft_reset_2 = 0;
    count_rst2 = 0;
  end
  
  else
  begin
  
    if(vld_out_2)
    begin
  
      if(count_rst2 == 5'd29)
      begin
        soft_reset_2 = 1;
        count_rst2 = 0;
      end
  
      else
      begin
  
        if(read_enb_2)
        begin
          count_rst2 = 0;
          soft_reset_2 = 0;
        end
	
        else
		begin
          count_rst2 = count_rst2 +1;
		  soft_reset_2 = 0;
        end
	  end
  
    end
  
    else 
    begin
      count_rst2 = 0;
      soft_reset_2 = 0;
    end
  
  end
  
  end
  
  endmodule