
import test_pkg::* ; 

module retry_testbench;

import uvm_pkg::*;
`include "uvm_macros.svh"

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit i_clk;

  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 i_clk = ~i_clk;
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  retry_intf retry_if(i_clk);
  
Retry_Top_Module u0_retry (
//--------module inputs----------------------//
.i_clk(i_clk),
.i_rst_n ( retry_if.i_rst_n),
.controller_dec_num_ack ( retry_if.controller_dec_num_ack),
.controller_llcrd_full_ack_sent ( retry_if.controller_llcrd_full_ack_sent),
.controller_ack_sent_flag ( retry_if.controller_ack_sent_flag),
.unpacker_req_seq_flag ( retry_if.unpacker_req_seq_flag),
.unpacker_flit_type ( retry_if.unpacker_flit_type),
.unpacker_all_data_flit_flag ( retry_if.unpacker_all_data_flit_flag),
.unpacker_valid_sig ( retry_if.unpacker_valid_sig),
.unpacker_ack_seq_flag ( retry_if.unpacker_ack_seq_flag),
.i_pl_lnk_up ( retry_if.i_pl_lnk_up),
.unpacker_valid_crc ( retry_if.unpacker_valid_crc),
.controller_req_sent_flag ( retry_if.controller_req_sent_flag),
.unpacker_empty_bit ( retry_if.unpacker_empty_bit),
.controller_inc_time_out_retry ( retry_if.controller_inc_time_out_retry),
.controller_wr_en ( retry_if.controller_wr_en),
.controller_rd_en(retry_if.controller_rd_en) ,
.unpacker_full_ack ( retry_if.unpacker_full_ack),
.i_register_file_llr_wrap_value ( retry_if.i_register_file_llr_wrap_value),
.unpacker_rdptr_eseq_num ( retry_if.unpacker_rdptr_eseq_num),
.unpacker_llctrl_subtype ( retry_if.unpacker_llctrl_subtype),
.unpacker_llctrl ( retry_if.unpacker_llctrl),
.i_pl_state_sts ( retry_if.i_pl_state_sts),
.o_lp_state_req ( retry_if.o_lp_state_req),
.i_register_file_retry_threshold ( retry_if.i_register_file_retry_threshold),
.i_register_file_reinit_threshold ( retry_if.i_register_file_reinit_threshold),
.unpacker_retryreq_num ( retry_if.unpacker_retryreq_num),
.i_register_file_retry_timeout_max_transfers ( retry_if.i_register_file_retry_timeout_max_transfers),
.crc_generator_flit_w_crc ( retry_if.crc_generator_flit_w_crc),
.initialization_done ( retry_if.initialization_done),
.discard_received_flits ( retry_if.discard_received_flits),
.rd_ptr_eseq_set ( retry_if.rd_ptr_eseq_set),
.i_register_file_interface_sel ( retry_if.i_register_file_interface_sel),


//--------module outputs----------------------//
.retry_num_ack   (retry_if.retry_num_ack),
.retry_num_free_buff  (retry_if.retry_num_free_buff),
.retry_eseq  ( retry_if.retry_eseq),
.retry_num_retry   ( retry_if.retry_num_retry),
.retry_num_phy_reinit   ( retry_if.retry_num_phy_reinit),
.retry_llrb_flit  ( retry_if.retry_llrb_flit),
.retry_wrt_ptr  ( retry_if.retry_wrt_ptr),
.retry_exist_retry_state  ( retry_if.retry_exist_retry_state),
.LL_Retry_Buffer_Consumed   ( retry_if.LL_Retry_Buffer_Consumed),
.REINIT_Threshold_hit   ( retry_if.REINIT_Threshold_hit),
.Retry_Threshold_hit  ( retry_if.Retry_Threshold_hit),
.Link_Failure_Indicator_Register ( retry_if.Link_Failure_Indicator_Register),
.Retry_Threshold_hit_en ( retry_if.Retry_Threshold_hit_en),
.REINIT_Threshold_hit_en ( retry_if.REINIT_Threshold_hit_en),
.retry_stop_read(retry_if.retry_stop_read),
.retry_send_req_seq(retry_if.retry_send_req_seq),
.retry_phy_reinit_req(retry_if.retry_phy_reinit_req),
.retry_send_ack_seq(retry_if.retry_send_ack_seq),
.retry_set_ack_bit(retry_if.retry_set_ack_bit),
.retry_link_failure_sig(retry_if.retry_link_failure_sig)
);


initial
begin
  uvm_config_db#(virtual retry_intf)::set(null,"uvm_test_top","vif",retry_if);
// `uvm_info("retry", "display", UVM_LOW);
  // $display("dut is properly connected to intf, %d" ,u0_retry.o_lp_state_req);
  run_test("retry_test");
end



endmodule