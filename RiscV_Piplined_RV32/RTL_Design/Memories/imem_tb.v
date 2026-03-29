module imem_tb
    #(MEM_DEPTH=63) //length can be 2^32-1
    (
//    input rst,
    input [31:0] A, //PC input
    output [31:0] RD
    );
    
    reg [31:0] mem [MEM_DEPTH: 0];
    
    initial
    $readmemh("testMain.mem",mem);
//        $readmemh("no_hazards.mem",mem);
    
    assign RD= mem[ A[31:2] ];
    

    
endmodule