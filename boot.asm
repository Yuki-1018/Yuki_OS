bits 16
org 0x7c00
jmp short start
nop
OEMLabel:           db "MYOS    "
BytesPerSector:     dw 512
SectorsPerCluster:  db 1
ReservedSectors:    dw 1
NumberOfFATs:       db 2
RootEntries:        dw 224
TotalSectors:       dw 2880
MediaType:          db 0xF0
FATsize:            dw 9
SectorsPerTrack:    dw 18
NumberOfHeads:      dw 2
HiddenSectors:      dd 0
LargeSectors:       dd 0
DriveNumber:        db 0
Reserved:           db 0
BootSignature:      db 0x29
VolumeID:           dd 0
VolumeLabel:        db "NO NAME    ", 0
FSType:             db "FAT12   "
start:
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    mov ax, 0xb800
    mov gs, ax
    mov di, 0
clear_screen:
    mov word [gs:di], 0x0F00
    add di, 2
    cmp di, 4000
    jne clear_screen

    mov ah, 0x02          
    mov al, 1            
    mov ch, 0             
    mov cl, 2             
    mov dh, 0            
    mov dl, 0x00          
    mov bx, 0x10000      
    int 0x13              
    jc  error_loading     

    cli
    lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 08h:kernel_start
bits 32
kernel_start:
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
    mov bh, 0x00
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
    times 510 - ($ - $$) db 0
    dw 0xaa55
