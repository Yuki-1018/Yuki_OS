[BITS 16]        ; 16ビットモード
[ORG 0x7C00]    ; BIOSがブートローダをロードするアドレス

start:
    xor ax, ax  ; AXレジスタを0にクリア
    mov ds, ax  ; データセグメントを0に設定
    mov es, ax  ; エクストラセグメントを0に設定

    ; カーネルをロードする
    mov ah, 0x02    ; BIOS読み込み機能
    mov al, 1       ; 読み込むセクタ数
    mov ch, 0       ; シリンダ番号
    mov cl, 2       ; セクタ番号 (ブートセクタの次から読み込む)
    mov dh, 0       ; ヘッド番号
    mov dl, 0       ; ドライブ番号 (フロッピーの場合)
    mov bx, 0x1000  ; 読み込み先のメモリアドレス (ES:BX)
    int 0x13        ; BIOSディスクサービス

    jc disk_error   ; エラーが発生した場合

    ; カーネルにジャンプ
    jmp 0x1000:0x0000

disk_error:
    ; エラー処理 (ここでは何もしない)
    cli
    hlt

times 510-($-$$) db 0  ; ブートシグネチャまでのパディング
dw 0xAA55              ; ブートシグネチャ
