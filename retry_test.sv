package test_pkg;

import uvm_pkg::*; 
import env_pkg::*;
import sequence_pkg::*;
import env_config_pkg::*;

`include "uvm_macros.svh"

class retry_test extends uvm_test;
  
`uvm_component_utils(retry_test);

virtual retry_intf vif;
retry_env env;
retry_sequence seq1;
retry_env_config config_obj;

//uvm_factory factory = uvm_factory::get();


function new(string name = "retry_test" , uvm_component parent = null);
super.new(name , parent);
endfunction


function void build_phase (uvm_phase phase); 
super.build_phase(phase);
env = retry_env::type_id::create("env" , this);
seq1 = retry_sequence::type_id::create("seq1",this);
config_obj = retry_env_config::type_id::create("config_obj",this);

if(!uvm_config_db#(virtual retry_intf)::get(this,"","vif",vif))
begin
`uvm_fatal(get_full_name(),"Error in get interface in test");
end
uvm_config_db#(virtual retry_intf)::set(this,"env","retry_vif",vif);
//factory.print();
config_obj.agents_are_active = 0;
config_obj.has_sb = 1;
config_obj.has_subsc = 1;

uvm_config_db#(retry_env_config)::set(this, "env" , "retry_env_config" , config_obj);

$display("my_test is built");
endfunction


/*task run_phase (uvm_phase phase);
super.run_phase(phase);
$display("run is built");

phase.raise_objection(this);
seq1.set_response_queue_depth(512);
seq1.start(env.agent.sequencer);
phase.drop_objection(this);
endtask*/

endclass
endpackage 