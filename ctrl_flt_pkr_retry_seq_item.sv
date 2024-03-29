
package ctrl_flt_pkr_retry_seq_item_pkg ; 

import uvm_pkg::*;
`include "uvm_macros.svh"

class ctrl_flt_pkr_retry_seq_item extends uvm_sequence_item;
`uvm_object_utils(ctrl_flt_pkr_retry_seq_item);

function new (string name = "ctrl_flt_pkr_retry_seq_item");
super.new(name) ;
endfunction

//----physical layer signals---//
rand logic     	 i_pl_lnk_up;
rand logic [3:0]   i_pl_state_sts;

//----output to packer -------//   
logic              retry_set_ack_bit; 
 
                
//----outputs to control flit packer------//
logic [4:0]      retry_num_retry, retry_num_phy_reinit;
logic [7:0]      retry_num_ack, retry_num_free_buff, 
	       retry_eseq, retry_wrt_ptr;

// output to MUX-2
logic [527 :0]   retry_llrb_flit;



endclass
endpackage
