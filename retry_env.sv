

package retry_env_pkg;

import uvm_pkg::*;
import agent_pkg::*;
import retry_subsc_pkg::*;
import sb_pkg::*;
import retry_env_config_pkg::*;


`include "uvm_macros.svh"



class retry_env extends uvm_env;  
  
  `uvm_component_utils(retry_env);

  
  retry_agent       agent;


  retry_subscriber  subscriber;
  retry_scoreboard  scoreboard;

  retry_env_config  env_config_env;
  
  
  function new(string name = "retry_env" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  virtual retry_intf retry_vif;

  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase); 
    //--------------------------------------------------//
    //---setting env configuration---------------------//
    //------------------------------------------------//
    env_config_env = retry_env_config::type_id::create("env_config_env");
    
   /* //__settig configs for agents
    env_config_env.agent_is_active = 0;
    
    //__settig configs for subscriber and SB
    env_config_env.has_sb = 1;
    
    env_config_env.has_subsc = 1;*/
    
    //---------------------------------------------------------//
    //---passing configuration to agent-----------------------//
    //-------------------------------------------------------//
        if(!uvm_config_db#(retry_env_config)::get(this,"" , "retry_env_config" , env_config_env))
        begin
          `uvm_fatal(get_full_name() , "Error in retry_env !#");
        end

        uvm_config_db#(retry_env_config)::set(this , "agent" , "retry_env_config" , env_config_env);
    
    
    
    //---------------------------------------------------------------//
    //---creating agent--------------------------------------------//
    //-------------------------------------------------------------//
    agent         = retry_agent::type_id::create("agent" , this);

    
    
    //---------------------------------------------------------------//
    //---creating environemnts components based on configurations---//
    //-------------------------------------------------------------//
    if(env_config_env.has_subsc)
    begin
    subscriber  = retry_subscriber::type_id::create("subscriber" , this);      
    end
    
    if(env_config_env.has_sb)  
    begin  
    scoreboard   = retry_scoreboard::type_id::create("scoreboard" , this); 
    end
    //---------------------------------------------------------------------//
    //-----getting the virtual interface that is in resource database-----//
    //-------------------------------------------------------------------//

    if (!uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "retry_vif" , 
                                        retry_vif
                                        ) 
       )
      begin
        `uvm_fatal(get_full_name() , "Error in retry_env !#");
      end
    
    else
      begin
      
      uvm_config_db#(virtual retry_intf) :: set(
                                      this,
                                       "agent",
                                       "retry_vif",
                                       retry_vif
      );
        
      
        
        
      end
    
    
    
    
    
    $display("build_phase of retry_env is on the wheel  ,  retry_vif = %p!!" , retry_vif);
  endfunction
  
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    
    if(env_config_env.has_subsc)    
    begin
    agent.controller_analysis_port.connect(subscriber.controller_analysis_export);
    agent.reg_file_analysis_port.connect(subscriber.reg_file_analysis_export);
    agent.ctrl_flt_pkr_analysis_port.connect(subscriber.ctrl_flt_pkr_analysis_export);
    agent.unpacker_analysis_port.connect(subscriber.unpacker_analysis_export);
    end

    if(env_config_env.has_sb)    
    begin
    agent.controller_analysis_port.connect(scoreboard.controller_analysis_export);
    agent.reg_file_analysis_port.connect(scoreboard.reg_file_analysis_export);
    agent.ctrl_flt_pkr_analysis_port.connect(scoreboard.ctrl_flt_pkr_analysis_export);
    agent.unpacker_analysis_port.connect(scoreboard.unpacker_analysis_export);    
    $display("connect_phase of retry_env is on the wheel !!");
    end
  endfunction
  
  
  
  
  int elemnets_no = 0;
  
  virtual task run_phase (uvm_phase phase);
   $display("run_phase of retry_env");
   super.run_phase(phase);
    
    

    
  endtask
  
  
endclass


endpackage