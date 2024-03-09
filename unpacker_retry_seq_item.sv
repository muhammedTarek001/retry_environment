package unpacker_retry_seq_item_pkg ; 

import uvm_pkg::*;
`include "uvm_macros.svh"

class unpacker_retry_seq_item extends uvm_sequence_item;
`uvm_object_utils(unpacker_retry_seq_item);

function new (string name = "unpacker_retry_seq_item");
super.new(name) ;
endfunction

//------unpacker signals-----//
rand logic	 discard_received_flits;
rand logic 	 unpacker_req_seq_flag, unpacker_flit_type, 
          	 unpacker_all_data_flit_flag, unpacker_valid_sig, 
	  	     unpacker_ack_seq_flag, unpacker_valid_crc,  
          	 unpacker_empty_bit;
rand logic [3:0]   unpacker_llctrl_subtype, unpacker_llctrl;
rand logic [4:0]   unpacker_retryreq_num;
rand logic [7:0]   unpacker_full_ack, unpacker_rdptr_eseq_num;

//-------CRC generator signals------//
rand logic [527 :0]   crc_generator_flit_w_crc;

//outputs
logic              retry_exist_retry_state;



endclass
endpackage
