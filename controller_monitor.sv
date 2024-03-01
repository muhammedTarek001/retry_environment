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
    controller_retry_seq.o_lp_state_req= 8;

    controller_retry_port.write(controller_retry_seq);
    $display("run_phase of controller_retry_monitor");
  endtask

 endclass
 endpackage

