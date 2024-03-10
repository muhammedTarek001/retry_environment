/*
* Project        : CXL Controller 
* Module name    : Retryable_Detector
* Owner          : Mahmoud Saied Ismail Allam
*/

module Retryable_Detector (
    input  logic [3:0] unpacker_llctrl_subtype, unpacker_llctrl,
    input  logic       unpacker_flit_type, 
    input  logic       unpacker_valid_sig, unpacker_valid_crc,
    input  logic       unpacker_all_data_flit_flag, discard_received_flits,

    output logic       retryable_flit_detected_sig, 
    output logic       llctrl_acknowledge_flit_detected_sig,
    output logic       protocol_flit_detected_sig
    
);

logic valid_control_sig;

assign valid_control_sig = unpacker_valid_crc && unpacker_valid_sig && !discard_received_flits;
    
assign retryable_flit_detected_sig = valid_control_sig  
                                  && (unpacker_all_data_flit_flag 
                                  || unpacker_llctrl != 4'b0001 
                                  || !unpacker_flit_type);

assign protocol_flit_detected_sig = valid_control_sig && !unpacker_all_data_flit_flag 
                                 && !unpacker_flit_type ;

assign llctrl_acknowledge_flit_detected_sig = valid_control_sig && !unpacker_all_data_flit_flag 
                                          &&  (unpacker_llctrl == 4'b0000) 
                                          &&  (unpacker_llctrl_subtype == 4'b0001) 
                                          &&  unpacker_flit_type;
endmodule