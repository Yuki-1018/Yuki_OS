// kernel.c
void kmain() {
    char *vga_buffer = (char*)0xb8000;
    const char *message = "boot successfully";
    int i = 0;

    // Write the message to the video memory
    while (message[i] != 0) {
        vga_buffer[i * 2] = message[i];     // Character code
        vga_buffer[i * 2 + 1] = 0x0f; // Attribute byte (white on black)
        i++;
    }

    // Infinite loop (to prevent the OS from halting)
    while (1);
}
