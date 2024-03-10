/*
* Project        : CXL Controller 
* Module name    : LLRB
* Owner          : Mahmoud Saied Ismail Allam
*/

module LLRB 
    (
        input  logic             i_clk, i_rst_n,

        input  logic             controller_wr_en, controller_rd_en,
        input  logic             rd_ptr_eseq_set, 
        input  logic     [7:0]   unpacker_rdptr_eseq_num,  
        input  logic  [527 :0]   crc_generator_flit_w_crc,

        output logic             retry_stop_read,
        output logic  [527 :0]   retry_llrb_flit,
        output logic  [7:0]      retry_wrt_ptr
    );

    localparam BUFFER_DEPTH = 64,
               PTR_WIDTH    = $clog2(BUFFER_DEPTH);
    
    logic [PTR_WIDTH-1 : 0] wr_ptr, rd_ptr;
    
    logic [527:0] buffer [0: BUFFER_DEPTH-1];
    
    integer i;
    
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        
        if (!i_rst_n) begin  
            for (i=0; i<BUFFER_DEPTH; i=i+1) begin
                buffer [i] <= 527'b0; // initialization for the LLRB
            end
            wr_ptr <= {PTR_WIDTH{1'b0}}; // initialize the wr_ptr with the fii_rst_n position in the LLRB
        end
    
        else if (controller_wr_en) begin
            buffer [wr_ptr] <= crc_generator_flit_w_crc;
            wr_ptr          <= wr_ptr + ({{(PTR_WIDTH-1){1'b0}}, 1'b1});
        end
    end
    
    //! Write Ptr Value 
    assign retry_wrt_ptr = wr_ptr;

    always_ff @( posedge i_clk or negedge i_rst_n ) begin
        
        if (!i_rst_n) begin
            rd_ptr          <=  {PTR_WIDTH{1'b0}}; // initialize the rd_ptr with the fii_rst_n position in the LLRB
        end
        else if (rd_ptr_eseq_set) begin
            rd_ptr <= unpacker_rdptr_eseq_num; // To take the Eseq found in the Retry.Req flit
        end
        else if (controller_rd_en && !retry_stop_read) begin
            rd_ptr <= rd_ptr + ({{(PTR_WIDTH-1){1'b0}}, 1'b1});
        end
    end

    assign retry_llrb_flit = buffer [rd_ptr]; 
    
    assign retry_stop_read = (rd_ptr == wr_ptr); // This means that the flits required to be read are done
                                                 //! Check the condition

 endmodule 