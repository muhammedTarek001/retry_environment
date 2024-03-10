/*
* Project        : CXL Controller 
* Module name    : Num_Free_Buff
* Owner          : Mahmoud Saied Ismail Allam
*/

module Num_Free_Buff (
    
    input  logic       i_clk, i_rst_n,
    
    input  logic [7:0] unpacker_full_ack, 
    input  logic       controller_wr_en, 
    input  logic       llctrl_acknowledge_flit_detected_sig,
    input  logic       protocol_flit_detected_sig, i_register_file_interface_sel,

    output logic [7:0] retry_num_free_buff
);

logic [7:0] inc_val;

assign inc_val = llctrl_acknowledge_flit_detected_sig ? unpacker_full_ack : {4'b0,(unpacker_full_ack[3] && !i_register_file_interface_sel),3'b0};

nbit_up_dn_counter #(.DATA_WIDTH (8), .INITIAL_VAL (8'd64)) num_ack_counter (
    .i_inc_en    (protocol_flit_detected_sig || llctrl_acknowledge_flit_detected_sig),
    .i_inc_val   (inc_val),
    .i_dec_en    (controller_wr_en),
    .i_dec_val   (8'b1),
    .o_count_val (retry_num_free_buff),
    .*
);

endmodule