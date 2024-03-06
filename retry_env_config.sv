

package retry_env_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class retry_env_config extends uvm_object;
    
    `uvm_object_utils(retry_env_config);

    function new(string name = "uvm_object");
        super.new();
    endfunction //new()
    
    //------configuring agents--------// 
    bit agents_are_active = 0;
    
    //------configuring subscribers and SB----//
    bit has_sb = 1;
    bit has_subsc = 1;

    
endclass 

endpackage