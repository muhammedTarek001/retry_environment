
module change_observer (
input logic      	 i_clk, i_rst_n,

// output signals//
input logic 		retry_send_ack_seq, retry_phy_reinit_req, 
                retry_send_req_seq, retry_link_failure_sig, 
	            retry_stop_read,

//------unpacker signals-----//
//outputs
input logic              retry_exist_retry_state,


//------register file signals-----//
//outputs
input logic              REINIT_Threshold_hit, Retry_Threshold_hit,
                 Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
		 Link_Failure_Indicator_Register,
input logic [7:0]        LL_Retry_Buffer_Consumed,


//-------CRC generator signals------//
//-------output to packer ---------------//   
input logic              retry_set_ack_bit, 
 
                
//-------outputs to control flit packer----------//
input logic [4:0]      retry_num_retry, retry_num_phy_reinit,
input logic [7:0]      retry_num_ack, retry_num_free_buff, 
	       retry_eseq, retry_wrt_ptr,

// output to MUX-2
input logic [527 :0]   retry_llrb_flit,


// states
input logic [3:0] LRSM,
input logic [2:0] RRSM,

input bit observer_on
);






assert property (@(posedge i_clk) $stable(retry_send_ack_seq))
else $display("assert_msg::    retry_send_ack_seq changed: %d ----> %d, @time = %t", $past(retry_send_ack_seq,1, ) , retry_send_ack_seq, $time);


assert property (@(posedge i_clk) $stable(retry_phy_reinit_req))
else $display("assert_msg::    retry_phy_reinit_req changed: %d ----> %d, @time = %t", $past(retry_phy_reinit_req,1, ) , retry_phy_reinit_req, $time);


assert property (@(posedge i_clk) $stable(retry_send_req_seq))
else $display("assert_msg::    retry_send_req_seq changed: %d ----> %d, @time = %t", $past(retry_send_req_seq,1, ) , retry_send_req_seq, $time);

assert property (@(posedge i_clk) $stable(retry_link_failure_sig))
else $display("assert_msg::    retry_link_failure_sig changed: %d ----> %d, @time = %t", $past(retry_link_failure_sig,1, ) , retry_link_failure_sig, $time);

assert property (@(posedge i_clk) $stable(retry_stop_read))
else $display("assert_msg::    retry_stop_read changed: %d ----> %d, @time = %t", $past(retry_stop_read,1, ) , retry_stop_read, $time);

assert property (@(posedge i_clk) $stable(retry_exist_retry_state))
else $display("assert_msg::    retry_exist_retry_state changed: %d ----> %d, @time = %t", $past(retry_exist_retry_state,1, ) , retry_exist_retry_state, $time);

assert property (@(posedge i_clk) $stable(REINIT_Threshold_hit))
else $display("assert_msg::    REINIT_Threshold_hit changed: %d ----> %d, @time = %t", $past(REINIT_Threshold_hit,1, ) , REINIT_Threshold_hit, $time);

assert property (@(posedge i_clk) $stable(Retry_Threshold_hit))
else $display("assert_msg::    Retry_Threshold_hit changed: %d ----> %d, @time = %t", $past(Retry_Threshold_hit,1, ) , Retry_Threshold_hit, $time);

assert property (@(posedge i_clk) $stable(Retry_Threshold_hit_en))
else $display("assert_msg::    Retry_Threshold_hit_en changed: %d ----> %d, @time = %t", $past(Retry_Threshold_hit_en,1, ) , Retry_Threshold_hit_en, $time);

assert property (@(posedge i_clk) $stable(REINIT_Threshold_hit_en))
else $display("assert_msg::    REINIT_Threshold_hit_en changed: %d ----> %d, @time = %t", $past(REINIT_Threshold_hit_en,1, ) , REINIT_Threshold_hit_en, $time);

assert property (@(posedge i_clk) $stable(Link_Failure_Indicator_Register))
else $display("assert_msg::    Link_Failure_Indicator_Register changed: %d ----> %d, @time = %t", $past(Link_Failure_Indicator_Register,1, ) , Link_Failure_Indicator_Register, $time);

assert property (@(posedge i_clk) $stable(LL_Retry_Buffer_Consumed))
else $display("assert_msg::    LL_Retry_Buffer_Consumed changed: %d ----> %d, @time = %t", $past(LL_Retry_Buffer_Consumed,1, ) , LL_Retry_Buffer_Consumed, $time);

assert property (@(posedge i_clk) $stable(retry_set_ack_bit))
else $display("assert_msg::    retry_set_ack_bit changed: %d ----> %d, @time = %t", $past(retry_set_ack_bit,1, ) , retry_set_ack_bit, $time);

assert property (@(posedge i_clk) $stable(retry_num_retry))
else $display("assert_msg::    retry_num_retry changed: %d ----> %d, @time = %t", $past(retry_num_retry,1, ) , retry_num_retry, $time);

assert property (@(posedge i_clk) $stable(retry_num_phy_reinit))
else $display("assert_msg::    retry_num_phy_reinit changed: %d ----> %d, @time = %t", $past(retry_num_phy_reinit,1, ) , retry_num_phy_reinit, $time);


assert property (@(posedge i_clk) $stable(retry_num_ack))
else $display("assert_msg::    retry_num_ack changed: %d ----> %d, @time = %t", $past(retry_num_ack,1, ) , retry_num_ack, $time);


assert property (@(posedge i_clk) $stable(retry_num_free_buff))
else $display("assert_msg::    retry_num_free_buff changed: %d ----> %d, @time = %t", $past(retry_num_free_buff,1, ) , retry_num_free_buff, $time);


assert property (@(posedge i_clk) $stable(retry_eseq))
else $display("assert_msg::    retry_eseq changed: %d ----> %d, @time = %t", $past(retry_eseq,1, ) , retry_eseq, $time);


assert property (@(posedge i_clk) $stable(retry_wrt_ptr))
else $display("assert_msg::    retry_wrt_ptr changed: %d ----> %d, @time = %t", $past(retry_wrt_ptr,1, ) , retry_wrt_ptr, $time);


assert property (@(posedge i_clk) $stable(retry_llrb_flit))
else $display("assert_msg::    retry_llrb_flit changed: %d ----> %d, @time = %t", $past(retry_llrb_flit,1, ) , retry_llrb_flit, $time);


assert property (@(posedge i_clk) $stable(LRSM))
else $display("assert_msg::    LRSM changed: %d ----> %d, @time = %t", $past(LRSM,1, ) , LRSM, $time);


assert property (@(posedge i_clk) $stable(RRSM))
else $display("assert_msg::    RRSM changed: %d ----> %d, @time = %t", $past(RRSM,1, ) , RRSM, $time);
endmodule


