/*
* Project        : CXL Controller 
* Module name    : Retry_Top_module
* Owner          : Abdelrahman Mohamed Mahdy
*/

module Retry_Top_Module
(
    input     logic            i_clk, i_rst_n,
    input     logic            controller_dec_num_ack, controller_llcrd_full_ack_sent, 
                               controller_ack_sent_flag, unpacker_req_seq_flag, 
                               unpacker_flit_type, unpacker_all_data_flit_flag, 
                               unpacker_valid_sig, unpacker_ack_seq_flag, i_pl_lnk_up, 
                               unpacker_valid_crc, controller_req_sent_flag, 
                               unpacker_empty_bit, controller_inc_time_out_retry, 
                               controller_wr_en, controller_rd_en,

    input     logic [7:0]      unpacker_full_ack, 
                               i_register_file_llr_wrap_value, 
                               unpacker_rdptr_eseq_num,

    input     logic [3:0]      unpacker_llctrl_subtype, 
                               unpacker_llctrl, 
                               i_pl_state_sts, 
                               o_lp_state_req,

    input     logic [4:0]      i_register_file_retry_threshold, 
                               i_register_file_reinit_threshold, 
                               unpacker_retryreq_num,

    input     logic [12:0]     i_register_file_retry_timeout_max_transfers,
    input     logic [527 :0]   crc_generator_flit_w_crc,
    input     logic            initialization_done, discard_received_flits,
    input     logic            rd_ptr_eseq_set,
    input     logic            i_register_file_interface_sel,
    
    output    logic            retry_send_ack_seq, retry_set_ack_bit, 
                               retry_phy_reinit_req, retry_send_req_seq, 
                               retry_link_failure_sig, retry_stop_read,

    output    logic [7:0]      retry_num_ack, retry_num_free_buff, retry_eseq,

    output    logic [4:0]      retry_num_retry, retry_num_phy_reinit,
    output    logic [527 :0]   retry_llrb_flit,
    output    logic [7:0]      retry_wrt_ptr,
    output    logic            retry_exist_retry_state, 

    output    logic [7:0]      LL_Retry_Buffer_Consumed,
    output    logic            REINIT_Threshold_hit, Retry_Threshold_hit, 
    output    logic            Link_Failure_Indicator_Register,
                               Retry_Threshold_hit_en, REINIT_Threshold_hit_en
);

logic retryable_flit_detected_sig;
logic llctrl_acknowledge_flit_detected_sig;
logic protocol_flit_detected_sig;
logic num_retry_matches;
logic timeout_reset;
logic num_retry_and_phyreinit_reset;
logic timeout_enable;
logic num_retry_inc_en;
logic num_phy_reinit_inc_en;
logic num_retry_reset;
logic timeout_reached;
logic transition_to_local_idle;
logic transition_to_retry_abort;
logic transition_to_phy_reinit;
logic phy_reinit;
logic phy_reset;
logic empty_bit_detected_reset;
logic max_retry, max_phy_reinit;

assign phy_reinit                      = (o_lp_state_req == 4'b1011);
assign phy_reset                       = ~|i_pl_state_sts;
assign max_phy_reinit                  = (i_register_file_reinit_threshold == retry_num_phy_reinit);
assign max_retry                       = (retry_num_retry == i_register_file_retry_threshold);
assign transition_to_retry_abort       =  max_phy_reinit && max_retry;
assign transition_to_phy_reinit        = (i_register_file_reinit_threshold > retry_num_phy_reinit) && (i_register_file_retry_threshold == retry_num_retry);
assign transition_to_local_idle        = (controller_req_sent_flag && (i_register_file_retry_threshold > retry_num_retry));
assign empty_bit_detected_reset        = unpacker_empty_bit && num_retry_and_phyreinit_reset;
   
assign REINIT_Threshold_hit            = max_phy_reinit && REINIT_Threshold_hit_en;
assign REINIT_Threshold_hit_en         = |retry_num_phy_reinit;
assign Retry_Threshold_hit             =  max_retry && Retry_Threshold_hit_en;
assign Retry_Threshold_hit_en          = |retry_num_retry;
assign LL_Retry_Buffer_Consumed        = 8'd255 - retry_num_free_buff;

assign Link_Failure_Indicator_Register = retry_link_failure_sig;

RRSM U0_RRSM
(
    .*
);

Num_Ack U1_Num_Ack
(
    .*
);

Retryable_Detector U2_Retryable_Detector
(
    .*
);

Num_Free_Buff U3_Num_Free_Buff
(
    .*
);

Eseq_Num U4_Eseq_Num
(
    .*
);

LRSM U5_LRSM
(
    .*
);

Time_Out U6_Time_Out
(    
    .*
);

LLRB U7_LLRB
(
    .*
);

NUM_RETRY U8_NUM_RETRY
(
    .*
);

NUM_PHY_REINIT U9_NUM_PHY_REINIT
(
    .*  
);

endmodule : Retry_Top_Module