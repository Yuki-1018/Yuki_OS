

[org 0x7c00]    ; BIOSがブートローダをロードするアドレス
bits 16         ; 16ビットモードを指定


start:
    ; セグメントレジスタの初期化
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; スタックの初期化
    mov ax, 0x0000
    mov ss, ax
    mov sp, 0x7c00

    ; メッセージ表示
    mov si, msg_loading
    call print_string

    ; カーネルをロード
    mov ah, 0x02    ; ディスク読み込みのBIOSコール
    mov al, 0x01    ; 読み込むセクタ数 (1セクタ)
    mov ch, 0x00    ; シリンダ番号
    mov cl, 0x02    ; セクタ番号 (2番目のセクタから)
    mov dh, 0x00    ; ヘッド番号
    mov dl, 0x00    ; ドライブ番号 (フロッピーディスク)
    mov bx, 0x1000  ; 読み込み先アドレス (カーネルのロード先)
    int 0x13        ; BIOSコール実行

    ; エラーチェック
    jc error

    ; カーネルへジャンプ
    jmp 0x1000

; 文字列表示関数
print_string:
    mov ah, 0x0e    ; BIOSのテレタイプ出力機能
.loop:
    lodsb           ; siから1バイト読み込み
    or al, al       ; 文字がNULLかどうか確認
    jz .done        ; NULLなら終了
    int 0x10        ; BIOSコール実行
    jmp .loop
.done:
    ret

; エラー処理
error:
    mov si, msg_error
    call print_string
    hlt             ; CPU停止

; メッセージ
msg_loading: db "Loading kernel...", 0
msg_error:   db "Error loading kernel!", 0

; ブートセクタの残りを0で埋める
times 510-($-$$) db 0

; ブートシグネチャ
dw 0xaa55
