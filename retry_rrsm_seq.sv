package RRSM_seq_pkg;
import uvm_pkg::*;
import retry_seq_item_pkg::*;
import retry_seqr_pkg::*;
`include "uvm_macros.svh"


class retry_RRSM_sequence extends uvm_sequence#(retry_seq_item);
  
  `uvm_object_utils(retry_RRSM_sequence);
  
  retry_seq_item total_retry_seq_item ;
  
  function new(string name = "retry_RRSM_sequence");
    super.new(name);
  endfunction

task body ();
    total_retry_seq_item = retry_seq_item::type_id::create("total_retry_seq_item");
    start_item(total_retry_seq_item);
    reset();
    finish_item(total_retry_seq_item);

    start_item(total_retry_seq_item);
    retry_ack();
    //Eseq_NUM();
   // NUM_ACK();
    finish_item(total_retry_seq_item);
    $display("retry_req_flit is received , @time= %t ", $time);

  endtask

 task reset();
    total_retry_seq_item.i_rst_n = 0;
   #10
    total_retry_seq_item.i_rst_n = 1;
  endtask 

//checks retry_send_ack_seq = 1;
 task retry_ack();  
    total_retry_seq_item.unpacker_valid_sig = 1;
    total_retry_seq_item.unpacker_req_seq_flag = 1;
    total_retry_seq_item.unpacker_retryreq_num = 5'b00001;
    total_retry_seq_item.unpacker_valid_crc = 0;
    total_retry_seq_item.unpacker_flit_type = 0;
    total_retry_seq_item.unpacker_ack_seq_flag = 0;
    total_retry_seq_item.discard_received_flits = 0;
    total_retry_seq_item.unpacker_all_data_flit_flag=0;
    total_retry_seq_item.unpacker_empty_bit = 0;
    total_retry_seq_item.unpacker_llctrl_subtype =0;
    total_retry_seq_item.unpacker_llctrl=0;    
    total_retry_seq_item.unpacker_full_ack = 0;      
    total_retry_seq_item.crc_generator_flit_w_crc = 0;

    total_retry_seq_item.controller_req_sent_flag = 1;
    total_retry_seq_item.rd_ptr_eseq_set = 1;
    total_retry_seq_item.controller_ack_sent_flag = 0;
    total_retry_seq_item.controller_dec_num_ack = 0;
    total_retry_seq_item.controller_llcrd_full_ack_sent = 0;
    total_retry_seq_item.controller_inc_time_out_retry =0;
    total_retry_seq_item.controller_wr_en = 0;
    total_retry_seq_item.controller_rd_en = 0;
    total_retry_seq_item.o_lp_state_req = 0;
    total_retry_seq_item.i_register_file_llr_wrap_value = 8;
    total_retry_seq_item.i_pl_state_sts = 4'b1;
   #5;
   //total_retry_seq_item.controller_ack_sent_flag = 1;
endtask


// LLRB and variables
task NUM_ACK();
//NUM_ACK tests
#20
total_retry_seq_item.controller_llcrd_full_ack_sent = 1; //checks--> NUM_ACK = 0

//NUM_ACK = NUM_ACK + 8
//retryable_flit_detected_sig = 1
total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag =1; 
total_retry_seq_item.unpacker_llctrl = 4'b0000 ;
total_retry_seq_item.unpacker_flit_type = 0 ;
#20
total_retry_seq_item.retry_set_ack_bit =1; //NUM_ACK = NUM_ACK - 8
total_retry_seq_item.controller_dec_num_ack = 1;
endtask

task NUMFREEBUFF(); 
//NUM_FREE_BUFF + unpacker_full_ack 
//llctrl_acknowledge_flit_detected_sig = 1;
total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag = 0;
total_retry_seq_item.unpacker_llctrl = 4'b0000; 
total_retry_seq_item.unpacker_llctrl_subtype = 4'b0001;
total_retry_seq_item.unpacker_flit_type = 1;
#10
//protocol_flit_detected_sig = 0; 
total_retry_seq_item.unpacker_valid_crc = 0;
total_retry_seq_item.unpacker_valid_sig = 0;
total_retry_seq_item.discard_received_flits = 1;
total_retry_seq_item.unpacker_all_data_flit_flag = 1; 
total_retry_seq_item.unpacker_flit_type = 1;
#50
// NUM_FREE_BUFF the samee
//protocol_flit_detected_sig = 1;  
total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag = 0; 
// or total_retry_seq_item.unpacker_flit_typ = 0;
//llctrl_acknowledge_flit_detected_sig = 1;
total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag = 0;
total_retry_seq_item.unpacker_llctrl = 4'b0000; 
total_retry_seq_item.unpacker_llctrl_subtype = 4'b0001;
total_retry_seq_item.unpacker_flit_type = 1; 

