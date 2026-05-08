module weight_buffer(
    input clk,
    input rst,

    input        load,
    input        read_en,

    input  [7:0] in_data,

    output reg [7:0] out_data [0:3]
);

    reg [7:0] mem [0:15];   
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    // WRITE (load activations)
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end
        else if (load ) begin
            mem[wr_ptr] <= in_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // READ (to systolic array)
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr   <= 0;
            out_data[0] <= 0;
            out_data[1] <= 0;
            out_data[2] <= 0;
            out_data[3] <= 0;
        end
        else if (read_en & rd_ptr <= 12) begin
            out_data[0] <= mem[rd_ptr];
            out_data[1] <= mem[rd_ptr + 1];
            out_data[2] <= mem[rd_ptr + 2];
            out_data[3] <= mem[rd_ptr + 3];
            rd_ptr   <= rd_ptr + 4;
        end
    end



endmodule