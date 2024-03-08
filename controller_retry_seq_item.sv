package controller_retry_seq_item_pkg ; 

import uvm_pkg::*;
`include "uvm_macros.svh"
  
class controller_retry_seq_item extends uvm_sequence_item;
`uvm_object_utils(controller_retry_seq_item);

function new (string name = "controller_retry_seq_item");
super.new(name) ;
endfunction   
                       
//------controller signals-----//
rand logic     	 controller_dec_num_ack, controller_llcrd_full_ack_sent, 
           	 controller_ack_sent_flag, controller_req_sent_flag, 
	   	 controller_inc_time_out_retry, 
            	 controller_wr_en, controller_rd_en;
rand logic         initialization_done, rd_ptr_eseq_set;
rand logic [3:0]   o_lp_state_req;

// output signals//
logic 		retry_send_ack_seq, retry_phy_reinit_req, 
                retry_send_req_seq, retry_link_failure_sig, 
	        retry_stop_read;


endclass
endpackage