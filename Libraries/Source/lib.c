#include <stdint.h>
#include <stdio.h>
#include <string.h>

int32_t extend(uint8_t b) {
    return (int32_t)b;
}

uint8_t shrink(int32_t i) {
    return (uint8_t)(i & 0xFF);
}

// READ
int32_t readInteger() {
    int32_t i;
    char temp;
    scanf("%d", &i);
    scanf("%c", &temp);
    return i;
}

uint8_t readByte() {
    uint8_t b;
    char temp;
    scanf("%hhu", &b);
    scanf("%c", &temp);
    return b;
}

uint8_t readChar() {
    uint8_t c;
    scanf("%c", &c);
    return c;
}

void readString(int32_t size, uint8_t *s) {
    if (size <= 0) { return; }
    if (size == 1) { memset(s, 0, 1); return; }

    // Put the first char
    uint8_t buf[size];
    memset(buf, 0, size);
    int32_t i = 0;
    size--; // Nead to read size - 1 chars
    uint8_t c = getchar();

    // We want to read at most n-1 chars
    while((char)c != EOF && c != '\n' && size > 0) {
        buf[i++] = c;
        if (--size <= 0) { break; }
        c = getchar();
    }
    strcpy((char *)s, (char *)buf);
}

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


// LIB CONSTRUCTORS
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
