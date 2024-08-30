  module router_reg (clock, resetn, pkt_valid, data_in, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state,
                     parity_done, low_pkt_valid, err, dout);
  
  input clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
  input [7:0] data_in;
  output reg parity_done, low_pkt_valid, err;
  output reg [7:0] dout;
  
  reg [7:0] hb, ip, pp, ffs;
  
  //fifo_full ? ffs = data_in
  //detect_add ? hb = data_in, lfd_state ? dout = hb
  //ld_state ? dout = data_in
  //laf_state ? dout = ffs
  //!full_state ? do parity calculation
  //rst_int_reg ? low_pkt_valid =0
  //ip != pp ? err = 1
  //pp is occupied, parity_done = 1
  
  //parity_done -1
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  parity_done = 1'b0;
  else if(detect_add)
  parity_done = 1'b0;
  else if((ld_state && (!fifo_full) && (!pkt_valid)) ||
          (laf_state && low_pkt_valid && (!parity_done)))
  parity_done = 1'b1;
  else
  parity_done = parity_done;
  
  end
  
  //low_pkt_valid -2
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  low_pkt_valid = 1'b0;
  else if(rst_int_reg)
  low_pkt_valid = 1'b0;
  else if(ld_state && (!pkt_valid))
  low_pkt_valid = 1'b1;
  else
  low_pkt_valid = low_pkt_valid;
  
  end
  
  //hb -3
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  begin
  hb = 8'b0;
  pp = 8'b0;
  ffs = 8'b0;
  end
  else if(detect_add && pkt_valid && (data_in[1:0] != 2'b11))
  hb = data_in;
  else if(ld_state && !pkt_valid)
  pp = data_in;
  else if(ld_state && fifo_full)
  ffs = data_in;
  
  end
  
  //ffs -4
 /* 
  always@(posedge clock)
  begin
  
  if(!resetn)
  ffs = 8'b0;
  else if(ld_state && fifo_full)
  ffs = data_in;
  else
  ffs = ffs;
  
  end
  */
  //dout -5
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  dout = 8'b0;
  else if(lfd_state)
  dout = hb;
  else if(ld_state && (!fifo_full))
  dout = data_in;
  else if(laf_state)
  dout = ffs;
  /*else if((ld_state && (!fifo_full) && (!pkt_valid)) ||
          (laf_state && low_pkt_valid && (!parity_done)))
  dout = pp;*/
  //else
  //dout = dout;
  
  end
  
  //ip -6
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  ip = 8'b0;
  else if(lfd_state && pkt_valid) //detect_add
  ip = ip ^ hb; //data_in
  else if((pkt_valid) && (ld_state) && (!fifo_full))
  ip = ip ^ data_in;
  else if(full_state)
  ip = ip ^ ffs;
  //else
  //ip = ip;
  
  end
  
  //pp -7
  /*
  always@(posedge clock)
  begin
  
  if(!resetn)
  pp = 8'b0;
  //else if((ld_state && (!fifo_full) && (!pkt_valid)) ||
         // (laf_state && low_pkt_valid && (!parity_done)))
  else if(ld_state && !pkt_valid)
  pp = data_in;
  else
  pp = pp;
  
  end
  */
  //err -8
  
  always@(posedge clock)
  begin
  
  if(!resetn)
  err = 1'b0;
  /*else if (((ip != pp) && ld_state && (!fifo_full) && (!pkt_valid)) ||
          ((ip != pp) && laf_state && low_pkt_valid && (!parity_done)))*/
  else if(parity_done)
  err = (ip != pp) ? 1'b1 : 1'b0;
  else
  err = err;
  
  end
  
  endmodule