


package sb_pkg;
  
import uvm_pkg::*;
`include "uvm_macros.svh"
import retry_seq_item_pkg::*;
import controller_retry_seq_item_pkg::*;
import reg_file_retry_seq_item_pkg::*;
import ctrl_flt_pkr_retry_seq_item_pkg::*;
import unpacker_retry_seq_item_pkg::*;

class retry_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(retry_scoreboard);
  

  controller_retry_seq_item  controller_retry_seq;
  reg_file_retry_seq_item  reg_file_retry_seq;
  ctrl_flt_pkr_retry_seq_item ctrl_flt_pkr_retry_seq;                 
  unpacker_retry_seq_item unpacker_retry_seq;      
  //--------------------------------------------------------------------------------------------------------------//
  //---defining fifos that receive seq items from monitors, exports and ports that gets seq items from fifos-----//
  //------------------------------------------------------------------------------------------------------------//
  uvm_analysis_export#(controller_retry_seq_item) controller_analysis_export; 
  uvm_tlm_analysis_fifo#(controller_retry_seq_item) controller_tlm_fifo;

  uvm_analysis_export#(reg_file_retry_seq_item) reg_file_analysis_export; 
  uvm_tlm_analysis_fifo#(reg_file_retry_seq_item) reg_file_tlm_fifo;

  uvm_analysis_export#(ctrl_flt_pkr_retry_seq_item) ctrl_flt_pkr_analysis_export;   
  uvm_tlm_analysis_fifo#(ctrl_flt_pkr_retry_seq_item) ctrl_flt_pkr_tlm_fifo;

  uvm_analysis_export#(unpacker_retry_seq_item) unpacker_analysis_export;   
  uvm_tlm_analysis_fifo#(unpacker_retry_seq_item) unpacker_tlm_fifo;
  //------------------------------------------------------------------------------------------------//
  //------------------------------------------------------------------------------------------------//
  
  
  function new(string name = "retry_scoreboard" , uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
   //-----------------------------------------------//
    //--------creating sequence items --------------//
    //---------------------------------------------//
    controller_retry_seq = controller_retry_seq_item::type_id::create("controller_retry_seq"); 
    reg_file_retry_seq = reg_file_retry_seq_item::type_id::create("reg_file_retry_seq"); 
    ctrl_flt_pkr_retry_seq = ctrl_flt_pkr_retry_seq_item::type_id::create("ctrl_flt_pkr_retry_seq"); 
    unpacker_retry_seq = unpacker_retry_seq_item::type_id::create("unpacker_retry_seq"); 
    //---------------------------------------------//
    //---------------------------------------------//

    
    
    //---------------------------------------------------------------------------//
    //---defining fifos that receive seq items from monitors, exports and ports that gets seq items from fifos-----//
    //---------------------------------------------------------------------------//
    controller_analysis_export = new("controller_analysis_export" , this);
    controller_tlm_fifo        = new("controller_tlm_fifo" , this);

    reg_file_analysis_export = new("reg_file_analysis_export" , this);
    reg_file_tlm_fifo        = new("reg_file_tlm_fifo" , this);

    unpacker_analysis_export = new("unpacker_analysis_export" , this);
    unpacker_tlm_fifo        = new("unpacker_tlm_fifo" , this);

    ctrl_flt_pkr_analysis_export = new("ctrl_flt_pkr_analysis_export" , this);
    ctrl_flt_pkr_tlm_fifo        = new("ctrl_flt_pkr_tlm_fifo" , this);
    //---------------------------------------------------------------------------//
    //---------------------------------------------------------------------------//


    $display("build_phase of retry_scoreboard is on the wheel!!");
    
    
    
  endfunction
  
  
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    $display("connect_phase of retry_scoreboard is on the wheel!!");

    //---------------------------------------------------------------------------//
    //---------------------------------------------------------------------------//
    controller_analysis_export.connect(controller_tlm_fifo.analysis_export);

    reg_file_analysis_export.connect(reg_file_tlm_fifo.analysis_export);

    unpacker_analysis_export.connect(unpacker_tlm_fifo.analysis_export);

    ctrl_flt_pkr_analysis_export.connect(ctrl_flt_pkr_tlm_fifo.analysis_export);
    //---------------------------------------------------------------------------//
    //---------------------------------------------------------------------------//
    

  endfunction
  // localparam RB_DEPTH = 64;
  // localparam RB_WIDTH = 528;

  // //--modelling Notes ------------------//
  // var bit [RB_WIDTH-1 : 0] LLRB [RB_DEPTH-1 : 0];
  
  // %%%% PHY layer state is passed to LRSM_model and RRSM_model functions &&&& it's supposed not to affect LLRB
  
  //-----------------------------------//
  
  task monitor_retry_req();
    @(posedge controller_retry_seq.retry_send_req_seq)
    $display("retry_send_req_seq is raised @ time = %t" , $time);
  endtask 

  //unpacker_rdptr_eseq_num == 0
    //always monitor LL_Retry_Buffer_Consumed
    //monitor retry_num_ack
    //retry_wrt_ptr

  virtual task run_phase (uvm_phase phase);  
    super.run_phase(phase);
   
    $display("run_phase of retry_scorreboard");
    phase.raise_objection(this);
    forever begin
      fork
        begin
            monitor_retry_req();
        end

        begin
            controller_tlm_fifo.get(controller_retry_seq);
            reg_file_tlm_fifo.get(reg_file_retry_seq);
            unpacker_tlm_fifo.get(unpacker_retry_seq);
            ctrl_flt_pkr_tlm_fifo.get(ctrl_flt_pkr_retry_seq);
        end
      join_any
      
    end
    phase.drop_objection(this);

  endtask
  
  
  // virtual task LRSM_model(inputs to llrsm, outputs that mainly depend on lrsm , ref crc_error_reached);
  //    LLRB_LRSM_model();

  //    if(crc_error && !PHY_reinit_raised || crc_error_reached)
  //    begin
  //     crc_error_reached = 1;
  //     1-send req sequence and wait_on req sequence sent flag reaches ++ check that any thing received except for ack is discarded 
  //     2-after that wait_on ack sequence sent flag according to timeout threshold
  //         a) If ack reaches before timeout ---> Check that llrb increases eseq + Check that valid flits received from PHY layer
  //         b) If ack didnot reach before timeout  ---> go to step 1 (we will make step 1 as a function)
  //    end

  //    else if(PHY_reinit_raised)
  //    begin
  //     wait_on link_up signal , then check on sent req signal raised and continue the same retry flow
  //    end
  // endtask

  // virtual task RRSM_model();
  //   LLRB_RRSM_model();
    
  // endtask
  
endclass


endpackage