#50
//NUM_FREE_BUFF + {4?b0,unpacker_full_ack[3],3?b0}
//protocol_flit_detected_sig = 1;  
total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag = 0; 
// or total_retry_seq_item.unpacker_flit_typ = 0;
//llctrl_acknowledge_flit_detected_sig = 0;
total_retry_seq_item.unpacker_valid_crc =0;
total_retry_seq_item.unpacker_valid_sig =0;
total_retry_seq_item.discard_received_flits = 1;
total_retry_seq_item.unpacker_all_data_flit_flag = 1;
total_retry_seq_item.unpacker_llctrl = 4'b0011; 
total_retry_seq_item.unpacker_llctrl_subtype = 4'b0000;
total_retry_seq_item.unpacker_flit_type = 0; 

endtask

task Eseq_NUM();
#5
total_retry_seq_item.retry_eseq = 8; //retry_eseq = 0;
//ESeq_NUM + 8?b1
//retryable_flit_detected_sig =1
/*total_retry_seq_item.unpacker_valid_crc =1;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag =1; 
total_retry_seq_item.unpacker_llctrl = 4'b0000 ;
total_retry_seq_item.unpacker_flit_type = 0;*/
    
endtask

task NUM_RETRY();
//retryable_flit_detected_sig =1
total_retry_seq_item.unpacker_valid_crc =1;  //--> retry_num_retry =0;
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag =1; 
total_retry_seq_item.unpacker_llctrl = 4'b0000 ;
total_retry_seq_item.unpacker_flit_type = 0; 

//num_retry_reset=1;
total_retry_seq_item.i_pl_lnk_up = 1; 

//empty_bit_detected_reset = 1  
total_retry_seq_item.unpacker_empty_bit = 1;
//num_retry_and_phyreinit_reset =1;
total_retry_seq_item.unpacker_ack_seq_flag =1 ;
//num_retry_matches= 1
total_retry_seq_item.unpacker_retryreq_num = total_retry_seq_item.retry_num_retry - 5'b1;
   
//total_retry_seq_item.num_retry_inc_en = 1 ; // NUM_RETRY + 5?b1 (signal from LRSM block how to assign it)
endtask

task NUM_PHY_REINIT();
//retryable_flit_detected_sig =1
total_retry_seq_item.unpacker_valid_crc =1;  //NUM_PHY_REINIT = 0
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.discard_received_flits =0;
total_retry_seq_item.unpacker_all_data_flit_flag =1; 
total_retry_seq_item.unpacker_llctrl = 4'b0000;
total_retry_seq_item.unpacker_flit_type = 0;  
//empty_bit_detected_reset = 1  
total_retry_seq_item.unpacker_empty_bit = 1;
//num_retry_and_phyreinit_reset =1;
total_retry_seq_item.unpacker_ack_seq_flag =1 ;
//num_retry_matches= 1
total_retry_seq_item.unpacker_retryreq_num = total_retry_seq_item.retry_num_retry - 5'b1;
//assert if(num_phy_reinit_inc_en) --> NUM_PHY_REINIT + 5?b1 (from controller)
endtask

 task timeout();
//timeout_reset=1; // 13?b0
//total_retry_seq_item.i_register_file_retry_timeout_max_transfers = timeout_reg; oring
total_retry_seq_item.unpacker_ack_seq_flag = 1;
//num_retry_matches= 1
total_retry_seq_item.unpacker_retryreq_num = total_retry_seq_item.retry_num_retry - 5'b1;
#50
//TIME_OUT=TIME_OUT + 13?b1 (LRSM)
total_retry_seq_item.controller_inc_time_out_retry = 1;
//timeout_en = 1; 
total_retry_seq_item.unpacker_valid_sig =1;
total_retry_seq_item.unpacker_valid_crc = 0;
total_retry_seq_item.initialization_done = 1; 
endtask

endclass
endpackage