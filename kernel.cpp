#include "common.h"

extern "C" void (*start_ctors)();
extern "C" void (*end_ctors)();


static void print(const char* str) {
    auto video_mem = (uint16_t *)0xb8000;
    for(size_t i = 0; str[i] != 0; i++){
        video_mem[i] = (video_mem[i] & 0xff00) | str[i] ;
    }
}


void static_initialize() {
    for(auto ctor = &start_ctors; ctor != &end_ctors; ctor++) {
        (*ctor)();
    }
}

extern "C" void entrypoint(void *multiboot_data, uint16_t magic) {
    static_initialize();

    print("kernel loaded\n");

    for(;;){}
}