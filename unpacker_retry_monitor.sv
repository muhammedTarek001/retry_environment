
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
    unpacker_retry_seq.unpacker_llctrl= 2;

    unpacker_retry_port.write(unpacker_retry_seq);
    $display("run_phase of unpacker_retry_monitor ");
  endtask
  
endclass


endpackage