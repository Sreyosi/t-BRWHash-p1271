.bss
.globl squares
.globl stack
.globl key
squares: .space 32000 
stack: .space 32000
key: .space 32000
.data
.globl mask63
.globl mask56
.globl mask62
.globl zero
.globl p0
.globl p1

.p2align 4
zero: .quad 0x0
mask63: .quad 0x7fffffffffffffff
mask56: .quad 0xffffffffffffff
p0	: .quad 0xFFFFFFFFFFFFFFFF
p1	: .quad 0x7FFFFFFFFFFFFFFF
mask62  : .quad 0x3fffffffffffffff
