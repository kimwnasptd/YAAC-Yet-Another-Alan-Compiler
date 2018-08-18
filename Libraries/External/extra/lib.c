#include <stdint.h>
#include <stdio.h>

int32_t extend(uint8_t b) {
    return (int32_t)b;
}

uint8_t shrink(int32_t i) {
    return (uint8_t)(i & 0xFF);
}

uint8_t readByte() {
    uint8_t b;
    scanf("%hhu", &b);
    return b;
}

void writeByte(uint8_t b) {
    printf("%hhu", b);
}

void __attribute__ ((constructor)) initLibrary(void) {
 //
 // Function that is called when the library is loaded
 //
}
void __attribute__ ((destructor)) cleanUpLibrary(void) {
 //
 // Function that is called when the library is »closed«.
 //
}