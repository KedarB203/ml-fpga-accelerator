module systolic_array(
    input   clk,
    input   rst,
    input   w_load,
    input  start_compute,
    input   signed [7:0] a_in [0:3],
    input   signed [7:0]  b_in [0:3][0:3],

    output  [31:0] result_out [0:3],
    output         done
);

wire signed [7:0] a_wire [0:3][0:4];
//wire signed [7:0] w_wire [0:4][0:3];
wire signed [31:0] acc_wire [0:4][0:3];
localparam TOTAL_CYCLES = 4;
reg [$clog2(TOTAL_CYCLES+1)-1:0] cycle_count;
reg computing;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        cycle_count <= '0;
        computing   <= 1'b0;
        done        <= 1'b0;
    end else if (start_compute && !computing) begin
        computing   <= 1'b1;
        cycle_count <= '0;
        done        <= 1'b0;
    end else if (computing) begin
        if (cycle_count == TOTAL_CYCLES - 1) begin
            computing <= 1'b0;
            done      <= 1'b1;
        end else begin
            cycle_count <= cycle_count + 1;
            done        <= 1'b0;
        end
    end else begin
        done <= 1'b0;
    end
end

    
genvar i;
generate
    for (i = 0; i < 4; i = i+1) begin
        assign a_wire[i][0] = a_in[i];
        assign acc_wire[0][i] = 32'd0; // initial acc = 0
        //assign acc_wire[4][i] = 32'd0; // final acc = 0
    end

endgenerate

// generate
//     //for (i = 0; i < 4; i=i+1) begin
//         assign w_wire[0][i] = b_in[i];

//     end

// endgenerate


genvar r, c;

generate
    for (r = 0; r < 4; r=r+1) begin
        for (c = 0; c < 4; c=c+1) begin
            pe u_pe (
                .clk(clk),
                .rst(rst),
                .w_load(w_load),
                .a_in(a_wire[r][c]),
                .b_in(b_in[r][c]),
                .acc_in(acc_wire[r][c]),

                .a_out(a_wire[r][c+1]),
                .b_out(),
                .acc_out(acc_wire[r+1][c])
            );
        end
    end
endgenerate

generate
    for(i = 0; i < 4 ; i=i+1) begin
        assign result_out[i] = acc_wire[4][i];
    end
endgenerate


endmodule