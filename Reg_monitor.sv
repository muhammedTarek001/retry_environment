package reg_file_retry_monitor_pkg ; 
import uvm_pkg::*;
import reg_file_retry_seq_item_pkg::*;  
`include "uvm_macros.svh"

  class reg_file_retry_monitor extends uvm_monitor;
  `uvm_component_utils(reg_file_retry_monitor);

 function new(string name = "reg_file_retry_monitor" , uvm_component parent = null);
 super.new(name,parent);
 endfunction
  
  // virtual interface inst
  virtual retry_intf  vif;

  //sequence item inst
  reg_file_retry_seq_item  reg_file_retry_mon_seq;

  // port from monitor 
  uvm_analysis_port#(reg_file_retry_seq_item) reg_file_retry_port ;     

//////////////////Build phase///////////////////////////
 function void build_phase(uvm_phase phase);
 super.build_phase(phase);

 //building the port & sequence item instances
 reg_file_retry_port  = new("reg_file_retry_port " , this);
 reg_file_retry_mon_seq = reg_file_retry_seq_item::type_id::create("reg_file_retry_mon_seq");
//getting the virtual interface that is in resource database
    if ( 
          !uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        vif
                                        ) 
       )
      
    begin
      `uvm_fatal(get_full_name() , "Error in ctrl_flt_pkr_retry_agent !#");  
    end
 // checking the build phase
 $display("reg_file_retry_monitor is built");
 endfunction
 
 ////////////////connect phase/////////////////////////
 function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);

 // checking the connect phase
 $display("reg_file_retry_monitor is connected");
 endfunction
 
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    reg_file_retry_mon_seq.i_register_file_retry_threshold= 15;

    reg_file_retry_port.write(reg_file_retry_mon_seq);
    $display("run_phase of unpacker_retry_monitor, o_lp_state_req = %d", vif.o_lp_state_req);
  endtask

 endclass
 endpackage
