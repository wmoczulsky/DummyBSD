#include "include/common.hpp"
#include "include/tty.hpp"

static uint16_t* const video_mem = (uint16_t *)0xb8000;

void tty::print(const char* str) {
    for(size_t i = 0; str[i] != 0; i++){
        video_mem[i] = (video_mem[i] & 0xff00) | str[i] ;
    }
}
