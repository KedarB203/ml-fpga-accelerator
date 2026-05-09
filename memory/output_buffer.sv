module output_buffer (
    input        clk,
    input        rst,
    input        done,
    input  signed [31:0] data_in [0:3],
    output logic signed [31:0] data_out [0:3],
    output logic         valid
);

logic signed [31:0] bias [0:3];
initial begin
    bias[0] = 32'd2;
    bias[1] = 32'd1;
    bias[2] = 32'd0;
    bias[3] = 32'd3;
end

always @(posedge clk) begin
    if (rst) begin
        valid <= 0;
    end
    else if (done) begin
        valid <= 1;
        for (int i = 0; i < 4; i++) begin
            logic signed [31:0] biased;
            biased = data_in[i] + bias[i];
            data_out[i] <= (biased[31] == 0) ? biased : 32'd0;  // ReLU
        end
    end else begin
        valid <= 0;
    end
end


endmodule