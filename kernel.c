void kmain() {
    char *vga_buffer = (char*)0xb8000;
    const char *message = "boot successfully";
    int i = 0;
    while (message[i] != 0) {
        vga_buffer[i * 2] = message[i];
        vga_buffer[i * 2 + 1] = 0x0f;
        i++;
    }
    while (1);
}
