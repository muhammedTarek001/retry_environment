


package sequence_pkg;
import uvm_pkg::*;
import retry_seq_item_pkg::*;

`include "uvm_macros.svh"


class retry_sequence extends uvm_sequence;
  
  `uvm_object_utils(retry_sequence);
  
  retry_seq_item total_retry_seq_item ;
  
  function new(string name = "retry_sequence");
    super.new(name);
  endfunction
  task pre_body;
    total_retry_seq_item = retry_seq_item::type_id::create("total_retry_seq_item");
  endtask
  
  
  task link_init_done();
    //-------cxs interface signal-------------//
    total_retry_seq_item.i_register_file_interface_sel = 0;
    //---------------------------------------//
  
    //-----------PHY layer init signals---------------//
    total_retry_seq_item.initialization_done = 1;
    total_retry_seq_item.i_pl_lnk_up = 1;
    //----------------------------------------------//
    
    //--------setting llr wrap value fr LLRB-------//
    total_retry_seq_item.i_register_file_llr_wrap_value = 64;
    //--------------------------------------------//
    
    //--------retry threshold--------------------//
    total_retry_seq_item.i_register_file_retry_threshold = 5;
    //--------------------------------------------//

    //--------reinit threshold--------------------//
    total_retry_seq_item.i_register_file_reinit_threshold = 5;
    //--------------------------------------------//
    
    //--------timeout threshold--------------------//
    total_retry_seq_item.i_register_file_retry_timeout_max_transfers = 5;
    //--------------------------------------------//

  endtask 

  task force_retry_req();
    total_retry_seq_item.unpacker_valid_crc = 0;
    total_retry_seq_item.unpacker_flit_type = 0;
    total_retry_seq_item.unpacker_valid_sig = 1;
    total_retry_seq_item.i_register_file_llr_wrap_value = 8;
    total_retry_seq_item.i_pl_state_sts = 4'b1;
    total_retry_seq_item.controller_wr_en = 1'b1;

    //unpacker_rdptr_eseq_num == 0
    //always monitor LL_Retry_Buffer_Consumed
    //monitor retry_num_ack
    //retry_wrt_ptr
  endtask 


  task reset();
    total_retry_seq_item.i_rst_n = 0;
  endtask 
  
  task default_inputs();    
    //---------unpacker signals-------------------//
    total_retry_seq_item.discard_received_flits=0;
    total_retry_seq_item.unpacker_req_seq_flag=0;
    total_retry_seq_item.unpacker_flit_type=0;
    total_retry_seq_item.unpacker_all_data_flit_flag=0;
    total_retry_seq_item.unpacker_valid_sig=1;
    total_retry_seq_item.unpacker_ack_seq_flag=0;
    total_retry_seq_item.unpacker_valid_crc =1;
    total_retry_seq_item.unpacker_empty_bit =0;
    total_retry_seq_item.unpacker_llctrl_subtype =0;
    total_retry_seq_item.unpacker_llctrl=0;  
    total_retry_seq_item.unpacker_retryreq_num=0;  
    total_retry_seq_item.unpacker_full_ack=0;  
    total_retry_seq_item.unpacker_rdptr_eseq_num=0;    
    total_retry_seq_item.crc_generator_flit_w_crc=0;
    

    //----controller----------//
    total_retry_seq_item.controller_dec_num_ack =0;
    total_retry_seq_item.controller_llcrd_full_ack_sent =0;
    total_retry_seq_item.controller_ack_sent_flag=0;
    total_retry_seq_item.controller_req_sent_flag =0;
    total_retry_seq_item.controller_inc_time_out_retry =0;
    total_retry_seq_item.controller_wr_en=0;
    total_retry_seq_item.controller_rd_en =0;
    total_retry_seq_item.rd_ptr_eseq_set =0;
    total_retry_seq_item.o_lp_state_req =0;
  endtask 

  task  retry_req_sent();
    
  endtask //
  
  task body;
    $display("sequence_just_started!!! @time = %t" , $time);
    //-------reseting retry module-------------// 
    start_item(total_retry_seq_item);
    $display("link_is_initialized @ time= %t" , $time);
    reset();
    finish_item(total_retry_seq_item);    
    //----------------------------------------// 
    total_retry_seq_item.i_rst_n = 1;
    
    //----------------link_init_done------------// 
    
    // start_item(total_retry_seq_item);
    // link_init_done();
    // finish_item(total_retry_seq_item);    
    //----------------------------------------// 
    
    // //----------------force_retry_req------------// 
    // start_item(total_retry_seq_item);
    // force_retry_req();
    // finish_item(total_retry_seq_item);   
    // //----------------------------------------// 

  endtask
  
endclass

endpackage