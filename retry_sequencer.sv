



package retry_seqr_pkg;
import uvm_pkg::*;
import retry_seq_item_pkg::*;
`include "uvm_macros.svh"



class retry_sequencer extends uvm_sequencer #(retry_seq_item);
  
  
  `uvm_component_utils(retry_sequencer);
  
  function new(string name = "retry_sequencer" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    $display("build_phase of retry_sequencer is on the wheel!!");
  endfunction
  
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("connect_phase of retry_sequencer is on the wheel!!");
  endfunction
  
  
  
  
  
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("run_phase of retry_sequencer");

  endtask
  
endclass


endpackage