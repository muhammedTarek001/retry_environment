/*
* Project        : CXL Controller 
* Module name    : nbit_up_dn_counter
* Description    : Parameterized Data Width Increment and/or Decrement Counter with Increment and 
*                  Decrement Enable signals. 
* Note           : The Counter supports Simultaneous Increment and Decrement Operations
* Owner          : Mostafa Hassanien Ahmed
*/

module nbit_up_dn_counter 
#(
     parameter DATA_WIDTH  = 7,
     parameter INITIAL_VAL = 7'b000_0000
 )
 (
    input     logic                            i_clk, i_rst_n,
    input     logic    [DATA_WIDTH - 1 : 0]    i_inc_val, i_dec_val,
    input     logic                            i_inc_en, i_dec_en,
    output    logic    [DATA_WIDTH - 1 : 0]    o_count_val 
 );

// Internal Signals
logic    [DATA_WIDTH - 1 : 0]    add_output, add_output_corrected, sub_op, sub_output;
logic                            overflow_flag;

// Control Flags 
// * Overflow Flag: To keep track if the Counter has encountered an Overflow or not 
assign overflow_flag = (add_output < o_count_val);

/*
* Add Increment Value to the Counter Register Value 
* Then, Check if there is any Overflow in the result 
* If there is Overflow, Counter should be Saturated
*/
assign add_output           = o_count_val + i_inc_val;
assign add_output_corrected = overflow_flag ? {DATA_WIDTH{1'b1}} : add_output;

// Subtract Decrement Value from the counter output (or from the adder output)
assign sub_op     = i_inc_en ? add_output_corrected : o_count_val;
assign sub_output = sub_op - i_dec_val;

// Counter Register Value 
always_ff @(posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)
            begin
                o_count_val <= INITIAL_VAL;
            end
        else 
            begin
                case ({i_inc_en, i_dec_en})
                    2'b00        : o_count_val <= o_count_val;
                    2'b01, 2'b11 : o_count_val <= sub_output;
                    2'b10        : o_count_val <= add_output_corrected;
                    default      : o_count_val <= o_count_val;
                endcase 
            end
    end

endmodule : nbit_up_dn_counter