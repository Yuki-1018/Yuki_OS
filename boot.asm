bits 16
[org 0x7c00]

jmp short start

start:
    ; データセグメントの設定
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; 画面のクリア
    mov ax, 0xb800
    mov gs, ax
    mov di, 0
clear_screen:
    mov word [gs:di], 0x0F00
    add di, 2
    cmp di, 4000
    jne clear_screen

    ; カーネルをロード
    mov ah, 0x02          ; BIOS 読み込み機能
    mov al, 1             ; 1セクタ読み込み
    mov ch, 0             ; シリンダ 0
    mov cl, 2             ; セクタ 2
    mov dh, 0             ; ヘッド 0
    mov dl, 0x00          ; ドライブ 0
    mov bx, 0x10000       ; ロードアドレス
    int 0x13
    jc error_loading

    ; プロテクトモードへ移行
    cli
    lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 08h:kernel_start

bits 32
kernel_start:
    ; データセグメント再設定
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    extern kmain
    call kmain

    cli
halt_loop:
    hlt
    jmp halt_loop

error_loading:
    mov si, load_error_msg
    call print_string
    cli
    hlt
    jmp $

print_string:
    pusha
next_char:
    mov al, [si]
    cmp al, 0
    je done
    mov ah, 0x0e
    mov bl, 0x0f
    int 0x10
    inc si
    jmp next_char
done:
    popa
    ret

load_error_msg: db "Error loading kernel!", 0

gdt_start:
    dd 0x0
    dw 0xFFFF, 0x0000, 0x9A00, 0x009A
    dw 0xFFFF, 0x0000, 0x9200, 0x0092
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

    ; パディングとブートシグネチャ
    times 510-($-$$) db 0
    dw 0xaa55
