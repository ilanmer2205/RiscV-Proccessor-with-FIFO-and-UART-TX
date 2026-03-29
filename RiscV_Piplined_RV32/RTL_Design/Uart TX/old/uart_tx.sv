`timescale 1ns / 1ps

// The Serializer.
// It takes one byte and pushes it out bit-by-bit.
module uart_tx(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       baude_tick,
    input  logic       tx_start,
    input  logic [7:0] data_in,

    output logic       tx_busy,
    output logic       tx
);
    
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_e;

    state_e current_state, next_state;

    // Internal Signals
    logic [2:0] baude_cnt; 
    logic       data_byte_done;
    logic [7:0] shifter;
    logic [7:0] get_byte_test;
    
    // BLOCK 1: State Memory
    always_ff @(posedge clk) begin
        if (rst_n)
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    assign get_byte_test = {tx, get_byte_test[7:1]};

    // BLOCK 2: Next State Logic
    assign data_byte_done = (baude_cnt == 3'd7 && baude_tick);

    always_comb begin
        next_state = current_state; // Default

        case (current_state) 
            IDLE: begin
                if (tx_start) next_state = START;
                else          next_state = IDLE;
            end

            START: begin
                if (baude_tick) next_state = DATA;
                else            next_state = START;
            end

            DATA: begin
                if (data_byte_done) next_state = STOP;
                else                next_state = DATA;
            end

            STOP: begin
                if (baude_tick) next_state = IDLE;
                else            next_state = STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // BLOCK 3: Registered Outputs & Datapath
    always_ff @(posedge clk) begin
        if (rst_n) begin
            tx_busy   <= 1'b0;
            tx        <= 1'b1; // Idle High
            shifter   <= 8'd0;
            baude_cnt <= 3'd0;
        end else begin
           
            
            case (current_state)
                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shifter <= data_in; // Latch data
                        tx_busy <= 1'b1;    // Busy immediately
                        baude_cnt <= 3'd0;  // Reset counter
                    end
                end

                START: begin
                    tx_busy <= 1'b1;
                    tx      <= 1'b0; // Drive Start Bit
                end

                DATA: begin
                    tx_busy <= 1'b1;
                    tx      <= shifter[0]; // Output LSB
                    
                    if (baude_tick) begin
                        shifter   <= shifter >> 1;
                        baude_cnt <= baude_cnt + 1;
                    end
                end

                STOP: begin
                    tx_busy <= 1'b1;
                    tx      <= 1'b1; // Drive Stop Bit
                    
                    if (baude_tick) begin
                        tx_busy <= 1'b0; // Release busy when stop bit finishes
                    end
                end
            endcase
        end
    end

endmodule