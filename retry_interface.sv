interface retry_intf(input bit i_clk);

//---------------------------------------
//declaring the signals
//---------------------------------------
logic      	 i_rst_n;

//---------------------------------------
//physical layer signals
//---------------------------------------
logic     	 i_pl_lnk_up;
logic [3:0]      i_pl_state_sts; 

//---------------------------------------
//controller signals
//---------------------------------------
// input signals 
logic     	controller_dec_num_ack, controller_llcrd_full_ack_sent, 
           	controller_ack_sent_flag, controller_req_sent_flag, 
	   	    controller_inc_time_out_retry, 
            controller_wr_en, controller_rd_en;
			
logic            initialization_done, rd_ptr_eseq_set;
logic [3:0]      o_lp_state_req ;

// output signals//
logic 		retry_send_ack_seq, retry_phy_reinit_req, 
                retry_send_req_seq, retry_link_failure_sig, 
	        retry_stop_read;

//---------------------------------------
//unpacker signals
//---------------------------------------
//inputs
logic	         discard_received_flits;
logic     	 unpacker_req_seq_flag, unpacker_flit_type, 
          	 unpacker_all_data_flit_flag, unpacker_valid_sig, 
	  	 unpacker_ack_seq_flag, unpacker_valid_crc,  
          	 unpacker_empty_bit;
logic [3:0]      unpacker_llctrl_subtype, unpacker_llctrl;
logic [4:0]      unpacker_retryreq_num;
logic [7:0]      unpacker_full_ack, unpacker_rdptr_eseq_num;

//outputs
logic            retry_exist_retry_state;


//---------------------------------------
//register file signals
//--------------------------------------- 
//inputs
logic            i_register_file_interface_sel;
logic [4:0]      i_register_file_retry_threshold, 
                 i_register_file_reinit_threshold;
logic [7:0]      i_register_file_llr_wrap_value;                 
logic [12:0]     i_register_file_retry_timeout_max_transfers;

//outputs
logic            REINIT_Threshold_hit, Retry_Threshold_hit,
                 Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
		 Link_Failure_Indicator_Register;
logic [7:0]      LL_Retry_Buffer_Consumed;


//---------------------------------------
//CRC generator signals
//---------------------------------------
logic [527 :0]   crc_generator_flit_w_crc;
 

//-------output to packer ---------------//   
logic            retry_set_ack_bit; 
 
                
//-------outputs to control flit packer----------//
logic [4:0]      retry_num_retry, retry_num_phy_reinit;
logic [7:0]      retry_num_ack, retry_num_free_buff, 
		 retry_eseq, retry_wrt_ptr;

// output to MUX-2
logic [527 :0]   retry_llrb_flit;
      
// states
logic [3:0] LRSM;
logic [2:0] RRSM;
//---------------------------------------
//controller_monitor modport  
//---------------------------------------
// modport ctrl_mon (
// input     	 controller_dec_num_ack, controller_llcrd_full_ack_sent, 
//            	 controller_ack_sent_flag, controller_req_sent_flag, 
// 	   	 controller_inc_time_out_retry, 
//             	 controller_wr_en, controller_rd_en,
//                  initialization_done, rd_ptr_eseq_set,
//                  o_lp_state_req,


// input 		retry_send_ack_seq, retry_phy_reinit_req, 
//                 retry_send_req_seq, retry_link_failure_sig, 
// 	        retry_stop_read 
// );

// //---------------------------------------
// //reg_file_monitor modport
// //---------------------------------------
// modport reg_mon (
// input            i_register_file_interface_sel,
// input            i_register_file_retry_threshold, 
//                  i_register_file_reinit_threshold,
// input            i_register_file_llr_wrap_value,               
// input            i_register_file_retry_timeout_max_transfers,

// input            REINIT_Threshold_hit, Retry_Threshold_hit,
//                  Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
// 		 Link_Failure_Indicator_Register,
// input            LL_Retry_Buffer_Consumed
// );

// //---------------------------------------
// //unpacker_monitor modport
// //---------------------------------------
// modport unpkr_mon (
// input	         discard_received_flits,
//            	 unpacker_req_seq_flag, unpacker_flit_type, 
//           	 unpacker_all_data_flit_flag, unpacker_valid_sig, 
// 	  	 unpacker_ack_seq_flag, unpacker_valid_crc,  
//           	 unpacker_empty_bit,
// input            unpacker_llctrl_subtype, unpacker_llctrl,
// input            unpacker_retryreq_num,
// input            unpacker_full_ack, unpacker_rdptr_eseq_num,

// input            retry_exist_retry_state,

// input            crc_generator_flit_w_crc
// );

// //---------------------------------------
// //control_flit_packer_monitor modport
// //---------------------------------------
// modport ctrl_flt_mon (  
// //----physical layer signals---//
// input     	 i_pl_lnk_up,
// input            i_pl_state_sts,

// input            retry_set_ack_bit,

// input            retry_num_retry, retry_num_phy_reinit,
// input            retry_num_ack, retry_num_free_buff, 
// 		 retry_eseq, retry_wrt_ptr,

// // output to MUX-2
// input           retry_llrb_flit
// );

endinterface


