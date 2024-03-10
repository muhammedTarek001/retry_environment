/*
* Project        : CXL Controller 
* Module name    : Eseq_Num
* Owner          : Mahmoud Saied Ismail Allam
*/

module Eseq_Num (
    input  logic       i_rst_n, i_clk,
    
    input  logic [7:0] i_register_file_llr_wrap_value,
    input  logic       retryable_flit_detected_sig,

    output logic [7:0] retry_eseq

);


logic retry_eseq_zero_flag;

assign retry_eseq_zero_flag = (retry_eseq == 8'b0);

always_ff @( posedge i_clk, negedge i_rst_n ) begin
    if (!i_rst_n) begin
        retry_eseq <= 8'b0;
    end
    else if ((i_register_file_llr_wrap_value == retry_eseq) && !retry_eseq_zero_flag) begin
        retry_eseq <= 8'b0;
    end
    else if (retryable_flit_detected_sig) begin
        retry_eseq <= retry_eseq + 8'b1;
    end
end

endmodule