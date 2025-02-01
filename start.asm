[BITS 32]        ; 32ビットモード

; Multibootヘッダーの定義
section .multiboot
align 4
multiboot_header:
    dd 0x1BADB002              ; マジックナンバー (Multiboot仕様)
    dd 0x00000003              ; フラグ (ALIGN + MEMINFO)
    dd -(0x1BADB002 + 0x00000003) ; チェックサム

; カーネルのエントリーポイント
section .text
global start
extern main      ; kernel.cのmain関数を参照

start:
    ; GRUBが提供するブート情報を保存（必要な場合）
    mov [multiboot_info], ebx  ; Multiboot情報のポインタを保存
    mov [multiboot_magic], eax ; Multibootマジックナンバーを保存

    ; カーネルのメイン関数を呼び出す
    call main

    ; 無限ループ
    cli
    hlt

; Multiboot情報を保存するための変数
section .bss
align 4
multiboot_info resd 1
multiboot_magic resd 1
