.p2align 5
.globl p1271square
p1271square:


movq %rbp,%r11
movq %rsp, %rbp

subq $200, %rsp

movq    %r11, -8(%rbp)
movq    %rbx, -16(%rbp)
movq    %r12, -24(%rbp)
movq    %r13, -32(%rbp)
movq    %r14, -40(%rbp)
movq    %r15, -48(%rbp)


movq 0(%rdi), %rax

movq 8(%rdi), %rcx

leaq squares, %rdi

movq %rax, 0(%rdi)

movq %rcx, 8(%rdi) 

addq $16, %rdi 


.START:

subq    $1, %rsi

movq    %rcx, %rdx   
addq    %rdx, %rdx
mulx    %rax, %r9, %r10

movq    %rax, %rdx  
mulx    %rdx, %rax, %rdx
addq    %rdx, %r9

movq    %rcx, %rdx
mulx    %rdx, %rcx, %r11
adcq    %rcx, %r10
adcq    $0, %r11

shld    $1, %r10, %r11
shld    $1, %r9, %r10

andq	mask63, %r9
addq    %r10, %rax
adcq    %r11, %r9

movq    %r9, %rcx
andq	mask63, %rcx
shrq    $63, %r9
addq    %r9, %rax
adcq    $0, %rcx

movq    %rax,  0(%rdi)
movq    %rcx,  8(%rdi)
addq    $16, %rdi

cm: cmpq    $0, %rsi

jge     .START






movq    -8(%rbp),%r11
movq    -16(%rbp),%rbx
movq    -24(%rbp),%r12
movq    -32(%rbp),%r13
movq    -40(%rbp),%r14
movq    -48(%rbp),%r15

addq $200, %rsp

movq %rbp, %rsp
movq %r11, %rbp


ret












 






