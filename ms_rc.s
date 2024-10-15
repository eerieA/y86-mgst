merge:
        mov     r10, rdi
        mov     r9, rsi
        lea     rax, [rsi+4]
        mov     r8, rdi
        mov     ecx, OFFSET FLAT:temp
        cmp     rsi, rdi
        jnb     .L30
        jmp     .L2
.L32:
        add     r8, 4
        mov     edi, esi
.L4:
        mov     DWORD PTR [rcx-4], edi
        cmp     r9, r8
        jb      .L29
.L30:
        cmp     rdx, rax
        jb      .L2
        mov     esi, DWORD PTR [r8]
        mov     edi, DWORD PTR [rax]
        add     rcx, 4
        cmp     edi, esi
        jge     .L32
        add     rax, 4
        jmp     .L4
.L9:
        mov     rdi, rcx
        mov     rsi, rax
        movsd
        mov     rax, rsi
        mov     rcx, rdi
.L29:
        cmp     rdx, rax
        jnb     .L9
        cmp     rdx, r10
        jb      .L33
        sub     rdx, r10
        xor     eax, eax
        shr     rdx, 2
        lea     rcx, [4+rdx*4]
.L13:
        mov     edx, DWORD PTR temp[rax]
        mov     DWORD PTR [r10+rax], edx
        add     rax, 4
        cmp     rcx, rax
        jne     .L13
        ret
.L2:
        cmp     r9, r8
        jb      .L29
        mov     rdi, rcx
        mov     rsi, r8
.L8:
        movsd
        cmp     r9, rsi
        jnb     .L8
        sub     r9, r8
        shr     r9, 2
        lea     rcx, [rcx+4+r9*4]
        jmp     .L29
.L33:
        ret
mergesort.part.0:
        mov     rax, rsi
        push    r12
        sub     rax, rdi
        push    rbp
        mov     rbp, rsi
        sar     rax, 3
        push    rbx
        mov     rbx, rdi
        lea     r12, [rdi+rax*4]
        cmp     rdi, r12
        jb      .L38
        lea     rdi, [r12+4]
        cmp     rdi, rbp
        jb      .L39
.L36:
        mov     rdx, rbp
        mov     rsi, r12
        mov     rdi, rbx
        pop     rbx
        pop     rbp
        pop     r12
        jmp     merge
.L38:
        mov     rsi, r12
        call    mergesort.part.0
        lea     rdi, [r12+4]
        cmp     rdi, rbp
        jnb     .L36
.L39:
        mov     rsi, rbp
        call    mergesort.part.0
        jmp     .L36
mergesort:
        cmp     rdi, rsi
        jb      .L42
        ret
.L42:
        jmp     mergesort.part.0
main:
        sub     rsp, 8
        mov     esi, OFFSET FLAT:array+48
        mov     edi, OFFSET FLAT:array
        call    mergesort.part.0
        xor     eax, eax
        add     rsp, 8
        ret
temp:
        .zero   52
array:
        .long   4
        .long   15
        .long   6
        .long   2
        .long   21
        .long   17
        .long   11
        .long   16
        .long   8
        .long   13
        .long   14
        .long   1
        .long   9