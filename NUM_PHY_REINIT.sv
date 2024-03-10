/*
* Project        : CXL Controller 
* Module name    : NUM_PHY_REINIT
* Owner          : Mahmoud Saied Ismail Allam
*/

module NUM_PHY_REINIT (
    
    input  logic       i_clk, i_rst_n,

    input  logic       retryable_flit_detected_sig, 
    input  logic       num_phy_reinit_inc_en,
    input  logic       empty_bit_detected_reset,
    
    output logic [4:0] retry_num_phy_reinit
);
    
always_ff @( posedge i_clk, negedge i_rst_n ) begin 
   
    if (!i_rst_n) begin
        retry_num_phy_reinit <= 5'b0;
    end
    else if (retryable_flit_detected_sig || empty_bit_detected_reset) begin
        retry_num_phy_reinit <= 5'b0;
    end
    else if (num_phy_reinit_inc_en) begin
        retry_num_phy_reinit <= retry_num_phy_reinit + 5'b1;
    end
end

endmodule