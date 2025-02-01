void main() {
    char* video_memory = (char*) 0xB8000;  // テキストモードのビデオメモリのアドレス
    char* message = "Yuki OS Boot Success!";
    int i = 0;

    // メッセージをビデオメモリに書き込む
    while (message[i] != 0) {
        video_memory[i * 2] = message[i];  // 文字
        video_memory[i * 2 + 1] = 0x07;    // 属性バイト (白文字、黒背景)
        i++;
    }

    // 無限ループ
    while (1);
}
