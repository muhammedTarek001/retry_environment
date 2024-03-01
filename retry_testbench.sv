
import test_pkg::* ; 

module retry_testbench;

import uvm_pkg::*;
`include "uvm_macros.svh"
//including interfcae and testcase files

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;

  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  retry_intf retry_if(clk);
  
  retry_top_intf_port u0_retry(retry_if);

initial
begin
uvm_config_db#(virtual retry_intf)::set(null,"","vif",retry_if);
`uvm_info("retry", "display", UVM_LOW);
  $display("dut is properly connected to intf, %d" ,u0_retry.u0_retry.o_lp_state_req);
 run_test("retry_test");
end



endmodule