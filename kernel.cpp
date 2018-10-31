#include "include/common.hpp"
#include "include/tty.hpp"

extern "C" void (*start_ctors)();
extern "C" void (*end_ctors)();


void static_initialize() {
    for(auto ctor = &start_ctors; ctor != &end_ctors; ctor++) {
        (*ctor)();
    }
}

extern "C" void entrypoint(void *multiboot_data, uint16_t magic) {
    static_initialize();

    tty::print("kernel loaded\n");

    for(;;){}
}