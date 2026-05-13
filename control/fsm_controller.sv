module fsm_controller(
    input   clk,
    input   rst,
    input   done,
    input   load_done,
    input   input_load_done,
    output reg load_input,
    output reg load_weight,
    output reg start_compute,
    output reg input_read_en,
    output reg weight_read_en,
    output reg bufSel,
    output reg loadSel
);

    // ----------------------------------------------------------------
    // State encoding
    // ----------------------------------------------------------------
    reg [2:0] state, next_state;

    localparam [2:0] INIT       = 3'd0;
    localparam [2:0] LOAD_W     = 3'd1;
    localparam [2:0] LOAD_I     = 3'd2;
    localparam [2:0] COMPUTE    = 3'd3;
    localparam [2:0] WAIT_DONE  = 3'd4;
    localparam [2:0] WRITEBACK  = 3'd5;
    localparam [2:0] NEXT_TILE  = 3'd6;

    // Number of layers. Use 2-bit counter (max 3 layers = indices 0,1,2).
    localparam integer NUM_LAYERS = 3;

    reg [1:0] counter;      // tracks which layer we are on (0 to NUM_LAYERS-1)
    reg       bg_load_done; // latched flag: background weight load finished

    // ----------------------------------------------------------------
    // Combinational next-state / output logic
    // ----------------------------------------------------------------
    always @* begin
        // Default outputs
        load_weight    = 1'b0;
        load_input     = 1'b0;
        start_compute  = 1'b0;
        input_read_en  = 1'b0;
        weight_read_en = 1'b0;
        next_state     = state;

        case (state)

            INIT: begin
                // Wait for external weight load to begin
                next_state = LOAD_W;
            end

            LOAD_W: begin
                // Load weights into the inactive buffer
                load_weight = 1'b1;
                if (load_done)
                    next_state = LOAD_I;
            end

            LOAD_I: begin
                load_input = 1'b1;
                weight_read_en = 1'b1;
                //load_weight    = (counter < NUM_LAYERS - 1);
                if (input_load_done)
                    next_state = COMPUTE;
            end

            COMPUTE: begin
                start_compute  = 1'b1;
                input_read_en  = 1'b1;
                weight_read_en = 1'b1;
                if (counter < NUM_LAYERS - 1)
                    load_weight = 1'b1; // start loading next layer's weights while computing current layer
                if (done)
                    next_state     = WAIT_DONE;
            end

            WAIT_DONE: begin
                weight_read_en = 1'b1;
                // Background-preload next layer's weights into the
                // inactive buffer while the systolic array is running.
                // Only do this if there IS a next layer.
                if (counter < NUM_LAYERS - 1) begin
                    load_weight = 1'b1;     // write to inactive buffer
                    // weight_read_en is NOT set here — active buffer
                    // is still being read by the array via start_compute
                    // latching; the array drives its own reads internally.
                end

                // Exit when compute is done AND (either this is the last
                // layer so no background load needed, or bg load finished)
                if ((counter == NUM_LAYERS - 1 || bg_load_done))
                    next_state = WRITEBACK;
            end

            WRITEBACK: begin
                next_state = NEXT_TILE;
            end

            NEXT_TILE: begin
                if (counter == NUM_LAYERS - 1)
                    next_state = INIT;   // all layers done; wait for new inference
                else
                    next_state = LOAD_I; // weights already in inactive buf; flip & compute
            end

            default: next_state = INIT;

        endcase
    end

    // ----------------------------------------------------------------
    // Sequential: state, counter, bufSel, bg_load_done latch
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state       <= INIT;
            bufSel      <= 1'b0;
            counter     <= 2'd0;
            bg_load_done <= 1'b0;
            loadSel <= 1'b0;
        end
        else begin
            state <= next_state;

            // Latch when the background weight load completes during WAIT_DONE
            if (state == WAIT_DONE && load_done && counter < NUM_LAYERS - 1)
                bg_load_done <= 1'b1;

            // Clear the latch when we move on
            if (state == NEXT_TILE)
                bg_load_done <= 1'b0;

            // Flip the active buffer and advance layer counter on NEXT_TILE
            if (state == NEXT_TILE) begin
                bufSel <= ~bufSel;
                if (counter == NUM_LAYERS - 1)
                    counter <= 2'd0;
                else
                    counter <= counter + 2'd1;
            end

            if (state == LOAD_W && load_done)
                loadSel <= ~loadSel;
            else if (state == NEXT_TILE)
                loadSel <= ~loadSel;
        end

    end

endmodule