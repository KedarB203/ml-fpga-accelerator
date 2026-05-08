module fsm_controller(
    input   clk,
    input   rst,
    input   done,
    output reg load_input,
    output reg load_weight,
    output reg start_compute,
    output reg input_read_en,
    output reg weight_read_en

);

reg [2:0] state, next_state;


localparam init = 'd0;
localparam loadW = 'd1;
localparam loadI = 'd2;
localparam compute = 'd3;
localparam writeBack = 'd4;
localparam nextTile = 'd5;
always @* begin
    load_weight    <= 0;
    start_compute  <= 0;
    input_read_en  <= 0;
    weight_read_en <= 0;
    load_input <= 0;
    next_state     <= state;


    case (state)

        init: begin
            next_state = loadW;
        end

        loadW: begin
            load_weight = 1;
            next_state = loadI;
        end

        loadI: begin
            load_input = 1;
            next_state = compute;
        end

        compute: begin
            start_compute  = 1;
            input_read_en  = 1;
            weight_read_en = 1;

            if (done)
                next_state = writeBack;
        end

        writeBack: begin
            next_state = nextTile;
        end

        nextTile: begin
            next_state = loadW;
        end

    endcase
end
always @(posedge clk)
    if (rst)
        state <= init;
    else
        state <= next_state;

endmodule