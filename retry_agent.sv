

`include "uvm_macros.svh"

package agent_pkg;

import uvm_pkg::*;
//import drvr_pkg::*;
//import seqr_pkg::*;
import ctrl_flt_pkr_monitor_pkg::*;
import reg_file_retry_monitor_pkg::*;
import unpacker_retry_monitor_pkg::*;
import controller_retry_monitor_pkg::*;
import retry_seq_item_pkg::*;
import controller_retry_seq_item_pkg::*;
import reg_file_retry_seq_item_pkg::*;
import ctrl_flt_pkr_retry_seq_item_pkg::*;
import unpacker_retry_seq_item_pkg::*;
import env_config_pkg::*;


class retry_agent extends uvm_agent;
  
  
  
  //retry_driver driver;

  ctrl_flt_pkr_retry_monitor ctrl_flt_pkr_monitor;
  reg_file_retry_monitor reg_file_monitor;
  unpacker_retry_monitor unpacker_monitor;
  controller_retry_monitor controller_monitor;
  
  //retry_sequencer sequencer;
  retry_env_config  env_config_agent;

  `uvm_component_utils(retry_agent);
  
  uvm_analysis_port#(controller_retry_seq_item) controller_analysis_port;
  uvm_analysis_port#(reg_file_retry_seq_item) reg_file_analysis_port;
  uvm_analysis_port#(ctrl_flt_pkr_retry_seq_item) ctrl_flt_pkr_analysis_port;
  uvm_analysis_port#(unpacker_retry_seq_item) unpacker_analysis_port;

  
  function new(string name = "retry_agent" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  
  virtual retry_intf vif;

  
  virtual function void build_phase (uvm_phase phase);
    
    super.build_phase(phase);
    //---getting env configuration from test---//
    env_config_agent = retry_env_config::type_id::create("env_config_agent");
    uvm_config_db#(retry_env_config)::get(this , "" , "retry_module_env_config" , env_config_agent);

        //---creating agent components based on configurations---//
   /* if(env_config_agent.agent_is_active)
    begin
      driver    = retry_driver::type_id::create("driver" , this);
      sequencer = retry_sequencer::type_id::create("sequencer" , this);
    end*/



    ctrl_flt_pkr_monitor = ctrl_flt_pkr_retry_monitor::type_id::create("ctrl_flt_pkr_monitor" , this);
    reg_file_monitor = reg_file_retry_monitor::type_id::create("reg_file_monitor" , this);
    unpacker_monitor = unpacker_retry_monitor::type_id::create("unpacker_monitor" , this);
    controller_monitor = controller_retry_monitor::type_id::create("controller_monitor" , this);



    controller_analysis_port = new("controller_analysis_port" , this);
    reg_file_analysis_port = new("reg_file_analysis_port" , this);
    ctrl_flt_pkr_analysis_port = new("ctrl_flt_pkr_analysis_port" , this);
    unpacker_analysis_port = new("unpacker_analysis_port" , this);
    
    if(!uvm_config_db#(retry_env_config)::get(this,"" , "retry_env_config" , env_config_agent))
    begin
          `uvm_fatal(get_full_name() , "Error in retry_env !#");
    end
    
    
    
    //getting the virtual interface that is in resource database
    if (!uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        vif
                                        ) 
       )
      
    begin
      `uvm_fatal(get_full_name() , "Error in retry_agent !#");
    end
    
    else
    begin
      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                       "ctrl_flt_pkr_monitor",
                                       "vif",
                                       vif
      );
        
      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                       "reg_file_monitor",
                                       "vif",
                                       vif
      );


      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                       "unpacker_monitor",
                                       "vif",
                                       vif
      );

      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                      "controller_monitor",
                                      "vif",
                                      vif
      );
        

      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                       "driver",
                                       "vif",
                                       vif
      );
        
    end
    
    
    $display("build_phase of retry_agent is on the wheel!! , vif = %p",vif);
    
        
  endfunction
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    
    ctrl_flt_pkr_monitor.ctrl_flt_pkr_retry_port.connect(ctrl_flt_pkr_analysis_port);
    reg_file_monitor.reg_file_retry_port.connect(reg_file_analysis_port);
    controller_monitor.controller_retry_port.connect(controller_analysis_port);
    unpacker_monitor.unpacker_retry_port.connect(unpacker_analysis_port);
    
    if(env_config_agent.agent_is_active)
    driver.seq_item_port.connect(sequencer.seq_item_export);
    
    $display("connect_phase of retry_agent is on the wheel!!");
  endfunction
  
  
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("run_phase of retry_agent");
    
      wait(vif.retry_send_req_seq == 1)
      $display("retry_send_req_seq is raised @ time = %t" , $time);
      
  endtask
  
  
endclass


endpackage
