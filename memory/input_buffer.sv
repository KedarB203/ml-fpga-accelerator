module input_buffer(
    input clk,
    input rst,

    input        load,
    input        read_en,

    input  [7:0] in_data,
    input        in_valid,
    output reg   in_ready,
    output reg signed [7:0] out_data [0:3],
    output reg input_load_done
);

    reg [7:0] mem [0:3];   
    reg [2:0] wr_ptr;
    reg full;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            input_load_done <= 0;
            full <= 0;
        end else begin
            input_load_done <= 1'b0; 
            if (load && in_valid && !full) begin
                mem[wr_ptr]     <= in_data;
                if (wr_ptr == 3'b011) begin
                    wr_ptr          <= 3'b0;
                    input_load_done <= 1'b1;  // fires AFTER mem[3] written
                    full            <= 1'b1;
                end else begin
                    wr_ptr <= wr_ptr + 3'b001;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 4; i++) begin
                out_data[i] <= 0;
            end
        end else if (read_en && full) begin
            out_data[0] <= mem[0];
            out_data[1] <= mem[1];
            out_data[2] <= mem[2];
            out_data[3] <= mem[3];
            full            <= 0;
            wr_ptr          <= 0;
            input_load_done <= 0;
        end
    end

// READY SIGNAL
assign in_ready = !full;

endmodule