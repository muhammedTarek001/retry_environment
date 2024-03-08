


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
    
  endtask 

  task  retry_req_sent();
    
  endtask //
  
  task body;
    //-------reseting retry module-------------// 
    start_item(total_retry_seq_item);
    reset();
    finish_item(total_retry_seq_item);    
    //----------------------------------------// 

    total_retry_seq_item.i_rst_n = 1;

    //----------------link_init_done------------// 
    start_item(total_retry_seq_item);
    link_init_done();
    finish_item(total_retry_seq_item);    
    //----------------------------------------// 
    
    //----------------force_retry_req------------// 
    start_item(total_retry_seq_item);
    force_retry_req();
    finish_item(total_retry_seq_item);   
    //----------------------------------------// 

  endtask
  
endclass

endpackage