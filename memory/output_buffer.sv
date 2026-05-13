module output_buffer (
    input        clk,
    input        rst,
    input        done,
    input   out_ready,
    input  signed [31:0] data_in [0:3],
    output reg signed [31:0] data_out [0:3],
    output reg         valid
);

logic signed [31:0] bias [0:3];
initial begin
    bias[0] = 32'd0;
    bias[1] = 32'd0;
    bias[2] = 32'd0;
    bias[3] = 32'd0;
end
reg signed [31:0] biased;
reg out_valid_r;
always @(posedge clk) begin
    if (rst) begin
        out_valid_r <= 0;
    end
    else if (done) begin
        out_valid_r <= 1;
        for (int i = 0; i < 4; i++) begin
            biased = data_in[i] + bias[i];
            data_out[i] <= (biased[31] == 0) ? biased : 32'd0;  // ReLU
        end
    end else if (out_valid_r && out_ready) begin
        out_valid_r <= 0;
    end
end

assign valid = out_valid_r;

endmodule