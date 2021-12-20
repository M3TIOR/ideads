/* gas version of C kernel bootleg */

.file "boot.c"
.global _start
.global start
.global mboot
.extern code
.extern bss
.extern end

.equ MBOOT_PAGE_ALIGN, $1<<$0
.equ MBOOT_MEM_INFO, $0<<$1
.equ MBOOT_HEADER_MAGIC, $0x1BADBOO2

.equ MBOOT_HEADER_FLAGS, MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
.equ MBOOT_CHECKSUM, -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

_start: #start of gnu assembly instructions... took me forever to learn this...

mboot:
        .int MBOOT_HEADER_MAGIC
        .int MBOOT_HEADER_FLAGS
        .int MBOOT_CHECKSUM

        .int mboot
        .int code
        .int bss
        .int end
        .int start

start:
	push %ebx

        xor %esp, %esp
        xor %ebp, %ebp
        /* reset control registers for debug reasons. */

        cli
        call main

__infinityloop:
        jmp __infinityloop

        /* stops the processor from running whatever
         junk is in memory after the kernel. */
