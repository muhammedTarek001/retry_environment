


package sequence_pkg;
import uvm_pkg::*;
import retry_seq_item_pkg::*;

`include "uvm_macros.svh"


class retry_sequence extends uvm_sequence;
  
  `uvm_object_utils(retry_sequence);
  
  retry_seq_item seq_item_inst_1 ;
  
  function new(string name = "retry_sequence");
    super.new(name);
  endfunction
  task pre_body;
    seq_item_inst_1 = retry_seq_item::type_id::create("seq_item_inst_1");
  endtask
  
  
  task body;
    
  endtask
  
endclass

endpackage