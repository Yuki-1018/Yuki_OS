// kernel.c
void print_string(const char* str) {
    unsigned short* video_memory = (unsigned short*)0xb8000;
    while (*str) {
        *video_memory++ = (*str++ | 0x0700); // 白色文字
    }
}

void main() {
    print_string("Welcome to Yuki OS Kernel");
    while (1);
}
