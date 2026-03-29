module data_memory_unit #(
    parameter ADDR_WIDTH = 6 
)(
    input  clk,
    input  en_write,    
    input  [31:0] address,    
    input  [31:0] store_data,
    input  [2:0]  Func3,      
    
    output [31:0] load_data   
);

    wire [1:0]  addr_lsb;
    wire [3:0]  tx_mask;            
    wire [31:0] tx_wdata;     
    wire [31:0] ram_rdata;    

    assign addr_lsb = address[1:0];

    mem_transmitter tx_inst (
        .store_data (store_data),
        .Addr2Lsb   (addr_lsb),
        .Func3      (Func3),
        .w_mask     (tx_mask),
        .mem_wdata  (tx_wdata)
    );

    bytewrite_tdp_ram_nc #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .clkA   (clk),
        .enA    (en_write),    
        .weA    (tx_mask),                  
        .addrA  (address[ADDR_WIDTH-1:0]), 
        .dinA   (tx_wdata),
        .doutA  (ram_rdata)
    );

    mem_receiver rx_inst (
        .read_data  (ram_rdata),
        .Addr2Lsb   (addr_lsb),
        .Func3      (Func3),
        .load_word  (load_data)
    );

endmodule