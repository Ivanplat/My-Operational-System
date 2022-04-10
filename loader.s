.section .text
.extern KernelMain
global .loader

loader:
    mov $kernel_stack. %esp
    call KernelMain

_stop:


.section .bss
.space 2*1024*1024
kernel_stack:
