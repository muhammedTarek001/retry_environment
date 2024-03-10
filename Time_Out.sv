/*
* Project        : CXL Controller 
* Module name    : Time_Out
* Owner          : Mahmoud Saied Ismail Allam
*/

module Time_Out (

    input  logic        i_clk, i_rst_n,
 
    input  logic        timeout_enable, timeout_reset,
    input  logic        controller_inc_time_out_retry,
    input  logic [12:0] i_register_file_retry_timeout_max_transfers, 
    
    output logic        timeout_reached
);
  
logic [12:0] timeout_reg;

always_ff @( posedge i_clk, negedge i_rst_n ) begin

    if (!i_rst_n) begin
        timeout_reg <= 13'b0;
    end
    else if (timeout_reset) begin
        timeout_reg <= 13'b0;
    end
    else if (controller_inc_time_out_retry && timeout_enable) begin
        timeout_reg <= timeout_reg + 13'b1;
    end
end

assign timeout_reached = (i_register_file_retry_timeout_max_transfers == timeout_reg);

endmodule