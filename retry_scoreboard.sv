


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
  
virtual retry_intf vif;

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
    
    
    if (!uvm_config_db#(virtual retry_intf)::get(
                                        this ,
                                        "",
                                        "vif" , 
                                        vif
                                        ) 
       )
      
        `uvm_fatal(get_full_name() , "Error in retry_agent !#");
    
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
  
  virtual task run_phase (uvm_phase phase);  
    super.run_phase(phase);
    phase.raise_objection(this);
    $display("run_phase of retry_scorreboard");
    controller_tlm_fifo.get(controller_retry_seq);
    reg_file_tlm_fifo.get(reg_file_retry_seq);
    unpacker_tlm_fifo.get(unpacker_retry_seq);
    ctrl_flt_pkr_tlm_fifo.get(ctrl_flt_pkr_retry_seq);
    $display("working on it %d %d %d %d" ,reg_file_retry_seq.i_register_file_retry_threshold,  unpacker_retry_seq.unpacker_llctrl , controller_retry_seq.o_lp_state_req , ctrl_flt_pkr_retry_seq.retry_num_retry);
    phase.drop_objection(this);

  endtask
  
  
endclass


endpackage