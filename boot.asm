
[org 0x7c00]  ; ブートローダー開始アドレス
mov ax, 0x07C0
add ax, 288
mov ss, ax
mov sp, 0x0000

; カーネルをメモリに読み込む
mov bx, 0x0000
mov es, bx
mov ah, 0x02
mov al, 0x01
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
int 0x13

; カーネルへジャンプ
jmp 0x0000:0x0800

; ブートローダー終了
times 510-($-$$) db 0
dw 0xAA55
