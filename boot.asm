; boot.asm
bits 16             ; 16-bit mode

org 0x7c00          ; Address where BIOS loads the boot sector

jmp short start
nop

; BIOS Parameter Block (BPB) - minimal
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
    ; Set up data segments
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00      ; Set up stack pointer

    ; Clear the screen
    mov ax, 0xb800
    mov gs, ax
    mov di, 0
clear_screen:
    mov word [gs:di], 0x0F00  ; Space with white on black
    add di, 2
    cmp di, 4000            ; For 80x25 mode
    jne clear_screen

    ; Load the kernel
    mov ah, 0x02          ; BIOS read function
    mov al, 1             ; Read 1 sector
    mov ch, 0             ; Cylinder 0
    mov cl, 2             ; Sector 2 (after boot sector)
    mov dh, 0             ; Head 0
    mov dl, 0x00          ; Drive 0 (floppy)
    mov bx, 0x10000       ; Load address
    int 0x13              ; Call BIOS

    ; Enter protected mode (simplified)
    cli                     ; Disable interrupts
    lgdt [gdt_ptr]          ; Load GDT
    mov eax, cr0
    or eax, 0x1             ; Set PE bit
    mov cr0, eax
    jmp 08h:kernel_start    ; Long jump

bits 32             ; 32-bit mode
kernel_start:
    ; Re-initialize data segments
    mov ax, 0x10        ; Data segment in GDT
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000    ; Set up stack pointer

    ; Jump to C kernel
    extern kmain
    call kmain

    ; Infinite loop
    cli
halt_loop:
    hlt
    jmp halt_loop

; Global Descriptor Table (GDT)
gdt_start:
    dd 0x0                ; Null descriptor
    ; Code segment (privilege level 0)
    dw 0xFFFF, 0x0000, 0x9A00, 0x009A
    ; Data segment (privilege level 0)
    dw 0xFFFF, 0x0000, 0x9200, 0x0092
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

    ; Padding and boot signature
    times 510 - ($ - $$) db 0
    dw 0xaa55
