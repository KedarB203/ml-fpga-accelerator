module input_buffer(
    input clk,
    input rst,

    input        load,
    input        read_en,

    input  [7:0] in_data,
    input        in_valid,
    output reg   in_ready,
    output reg [7:0] out_data [0:3]
);

    reg [7:0] mem [0:15];   
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [4:0] count;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        end else begin

            // WRITE — only when upstream data is valid
            if (load && in_valid && (count < 16)) begin
                mem[wr_ptr] <= in_data;
                wr_ptr      <= wr_ptr + 1;
                count       <= count + 1;
            end

            // READ — output 4 entries per cycle to systolic array
            if (read_en && (count >= 4)) begin
                out_data[0] <= mem[rd_ptr    ];
                out_data[1] <= mem[rd_ptr + 1];
                out_data[2] <= mem[rd_ptr + 2];
                out_data[3] <= mem[rd_ptr + 3];
                rd_ptr      <= rd_ptr + 4;
                count       <= count - 4;
            end

        end
    end

    // READY SIGNAL
    always @(*) begin
        in_ready = (count < 8);
    end

endmodule