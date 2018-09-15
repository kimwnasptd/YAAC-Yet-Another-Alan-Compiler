#include <stdint.h>
#include <stdio.h>

int32_t extend(uint8_t b) {
    return (int32_t)b;
}

uint8_t shrink(int32_t i) {
    return (uint8_t)(i & 0xFF);
}

// READ
int32_t readInteger() {
    int32_t i;
    scanf("%d", &i);
    return i;
}

uint8_t readByte() {
    uint8_t b;
    scanf("%hhu", &b);
    return b;
}

uint8_t readChar() {
    uint8_t c;
    scanf("%c", &c);
    return c;
}

// void readString(int32_t size, uint8_t *s) {
//     if (size < 0) { return; }
//
//     // Put the first char
//     int32_t i = 0;
//     size--; // Nead to read size - 1 chars
//     uint8_t c = getchar();
//
//     while(c != EOF && size > 0) {
//         s[i++] = c;
//         c = getchar();
//         size--;
//     }
//     s[i] = "\0";
//     printf("lib: %s", s);
// }

// WRITE
void writeByte(uint8_t b) {
    printf("%hhu", b);
}

void writeChar(uint8_t c) {
    printf("%c", c);
}

void writeString(uint8_t *s) {
    printf("%s", s);
}

void writeInteger(int32_t i){
    printf("%d", i);
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
