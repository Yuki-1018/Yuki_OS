[BITS 16]
[ORG 0x7C00]

; 画面に文字を表示
mov ah, 0x0E
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

; 無限ループ
jmp $

; ブートセクタの終了部分を埋める
times 510 - ($ - $$) db 0
dw 0xAA55 ; ブートセクタの終了マーク
