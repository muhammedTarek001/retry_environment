




package _retry_driver_pkg;
import uvm_pkg::*;
import retry_seq_item_pkg::*;
`include "uvm_macros.svh"



class retry_driver extends uvm_driver #(retry_seq_item);
  
  
  `uvm_component_utils(retry_driver);
  
  function new(string name = "retry_driver" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  virtual retry_intf vif;
  retry_seq_item total_retry_seq_item;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    total_retry_seq_item = retry_seq_item::type_id::create("total_retry_seq_item");
    $display("build_phase of retry_driver is on the wheel!!");

    if (!uvm_config_db#(virtual intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        vif
                                        ) 
       )
      
    begin
      `uvm_fatal(get_full_name() , "Error in my_driver !#");
    end
  endfunction
  
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("connect_phase of retry_driver is on the wheel!!");
  endfunction
  
  
  
  
  
  
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    

    $display("run_phase of retry_driver");
   
    forever begin
    @(posedge vif.i_clk)
    
    seq_item_port.get_next_item(total_retry_seq_item);
    $display("get_next_item !!!");
    vif.i_rst_n <= total_retry_seq_item.i_rst_n;
    //---------register file signals-------------------//
    vif.i_register_file_interface_sel <= total_retry_seq_item.i_register_file_interface_sel;
    vif.i_register_file_retry_threshold <= total_retry_seq_item.i_register_file_retry_threshold;
    vif.i_register_file_reinit_threshold <= total_retry_seq_item.i_register_file_reinit_threshold;
    vif.i_register_file_llr_wrap_value <= total_retry_seq_item.i_register_file_llr_wrap_value ;
    vif.i_register_file_retry_timeout_max_transfers <= total_retry_seq_item.i_register_file_retry_timeout_max_transfers ;



    //---------unpacker signals-------------------//
    vif.discard_received_flits <= total_retry_seq_item.discard_received_flits;
    vif.unpacker_req_seq_flag <= total_retry_seq_item.unpacker_req_seq_flag;
    vif.unpacker_flit_type<= total_retry_seq_item.unpacker_flit_type;
    vif.unpacker_all_data_flit_flag<= total_retry_seq_item.unpacker_all_data_flit_flag;
    vif.unpacker_valid_sig<= total_retry_seq_item.unpacker_valid_sig;
    vif.unpacker_ack_seq_flag <= total_retry_seq_item.unpacker_ack_seq_flag;
    vif.unpacker_valid_crc <= total_retry_seq_item.unpacker_valid_crc ;
    vif.unpacker_empty_bit <= total_retry_seq_item.unpacker_empty_bit ;
    vif.unpacker_llctrl_subtype <= total_retry_seq_item.unpacker_llctrl_subtype ;
    vif.unpacker_llctrl <= total_retry_seq_item.unpacker_llctrl;  
    vif.unpacker_retryreq_num <= total_retry_seq_item.unpacker_retryreq_num;  
    vif.unpacker_full_ack <= total_retry_seq_item.unpacker_full_ack;  
    vif.unpacker_rdptr_eseq_num <= total_retry_seq_item.unpacker_rdptr_eseq_num;    
    vif.crc_generator_flit_w_crc <= total_retry_seq_item.crc_generator_flit_w_crc;

    //----ctrl_flit_packer------------//
    vif.i_pl_lnk_up <= total_retry_seq_item.i_pl_lnk_up ;
    vif.i_pl_state_sts<= total_retry_seq_item.i_pl_state_sts ;
    

    //----controller----------//
    vif.controller_dec_num_ack <= total_retry_seq_item.controller_dec_num_ack ;
    vif.controller_llcrd_full_ack_sent <= total_retry_seq_item.controller_llcrd_full_ack_sent ;
    vif.controller_ack_sent_flag <= total_retry_seq_item.controller_ack_sent_flag;
    vif.controller_req_sent_flag <= total_retry_seq_item.controller_req_sent_flag ;
    vif.controller_inc_time_out_retry <= total_retry_seq_item.controller_inc_time_out_retry ;
    vif.controller_wr_en <= total_retry_seq_item.controller_wr_en;
    vif.controller_rd_en <= total_retry_seq_item.controller_rd_en ;
    vif.initialization_done <= total_retry_seq_item.initialization_done ;
    vif.rd_ptr_eseq_set <= total_retry_seq_item.rd_ptr_eseq_set ;
    vif.o_lp_state_req <= total_retry_seq_item.o_lp_state_req ;
    
    #0
    seq_item_port.item_done(total_retry_seq_item);
    end

  endtask
  
endclass


endpackage