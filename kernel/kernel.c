// kernel.c

void print_string(const char* str) {
    volatile char* video_memory = (volatile char*)0xb8000;
    while (*str != '\0') {
        *video_memory++ = *str++; // 文字
        *video_memory++ = 0x07;   // 属性（白文字、黒背景）
    }
}

void main() {
    print_string("Welcome to Yuki OS Kernel");

    // 無限ループ
    while (1) {}
} 
