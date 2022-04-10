#include <stdio.h>

void KernelMain(void* multiboot_structure, unsigned int magic_number)
{
    printf("Hello");
    while(true);
}