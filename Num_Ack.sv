/*
* Project        : CXL Controller 
* Module name    : Num_Ack
* Owner          : Mahmoud Saied Ismail Allam
*/

module Num_Ack (
    
    input  logic       i_clk, i_rst_n,
    
    input  logic       controller_dec_num_ack, controller_llcrd_full_ack_sent,
    input  logic       retryable_flit_detected_sig,

    output logic       retry_set_ack_bit, 
    output logic [7:0] retry_num_ack

);

logic [7:0] dec_val;

assign dec_val = controller_llcrd_full_ack_sent ? retry_num_ack : 8'b1000;

nbit_up_dn_counter #(.DATA_WIDTH (8), .INITIAL_VAL (8'b0)) num_ack_counter (
    .i_inc_en    (retryable_flit_detected_sig),
    .i_inc_val   (8'b1),
    .i_dec_en    (controller_llcrd_full_ack_sent || (retry_set_ack_bit && controller_dec_num_ack)),
    .i_dec_val   (dec_val),
    .o_count_val (retry_num_ack),
    .*
);

assign retry_set_ack_bit = (retry_num_ack >= 8'b1000);

endmodule