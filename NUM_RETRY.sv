/*
* Project        : CXL Controller 
* Module name    : NUM_RETRY
* Owner          : Mahmoud Saied Ismail Allam
*/

module NUM_RETRY (    
    input  logic       i_clk, i_rst_n,

    input  logic [4:0] unpacker_retryreq_num,
    input  logic       retryable_flit_detected_sig,
    input  logic       empty_bit_detected_reset,
    input  logic       num_retry_reset, num_retry_inc_en,

    output logic       num_retry_matches,
    output logic [4:0] retry_num_retry
);
    
always_ff @( posedge i_clk, negedge i_rst_n ) begin 
    if (!i_rst_n) begin
        retry_num_retry <= 5'b0;
    end
    else if (retryable_flit_detected_sig  || num_retry_reset  || empty_bit_detected_reset) begin
        retry_num_retry <= 5'b0;
    end
    else if (num_retry_inc_en) begin
        retry_num_retry <= retry_num_retry + 5'b1;
    end
end

assign num_retry_matches = (unpacker_retryreq_num == (retry_num_retry - 5'b1));

endmodule