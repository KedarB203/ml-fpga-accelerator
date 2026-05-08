module output_buffer(
    input   clk,
    input   rst,

    input   [31:0] in_data,
    output         out_valid,
    output  [31:0] out_data,
    input          out_ready
);
endmodule