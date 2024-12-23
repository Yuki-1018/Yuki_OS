void kernel_main() {
    char* video_memory = (char*)0xb8000;
    const char* message = "Welcome to Yuki OS Kernel";
    int i = 0;

    while (message[i] != '\0') {
        video_memory[i * 2] = message[i];     // 文字をセット
        video_memory[i * 2 + 1] = 0x07;      // 白地に黒文字
        i++;
    }
}
