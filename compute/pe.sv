module pe(
    input   clk,
    input   rst,
    input   w_load,

    input   signed [7:0] a_in,
    input   signed [7:0] b_in,
    input   signed [31:0] acc_in,

    output  reg signed [7:0] a_out,
    output  reg signed [7:0] b_out,
    output  reg signed [31:0] acc_out
);


wire [31:0] acc_res;
reg signed [7:0] w_reg;
mac u_mac (
    .clk(clk),
    .rst(rst),
    .a_in(a_in),
    .b_in(b_in),
    .acc_in(acc_in),
    .acc_out(acc_res)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_out <= 0;
        b_out <= 0;
        w_reg <= 0;
        acc_out <= 0;
    end
    else begin 
        // if (w_load) begin
        //     w_reg <= b_in;
        
        // end
        b_out <= w_reg;
        a_out <= a_in;
        acc_out <= acc_res;
    end
end

endmodule