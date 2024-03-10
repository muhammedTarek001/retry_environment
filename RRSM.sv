/*
* Project        : CXL Controller 
* Module name    : RRSM
* Owner          : Abdelrahman Mohamed Mahdy
*/

module RRSM 
 (
    output    logic   retry_send_ack_seq,    
    input     logic   controller_ack_sent_flag, phy_reinit, unpacker_req_seq_flag, 
    input     logic   i_clk, i_rst_n
 );

 typedef enum logic [2:0] {RETRY_REMOTE_NORMAL_[1:6], 
                           RETRY_LLRACK } state ;

 state currentstate, nextstate;
 
always_ff @(posedge i_clk or negedge i_rst_n)
    begin 
        if(!i_rst_n)
            begin
                currentstate <= RETRY_REMOTE_NORMAL_1;
            end
        else 
            begin
                currentstate <= nextstate;
            end
    end
    
always_comb begin 
    nextstate = currentstate;
    
    case (currentstate)
         RETRY_REMOTE_NORMAL_1     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_REMOTE_NORMAL_2 : RETRY_REMOTE_NORMAL_1;
                                     end
                                    
         RETRY_REMOTE_NORMAL_2     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_REMOTE_NORMAL_3 : RETRY_REMOTE_NORMAL_1;
                                     end

         RETRY_REMOTE_NORMAL_3     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_REMOTE_NORMAL_4 : RETRY_REMOTE_NORMAL_1;
                                     end

         RETRY_REMOTE_NORMAL_4     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_REMOTE_NORMAL_5 : RETRY_REMOTE_NORMAL_1;
                                     end

         RETRY_REMOTE_NORMAL_5     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_REMOTE_NORMAL_6 : RETRY_REMOTE_NORMAL_1;
                                     end

         RETRY_REMOTE_NORMAL_6     : begin
                                        nextstate = unpacker_req_seq_flag ? RETRY_LLRACK : RETRY_REMOTE_NORMAL_1;
                                     end

         RETRY_LLRACK              : begin
                                        nextstate = (controller_ack_sent_flag || phy_reinit) ? RETRY_REMOTE_NORMAL_1 : RETRY_LLRACK;
                                     end

    endcase
end

assign retry_send_ack_seq = (currentstate == RETRY_LLRACK);

endmodule : RRSM