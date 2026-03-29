`define SIMULATION
`timescale 1ns / 1ps

module tb_main;

    localparam BAUDRATE_TEST = 5_000_000;
    localparam CLOCKFREQ_TEST = 50_000_000;
    localparam CLOCKRATE_INTERNAL = 20; //20
    localparam CLOCKRATE_IN = 10;
    localparam BAURDRATE_COUNT_TICK = CLOCKFREQ_TEST/BAUDRATE_TEST;
    localparam BPS_TEST = BAURDRATE_COUNT_TICK * CLOCKRATE_INTERNAL; 

    reg clk=0;
    reg cpu_resetn=1;
    reg [7:0] test_pkt = 0;
    reg [31:0] test_batch = 0;
    reg [2:0] count_batch = 0;
    // Outputs
    wire tx;


    // Instantiate the Top Level Design (main)
    top #(
        .CLK_FREQ(CLOCKFREQ_TEST),
        .BAUDE_RATE(BAUDRATE_TEST)
    ) dut (
        .clk_100MHZ (clk),
        .sys_reset  (cpu_resetn), // Assuming top uses active high reset based on snippet
        .tx         (tx)
    );

    // Clock Generation (100MHz -> 10ns period)
    initial begin
        clk = 0;
        forever #(CLOCKRATE_IN/2) clk = ~clk;
        
    end
    
    event byte_received;
    task check_tx;
        reg [7:0] test_pkt1;
        begin
            forever begin               
                wait(!tx);
                $display("time: %t[UART RX] start bit: 0x%h", $time, tx);
                #(BPS_TEST/2); //WAIT HALF A BIT
//                $display("time: %t[UART RX] second bit: 0x%h", $time, tx);
                repeat(8) begin
                    #BPS_TEST; //WAIT A BIT
                    test_pkt1 = {tx, test_pkt1[7:1]};
//                    test_pkt1 = 8'hff;
                    $display("time: %t[UART RX] Captured bit: 0x%h", $time , tx);
                end
                #BPS_TEST; //stop bit
                $display("time: %t[UART RX] Stop bit: 0x%h", $time , tx);
                test_pkt = test_pkt1;      // Update the global data
                -> byte_received;
                $display("Time %t: [UART RX] Captured Byte: 0x%h", $time ,test_pkt1);              
            end
        end
    endtask    
    
    //gets 4 bytes and makes them into a 32 bit word.
    //after that, wait for 2 bytes
    //than repeat and get 4 bytes
    task get_batch;
        reg [31:0] test_batch1;
        begin
            forever begin  
                @(byte_received);    
                if(count_batch <4) begin
                    test_batch1 = {test_pkt, test_batch1[31:8]};
                    count_batch = count_batch + 1'b1;
                end
                else if(count_batch == 'd5) begin
                    count_batch = 0;
                    test_batch = test_batch1;
                     $display("Time %t: [GET BATCH] New Word: 0x%h", $time ,test_batch);
                end
                else begin
                    count_batch = count_batch + 1'b1;
                    test_batch = 0;
                end
                if(test_batch == 'h05ff_05ff) begin
                    $display("--------Simulation Is Successful!!!-----------"); 
                    
//                    #100;
                    
                end
            end
        end
    endtask
    
    initial begin
        fork
            check_tx ();
            get_batch ();
        join_none
        cpu_resetn = 1;
        #1100;
        cpu_resetn = 0;
//        fork
//            check_tx ();
//        join_none
        #10;
        #20000;
//        #100000;
        
    end

endmodule