package controller_retry_monitor_pkg ; 
import uvm_pkg::*;
import controller_retry_seq_item_pkg::*;  
`include "uvm_macros.svh"

  class controller_retry_monitor extends uvm_monitor;
  `uvm_component_utils(controller_retry_monitor);

 function new(string name = "controller_monitor" , uvm_component parent = null);
 super.new(name,parent);
 endfunction
  
  // virtual interface inst
  virtual retry_intf vif;

  //sequence item inst
  controller_retry_seq_item  controller_retry_seq;

  //first port from monitor 1
  uvm_analysis_port#(controller_retry_seq_item) controller_retry_port;     

//////////////////Build phase///////////////////////////
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);

 //building the port & sequence item instances
 controller_retry_port = new("controller_retry_port" , this);
 controller_retry_seq = controller_retry_seq_item::type_id::create("controller_retry_seq");

if ( 
          !uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        vif
                                        ) 
      )
      
    begin
      `uvm_fatal(get_full_name() , "Error in unpacker_retry_agent !#");  
    end
 // checking the build phase
 $display("controller_retry_monitor is built");
 endfunction

 ////////////////connect phase/////////////////////////
 function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);

 // checking the connect phase
 $display("controller_retry_monitor is connected");
 endfunction
  
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("run_phase of controller_retry_monitor");

    forever begin
    // fork
    //   begin
        @(posedge vif.i_clk)
        controller_retry_seq.controller_dec_num_ack <= vif.controller_dec_num_ack;
        controller_retry_seq.controller_llcrd_full_ack_sent <= vif.controller_llcrd_full_ack_sent;
        controller_retry_seq.controller_ack_sent_flag <= vif.controller_ack_sent_flag;
        controller_retry_seq.controller_req_sent_flag <= vif.controller_req_sent_flag;
        controller_retry_seq.controller_inc_time_out_retry <= vif.controller_inc_time_out_retry;
        controller_retry_seq.controller_wr_en <= vif.controller_wr_en;
        controller_retry_seq.controller_rd_en <= vif.controller_rd_en;
        controller_retry_seq.initialization_done <= vif.initialization_done;
        controller_retry_seq.rd_ptr_eseq_set <= vif.rd_ptr_eseq_set;
        controller_retry_seq.o_lp_state_req <= vif.o_lp_state_req;
        controller_retry_seq.retry_send_ack_seq <= vif.retry_send_ack_seq;
        controller_retry_seq.retry_phy_reinit_req <= vif.retry_phy_reinit_req;
        controller_retry_seq.retry_send_req_seq <= vif.retry_send_req_seq;
        controller_retry_seq.retry_link_failure_sig <= vif.retry_link_failure_sig;
        controller_retry_seq.retry_stop_read <= vif.retry_stop_read;

        controller_retry_port.write(controller_retry_seq);
    //   end

    //   begin
    //     monitor_retry_req();
    //   end
    // join_any
    
   end
  endtask

 endclass
 endpackage

