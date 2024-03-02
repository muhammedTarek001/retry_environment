
// `include "unpacker_retry_sequence_item.sv"

package unpacker_retry_monitor_pkg;
  
import uvm_pkg::*;
import unpacker_retry_seq_item_pkg::*;

`include "uvm_macros.svh"



class unpacker_retry_monitor extends uvm_monitor;
  
  unpacker_retry_seq_item unpacker_retry_seq;                 
  `uvm_component_utils(unpacker_retry_monitor);
  
  uvm_analysis_port#(unpacker_retry_seq_item) unpacker_retry_port; 
  
  function new(string name = "unpacker_retry_monitor" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  virtual retry_intf monitor_vif;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    unpacker_retry_seq = unpacker_retry_seq_item::type_id::create("unpacker_retry_seq"); 
    unpacker_retry_port = new("unpacker_retry_port" , this);
    
    //to be studied later
//     packet::type_id::set_type_override(unpacker_retry_sequence_item::get_type());

    
    //getting the virtual interface that is in resource database
    if ( 
          !uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        monitor_vif
                                        ) 
      )
      
    begin
      `uvm_fatal(get_full_name() , "Error in unpacker_retry_agent !#");  
    end
    
    
    
    
    
    
    $display("build_phase of unpacker_retry_monitor is on the wheel , monitor_vif = %p و !!" , monitor_vif);
  endfunction
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("connect_phase of unpacker_retry_monitor is on the wheel!!");
  endfunction
  
  
  
  
  
  
  

  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("run_phase of unpacker_retry_monitor ");

    forever begin
    @(posedge monitor_vif.i_clk)
    unpacker_retry_seq.discard_received_flits <= monitor_vif.discard_received_flits;
    unpacker_retry_seq.unpacker_req_seq_flag <= monitor_vif.unpacker_req_seq_flag;
    unpacker_retry_seq.unpacker_flit_type <= monitor_vif.unpacker_flit_type;
    unpacker_retry_seq.unpacker_all_data_flit_flag <= monitor_vif.unpacker_all_data_flit_flag;
    unpacker_retry_seq.unpacker_valid_sig <= monitor_vif.unpacker_valid_sig;
    unpacker_retry_seq.unpacker_ack_seq_flag <= monitor_vif.unpacker_ack_seq_flag;
    unpacker_retry_seq.unpacker_valid_crc <= monitor_vif.unpacker_valid_crc;
    unpacker_retry_seq.unpacker_empty_bit <= monitor_vif.unpacker_empty_bit;
    unpacker_retry_seq.unpacker_llctrl_subtype <= monitor_vif.unpacker_llctrl_subtype;
    unpacker_retry_seq.unpacker_llctrl <= monitor_vif.unpacker_llctrl;  
    unpacker_retry_seq.unpacker_retryreq_num <= monitor_vif.unpacker_retryreq_num;  
    unpacker_retry_seq.unpacker_full_ack <= monitor_vif.unpacker_full_ack;  
    unpacker_retry_seq.unpacker_rdptr_eseq_num <= monitor_vif.unpacker_rdptr_eseq_num;    
    unpacker_retry_seq.retry_exist_retry_state <= monitor_vif.retry_exist_retry_state; 
    unpacker_retry_seq.crc_generator_flit_w_crc <= monitor_vif.crc_generator_flit_w_crc;
    
    unpacker_retry_port.write(unpacker_retry_seq);
   end
  endtask
  
endclass


endpackage