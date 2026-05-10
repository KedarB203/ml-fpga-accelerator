module weight_buffer(
    input clk,
    input rst,

    input        load,
    input        read_en,

    input  [7:0] in_data,

    output reg [7:0] out_data [0:3][0:3]
);

    reg [7:0] mem [0:15];   
    reg [3:0] wr_ptr;
    //reg [3:0] rd_ptr;

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
            for (int r = 0; r < 4; r++)
                for (int c = 0; c < 4; c++)
                    out_data[r][c] <= 0;
        end
        else if (read_en) begin
            for (int r = 0; r < 4; r++)
                for (int c = 0; c < 4; c++)
                    out_data[r][c] <= mem[(r * 4) + c];
        end
    end



endmodule