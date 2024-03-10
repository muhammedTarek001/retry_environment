/*
* Project        : CXL Controller 
* Module name    : LRSM
* Owner          : Abdelrahman Mohamed Mahdy
*/

module LRSM
 (
    input     logic   i_clk, i_rst_n,
    input     logic   unpacker_valid_sig, unpacker_valid_crc, transition_to_local_idle, i_pl_lnk_up, phy_reinit, phy_reset, transition_to_retry_abort, transition_to_phy_reinit, timeout_reached, unpacker_ack_seq_flag, num_retry_matches,
    input     logic   initialization_done,

    output    logic   timeout_reset, num_retry_and_phyreinit_reset , retry_send_req_seq , num_retry_inc_en , timeout_enable , retry_phy_reinit_req , retry_link_failure_sig , num_phy_reinit_inc_en, num_retry_reset,
    output    logic   retry_exist_retry_state
 );

 enum logic [3:0] { RETRY_LOCAL_NORMAL, 
                    RETRY_LLRREQ, 
                    RETRY_LOCAL_IDLE_[1:6], 
                    RETRY_PHY_REINIT, 
                    RETRY_ABORT } currentstate, nextstate ;
 
always_ff @(posedge i_clk or negedge i_rst_n)
    begin 
        if(!i_rst_n)
            begin
                currentstate <= RETRY_LOCAL_NORMAL;
            end
        else 
            begin
                currentstate <= nextstate;
            end
    end
    
always_comb begin

    nextstate = currentstate;

    if ((phy_reinit || phy_reset) && (currentstate != RETRY_ABORT)) 
        begin
            nextstate = RETRY_PHY_REINIT;
        end 
    else 
        begin
            case (currentstate)
                 RETRY_LOCAL_NORMAL        : begin
                                                nextstate = ((unpacker_valid_sig && !unpacker_valid_crc) || initialization_done) ? RETRY_LLRREQ : RETRY_LOCAL_NORMAL;
                                             end     
                                            
                 RETRY_LLRREQ              : if (transition_to_retry_abort)
                                                   begin
                                                       nextstate = RETRY_ABORT;
                                                   end
                                             else if (transition_to_phy_reinit)
                                                   begin
                                                       nextstate = RETRY_PHY_REINIT;
                                                   end
                                             else if (transition_to_local_idle)
                                                   begin
                                                       nextstate = RETRY_LOCAL_IDLE_1;
                                                   end 
                                               
                 RETRY_LOCAL_IDLE_1         : begin
                                                    if (timeout_reached) 
                                                        begin
                                                            nextstate = RETRY_LLRREQ;
                                                        end 
                                                    else 
                                                        begin
                                                            nextstate = unpacker_ack_seq_flag ? RETRY_LOCAL_IDLE_2 : RETRY_LOCAL_IDLE_1;
                                                        end
                                              end
                                          
                 RETRY_LOCAL_IDLE_2         : begin
                                                    if (timeout_reached) 
                                                        begin
                                                            nextstate = RETRY_LLRREQ;
                                                        end 
                                                    else 
                                                        begin
                                                            nextstate = unpacker_ack_seq_flag ? RETRY_LOCAL_IDLE_3 : RETRY_LOCAL_IDLE_1;
                                                        end
                                              end
                                          
                 RETRY_LOCAL_IDLE_3         : begin
                                                    if (timeout_reached) 
                                                        begin
                                                            nextstate = RETRY_LLRREQ;
                                                        end 
                                                    else 
                                                        begin
                                                            nextstate = unpacker_ack_seq_flag ? RETRY_LOCAL_IDLE_4 : RETRY_LOCAL_IDLE_1;
                                                        end
                                              end
                                          
                 RETRY_LOCAL_IDLE_4         : begin
                                                    if (timeout_reached) 
                                                        begin
                                                            nextstate = RETRY_LLRREQ;
                                                        end 
                                                    else 
                                                        begin
                                                            nextstate = unpacker_ack_seq_flag ? RETRY_LOCAL_IDLE_5 : RETRY_LOCAL_IDLE_1;
                                                        end
                                              end
                                          
                 RETRY_LOCAL_IDLE_5         : begin 
                                                    if (timeout_reached) 
                                                        begin
                                                            nextstate = RETRY_LLRREQ;
                                                        end 
                                                    else 
                                                        begin
                                                            nextstate = unpacker_ack_seq_flag ? RETRY_LOCAL_IDLE_6 : RETRY_LOCAL_IDLE_1;
                                                        end
                                              end
                                          
                RETRY_LOCAL_IDLE_6          : if (timeout_reached)
                                                   begin
                                                       nextstate = RETRY_LLRREQ;
                                                   end
                                              else if (unpacker_ack_seq_flag && num_retry_matches)
                                                   begin
                                                       nextstate = RETRY_LOCAL_NORMAL;
                                                   end                 
                                              else  if (!unpacker_ack_seq_flag)
                                                   begin
                                                       nextstate = RETRY_LOCAL_IDLE_1;
                                                   end
                                               
                RETRY_PHY_REINIT            : begin
                                                    nextstate = i_pl_lnk_up ? RETRY_LLRREQ : RETRY_PHY_REINIT;
                                              end
                                               
                RETRY_ABORT                 :        nextstate = RETRY_ABORT;     

            endcase
        end
end

    

always_comb begin

    timeout_reset                    = 1'b0;
    num_retry_and_phyreinit_reset    = 1'b0;
    retry_send_req_seq               = 1'b0;
    num_retry_inc_en                 = 1'b0;  
    timeout_enable                   = 1'b0;  
    retry_phy_reinit_req             = 1'b0;  
    retry_link_failure_sig           = 1'b0;  
    num_phy_reinit_inc_en            = 1'b0;  
    num_retry_reset                  = 1'b0; 
    retry_exist_retry_state          = 1'b0;

    case (currentstate)
        RETRY_LLRREQ:
            begin 
                    retry_send_req_seq               = 1'b1;
                    num_retry_inc_en                 = transition_to_local_idle; 
                    num_phy_reinit_inc_en            = transition_to_phy_reinit;       
            end 

        RETRY_LOCAL_IDLE_1, 
        RETRY_LOCAL_IDLE_2,
        RETRY_LOCAL_IDLE_3,
        RETRY_LOCAL_IDLE_4,
        RETRY_LOCAL_IDLE_5 : begin 
                                timeout_reset        = timeout_reached;  
                                timeout_enable       = 1'b1;   
                             end

        RETRY_LOCAL_IDLE_6:
            begin 
                     timeout_reset                    = (timeout_reached || (unpacker_ack_seq_flag && num_retry_matches));
                     num_retry_and_phyreinit_reset    = (unpacker_ack_seq_flag && num_retry_matches);
                     retry_exist_retry_state          = num_retry_and_phyreinit_reset;
                     timeout_enable                   = 1'b1;  
            end       
        RETRY_PHY_REINIT:
            begin  
                     retry_phy_reinit_req             = 1'b1;  
                     num_retry_reset                  = i_pl_lnk_up; 
            end
        RETRY_ABORT:
            begin  
                     retry_link_failure_sig           = 1'b1;   
            end                                                
    endcase 
end
endmodule : LRSM