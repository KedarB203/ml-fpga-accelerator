module fsm_controller(
    input   clk,
    input   rst,
    input   done,
    output reg load_input,
    output reg load_weight,
    output reg start_compute,
    output reg input_read_en,
    output reg weight_read_en,
    output reg bufSel
);

reg [2:0] state, next_state;

localparam [1:0] layers = 3; // number of layers to compute (for testing, can be extended to 2^n)
localparam init = 'd0;
localparam loadW = 'd1;
localparam loadI = 'd2;
localparam compute = 'd3;
localparam writeBack = 'd4;
localparam nextTile = 'd5;
localparam doneidle = 'd6;
always @* begin
    load_weight    = 0;
    start_compute  = 0;
    input_read_en  = 0;
    weight_read_en = 0;
    load_input = 0;
    next_state     = state;


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
            if (done) begin
                next_state = writeBack;
            end
            
        end

        writeBack: begin
            next_state = nextTile;
        end

        nextTile: begin
            if (counter == layers) begin
                next_state = doneidle;
            end
            else next_state = loadW;
        end

        doneidle: begin
        end
    endcase
end
reg [1:0] counter;
initial begin
    counter = 0;
end
always @(posedge clk)
    if (rst) begin
        state <= init;
        bufSel <= 1'b0;
        counter <= 2'd0;
    end
    else begin
        if (state == nextTile && next_state == loadW) begin
            bufSel <= ~bufSel;
        end
        if (state == nextTile)
            counter <= counter + 1;
        state <= next_state;
    end
endmodule