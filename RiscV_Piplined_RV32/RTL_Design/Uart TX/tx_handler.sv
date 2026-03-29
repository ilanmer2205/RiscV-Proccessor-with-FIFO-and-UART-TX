`timescale 1ns / 1ps
//
module tx_handler(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] result_msg,
    input  logic        tx_ready,
    input  logic        empty,
    input  logic        tx_done,

    output logic        tx_start,
    output logic [7:0]  tx_data,
    output logic [7:0]  tx_cnt_out,
    output logic        tx_msg_ready
    
);
    localparam MAX_COL = 4;

    logic [31:0] latched_msg;

    // --- 3. FSM Definitions ---
    typedef enum logic [3:0] {
        IDLE,
        SEND_DATA,
        WAIT_DATA,
        CHECK_EOL,
        MOVE_LM,      // CR / cursor to left margin
        WAIT_LM,
        MOVE_NL,      // LF / cursor to newline
        WAIT_NL,
        CHECK_EOM     // End of Matrix
    } state_t;

    state_t current_state, next_state;
    logic [8:0]  col_cnt, row_cnt; 

    assign trigger_start = (!empty && current_state == IDLE) ? 1'b1 : 1'b0;
    //!(trigger_start || current_state !=IDLE);

    // --- 4. Sequential Logic ---
    always_ff @(posedge clk ) begin
        if (rst_n) begin
            current_state <= IDLE;
            col_cnt       <= 0;
            row_cnt       <= 0;
            tx_start      <= 0;
            tx_data       <= 0;
            tx_msg_ready  <= 0;
            latched_msg   <= 0;
            tx_cnt_out    <= 0;
        end else begin
            tx_start      <= 0; // Default pulse low
            tx_msg_ready  <= 0;
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    col_cnt <= 0;
                    row_cnt <= 0;
                    tx_cnt_out <= 0;
                    tx_msg_ready <= 0;
                    if(trigger_start) begin
                        latched_msg <= result_msg;
                    end
                    
                end

                SEND_DATA: begin
                    tx_start <= 1;
                    tx_data <= latched_msg[(col_cnt * 8) +: 8];
                    tx_cnt_out <= tx_cnt_out + 1;
                end

                CHECK_EOL: begin
                    col_cnt   <= col_cnt + 1;
                    if(col_cnt == MAX_COL-1) tx_msg_ready <= 1;
                end

                MOVE_LM: begin // CR
                    tx_start <= 1;
                    tx_data  <= 8'h0D; 
                end

                MOVE_NL: begin // LF
                    tx_start <= 1;
                    tx_data  <= 8'h0A; 
                end

                // CHECK_EOM: begin 
                //     col_cnt <= 0;
                //     row_cnt <= row_cnt + 1;
                // end
            endcase
        end
    end

    // --- 5. Next State Logic ---
    always_comb begin
        next_state = current_state;

        case (current_state)
            IDLE       : if (trigger_start) next_state = SEND_DATA;

            SEND_DATA  : next_state = WAIT_DATA;
            WAIT_DATA  : if (tx_done) next_state = CHECK_EOL;


            CHECK_EOL  : if (col_cnt < MAX_COL - 1) next_state = SEND_DATA;
                         else                       next_state = MOVE_LM;

            MOVE_LM    : next_state = WAIT_LM;
            WAIT_LM    : if (tx_done) next_state = MOVE_NL;

            MOVE_NL    : next_state = WAIT_NL;
            WAIT_NL    : if (tx_done) next_state = IDLE;
                
            // CHECK_EOM  : if (row_cnt < max_row - 1) next_state = SEND_DATA;
            //              else                       next_state = IDLE;

            default: next_state = IDLE;
        endcase
    end

endmodule
