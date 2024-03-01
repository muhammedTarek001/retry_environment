module retry_top_intf_port (
    retry_intf u0_retry_intf
);


//---------------------------------------
//declaring the signals
//---------------------------------------
wire logic      	 i_clk;
wire logic      	 i_rst_n;

//---------------------------------------
//physical layer signals
//---------------------------------------
wire logic     	 i_pl_lnk_up;
wire logic [3:0]      i_pl_state_sts; 

//---------------------------------------
//controller signals
//---------------------------------------
// input signals 
wire logic     	 controller_dec_num_ack, controller_llcrd_full_ack_sent, 
           	 controller_ack_sent_flag, controller_req_sent_flag, 
	   	 controller_inc_time_out_retry, 
            	 controller_wr_en, controller_rd_en;
wire logic            initialization_done, rd_ptr_eseq_set;
wire logic [3:0]      o_lp_state_req;

// output signals//
wire logic 		retry_send_ack_seq, retry_phy_reinit_req, 
                retry_send_req_seq, retry_link_failure_sig, 
	        retry_stop_read;

//---------------------------------------
//unpacker signals
//---------------------------------------
//inputs
wire logic	         discard_received_flits;
wire logic     	 unpacker_req_seq_flag, unpacker_flit_type, 
          	 unpacker_all_data_flit_flag, unpacker_valid_sig, 
	  	 unpacker_ack_seq_flag, unpacker_valid_crc,  
          	 unpacker_empty_bit;
wire logic [3:0]      unpacker_llctrl_subtype, unpacker_llctrl;
wire logic [4:0]      unpacker_retryreq_num;
wire logic [7:0]      unpacker_full_ack, unpacker_rdptr_eseq_num;

//outputs
wire logic            retry_exist_retry_state;


//---------------------------------------
//register file signals
//--------------------------------------- 
//inputs
wire logic            i_register_file_interface_sel;
wire logic [4:0]      i_register_file_retry_threshold, 
                 i_register_file_reinit_threshold;
wire logic [7:0]      i_register_file_llr_wrap_value;                 
wire logic [12:0]     i_register_file_retry_timeout_max_transfers;

//outputs
wire logic            REINIT_Threshold_hit, Retry_Threshold_hit,
                 Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
		 Link_Failure_Indicator_Register;
wire logic [7:0]      LL_Retry_Buffer_Consumed;


//---------------------------------------
//CRC generator signals
//---------------------------------------
wire logic [527 :0]   crc_generator_flit_w_crc;
 

//-------output to packer ---------------//   
wire logic            retry_set_ack_bit; 
 
                
//-------outputs to control flit packer----------//
wire logic [4:0]      retry_num_retry, retry_num_phy_reinit;
wire logic [7:0]      retry_num_ack, retry_num_free_buff, 
		 retry_eseq, retry_wrt_ptr;

// output to MUX-2
wire logic [527 :0]   retry_llrb_flit;

Retry_Top_Module u0_retry(.*);


//--------module inputs----------------------//
assign  i_clk = u0_retry_intf.i_clk;
assign  i_rst_n = u0_retry_intf.i_rst_n;
assign  controller_dec_num_ack = u0_retry_intf.controller_dec_num_ack;
assign  controller_llcrd_full_ack_sent = u0_retry_intf.controller_llcrd_full_ack_sent;
assign  controller_ack_sent_flag = u0_retry_intf.controller_ack_sent_flag;
assign  unpacker_req_seq_flag = u0_retry_intf.unpacker_req_seq_flag;
assign  unpacker_flit_type = u0_retry_intf.unpacker_flit_type;
assign  unpacker_all_data_flit_flag = u0_retry_intf.unpacker_all_data_flit_flag;
assign  unpacker_valid_sig = u0_retry_intf.unpacker_valid_sig;
assign  unpacker_ack_seq_flag = u0_retry_intf.unpacker_ack_seq_flag;
assign  i_pl_lnk_up = u0_retry_intf.i_pl_lnk_up;
assign  unpacker_valid_crc = u0_retry_intf.unpacker_valid_crc;
assign  controller_req_sent_flag = u0_retry_intf.controller_req_sent_flag;
assign  unpacker_empty_bit = u0_retry_intf.unpacker_empty_bit;
assign  controller_inc_time_out_retry = u0_retry_intf.controller_inc_time_out_retry;
assign  controller_wr_en = u0_retry_intf.controller_wr_en;
assign  unpacker_full_ack = u0_retry_intf.unpacker_full_ack;
assign  i_register_file_llr_wrap_value = u0_retry_intf.i_register_file_llr_wrap_value;
assign  unpacker_rdptr_eseq_num = u0_retry_intf.unpacker_rdptr_eseq_num;
assign  unpacker_llctrl_subtype = u0_retry_intf.unpacker_llctrl_subtype;
assign  unpacker_llctrl = u0_retry_intf.unpacker_llctrl;
assign  i_pl_state_sts = u0_retry_intf.i_pl_state_sts;
assign  o_lp_state_req = u0_retry_intf.o_lp_state_req;
assign  i_register_file_retry_threshold = u0_retry_intf.i_register_file_retry_threshold;
assign  i_register_file_reinit_threshold = u0_retry_intf.i_register_file_reinit_threshold;
assign  unpacker_retryreq_num = u0_retry_intf.unpacker_retryreq_num;
assign  i_register_file_retry_timeout_max_transfers = u0_retry_intf.i_register_file_retry_timeout_max_transfers;
assign  crc_generator_flit_w_crc = u0_retry_intf.crc_generator_flit_w_crc;
assign  initialization_done = u0_retry_intf.initialization_done;
assign  discard_received_flits = u0_retry_intf.discard_received_flits;
assign  rd_ptr_eseq_set = u0_retry_intf.rd_ptr_eseq_set;
assign  i_register_file_interface_sel = u0_retry_intf.i_register_file_interface_sel;


//--------module outputs----------------------//
assign   u0_retry_intf.retry_num_ack = retry_num_ack;
assign   u0_retry_intf.retry_num_free_buff = retry_num_free_buff;
assign   u0_retry_intf.retry_eseq = retry_eseq;
assign   u0_retry_intf.retry_num_retry = retry_num_retry;
assign   u0_retry_intf.retry_num_phy_reinit = retry_num_phy_reinit;
assign   u0_retry_intf.retry_llrb_flit = retry_llrb_flit;
assign   u0_retry_intf.retry_wrt_ptr = retry_wrt_ptr;
assign   u0_retry_intf.retry_exist_retry_state = retry_exist_retry_state;
assign   u0_retry_intf.LL_Retry_Buffer_Consumed = LL_Retry_Buffer_Consumed;
assign   u0_retry_intf.REINIT_Threshold_hit = REINIT_Threshold_hit;
assign   u0_retry_intf.Retry_Threshold_hit = Retry_Threshold_hit;
assign   u0_retry_intf.Link_Failure_Indicator_Register = Link_Failure_Indicator_Register;
assign   u0_retry_intf.Retry_Threshold_hit_en = Retry_Threshold_hit_en;
assign   u0_retry_intf.REINIT_Threshold_hit_en = REINIT_Threshold_hit_en;



endmodule