package retry_seq_item_pkg ; 

import uvm_pkg::*;
`include "uvm_macros.svh"

class retry_seq_item extends uvm_sequence_item;
`uvm_object_utils(retry_seq_item);

function new (string name = "retry_seq_item");
super.new(name) ;
endfunction

bit      	 i_clk, i_rst_n;

//----physical layer signals---//

// input signals//
rand bit     	 i_pl_lnk_up;
rand bit [3:0]   i_pl_state_sts; 

//------controller signals-----//
rand bit     	 controller_dec_num_ack, controller_llcrd_full_ack_sent, 
           	 controller_ack_sent_flag, controller_req_sent_flag, 
	   	 controller_inc_time_out_retry, 
            	 controller_wr_en, controller_rd_en;
rand bit         initialization_done, rd_ptr_eseq_set;
rand bit [3:0]   o_lp_state_req;

// output signals//
logic 		retry_send_ack_seq, retry_phy_reinit_req, 
                retry_send_req_seq, retry_link_failure_sig, 
	            retry_stop_read;

//------unpacker signals-----//

// input signals//
rand bit	 discard_received_flits;
rand bit 	 unpacker_req_seq_flag, unpacker_flit_type, 
          	 unpacker_all_data_flit_flag, unpacker_valid_sig, 
	  	 unpacker_ack_seq_flag, unpacker_valid_crc,  
          	 unpacker_empty_bit;
rand bit [3:0]   unpacker_llctrl_subtype, unpacker_llctrl;
rand bit [4:0]   unpacker_retryreq_num;
rand bit [7:0]   unpacker_full_ack, unpacker_rdptr_eseq_num;

//outputs
logic              retry_exist_retry_state;


//------register file signals-----//

// input signals//
rand bit         i_register_file_interface_sel;
rand bit [4:0]   i_register_file_retry_threshold, 
                 i_register_file_reinit_threshold;
rand bit [7:0]   i_register_file_llr_wrap_value;                 
rand bit [12:0]  i_register_file_retry_timeout_max_transfers;

//outputs
logic              REINIT_Threshold_hit, Retry_Threshold_hit,
                 Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
		 Link_Failure_Indicator_Register;
logic [7:0]        LL_Retry_Buffer_Consumed;


//-------CRC generator signals------//

// input signals//
rand bit [527 :0]   crc_generator_flit_w_crc;
 

//-------output to packer ---------------//   
logic              retry_set_ack_bit; 
 
                
//-------outputs to control flit packer----------//
logic [4:0]      retry_num_retry, retry_num_phy_reinit;
logic [7:0]      retry_num_ack, retry_num_free_buff, 
	       retry_eseq, retry_wrt_ptr;

// output to MUX-2
logic [527 :0]   retry_llrb_flit;

endclass
endpackage