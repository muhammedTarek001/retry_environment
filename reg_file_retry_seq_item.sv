package reg_file_retry_seq_item_pkg ; 

import uvm_pkg::*;
`include "uvm_macros.svh"

class reg_file_retry_seq_item extends uvm_sequence_item;
`uvm_object_utils(reg_file_retry_seq_item);

function new (string name = "reg_file_retry_seq_item");
super.new(name) ;
endfunction

//------register file signals-----//
rand bit         i_register_file_interface_sel;
rand bit [4:0]   i_register_file_retry_threshold, 
                 i_register_file_reinit_threshold;
rand bit [7:0]   i_register_file_llr_wrap_value;                 
rand bit [12:0]  i_register_file_retry_timeout_max_transfers;

//outputs
bit              REINIT_Threshold_hit, Retry_Threshold_hit,
                 Retry_Threshold_hit_en, REINIT_Threshold_hit_en,
		 Link_Failure_Indicator_Register;
bit [7:0]        LL_Retry_Buffer_Consumed;


endclass
endpackage
