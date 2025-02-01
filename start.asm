[BITS 32]        ; 32ビットモード

global start
extern main      ; kernel.cのmain関数を参照

start:
    call main    ; main関数を呼び出す
    cli
    hlt
