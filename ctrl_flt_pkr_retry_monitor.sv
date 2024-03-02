
package ctrl_flt_pkr_monitor_pkg;
  
import uvm_pkg::*;
import ctrl_flt_pkr_retry_seq_item_pkg::*;

`include "uvm_macros.svh"



class ctrl_flt_pkr_retry_monitor extends uvm_monitor;
  
  ctrl_flt_pkr_retry_seq_item ctrl_flt_pkr_retry_seq;                 
  `uvm_component_utils(ctrl_flt_pkr_retry_monitor);
  
  uvm_analysis_port#(ctrl_flt_pkr_retry_seq_item) ctrl_flt_pkr_retry_port; 
  
  function new(string name = "ctrl_flt_pkr_retry_monitor" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  virtual retry_intf monitor_vif;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    ctrl_flt_pkr_retry_seq = ctrl_flt_pkr_retry_seq_item::type_id::create("ctrl_flt_pkr_retry_seq"); 
    ctrl_flt_pkr_retry_port = new("ctrl_flt_pkr_retry_port" , this);
    
    
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
      `uvm_fatal(get_full_name() , "Error in ctrl_flt_pkr_retry_agent !#");  
    end
    
    
    
    
    
    
    $display("build_phase of ctrl_flt_pkr_retry_monitor is on the wheel , monitor_vif = %p و !!" , monitor_vif);
  endfunction
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("connect_phase of ctrl_flt_pkr_retry_monitor is on the wheel!!");
  endfunction
  
  
  
  
  
  
  

  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("run_phase of ctrl_flt_pkr_retry_monitor");
    forever begin
    @(posedge vif.i_clk)
    ctrl_flt_pkr_retry_seq.i_pl_lnk_up = monitor_vif.i_pl_lnk_up;
    ctrl_flt_pkr_retry_seq.i_pl_state_sts = monitor_vif.i_pl_state_sts;
    ctrl_flt_pkr_retry_seq.retry_set_ack_bit = monitor_vif.retry_set_ack_bit;
    ctrl_flt_pkr_retry_seq.retry_num_retry = monitor_vif.retry_num_retry;
    ctrl_flt_pkr_retry_seq.retry_num_phy_reinit = monitor_vif.retry_num_phy_reinit;
    ctrl_flt_pkr_retry_seq.retry_num_ack = monitor_vif.retry_num_ack;
    ctrl_flt_pkr_retry_seq.retry_num_free_buff = monitor_vif.retry_num_free_buff;
    ctrl_flt_pkr_retry_seq.retry_eseq = monitor_vif.retry_eseq;
    ctrl_flt_pkr_retry_seq.retry_wrt_ptr = monitor_vif.retry_wrt_ptr;
    ctrl_flt_pkr_retry_seq.retry_llrb_flit = monitor_vif.retry_llrb_flit;

    ctrl_flt_pkr_retry_port.write(ctrl_flt_pkr_retry_seq);
   end
  endtask
  
endclass


endpackage