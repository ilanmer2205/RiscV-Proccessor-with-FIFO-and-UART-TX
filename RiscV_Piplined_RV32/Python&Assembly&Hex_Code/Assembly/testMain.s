0:  main:
        addi    x4, x0, 4       // x4 = 4

4:      auipc   x1, 0xFF        // x1 = 0xFF004  (Immediate 255)

8:      addi    x1, x1, -4      // x1 = 0xFF000

c:      slli    x1, x1, 4       // x1 = 0xFF0000

10:     lui     x3, 1           // x3 = 0x1000

14:     addi    x3, x3, -1      // x3 = 0xFFF (Immediate is 0xFFF, -1 in 12-bit signed)

18:     sb      x3, 0(x4)       // [mem]_4 = 0xFF

1c:     sh      x3, 2(x4)       // [mem]_4 = 0x0FFF_00FF (addr = 0110)

20:     lhu     x1, 2(x4)       // x1 = 0x0000_0FFF

24:     lb      x2, 2(x4)       // x2 = 0xFFFF_FFFF

28:     bge     x2, x1, end     // shouldn't execute ( 40-28 = 12 = (24)dec )

2c:     addi    x5, x0, 5       // x5 = 5

30:     sb      x5, 1(x4)       // [mem]_4 = 0x0FFF_05FF

34:     bltu    x5, x2, end     // should be taken ( 40-34 = 6 = (12)dec )

38:     and     x4, x4, x0      // x4 = 0;  If executed -> Error
3c:     sw      x1, 0(x4)       // [mem]_0 = 0xFFF;  If executed -> Error

40: end:
        sb      x5, 3(x4)       // [mem]_4 = 0x05FF_05FF

44:     lw      x1, 0(x4)       // x1 = 05ff_05ff

48:    beq x0, x0, -72(-0x48)   // 0x48 (Target) - 0x48 (Current) = 0