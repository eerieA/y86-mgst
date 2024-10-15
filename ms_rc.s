copy:
        mov     rax, rdi
        mov     rcx, rsi
        cmp     rsi, rdi
        jb      .L4
        mov     rdi, rdx
        mov     rsi, rax
.L3:
        movsd
        cmp     rcx, rsi
        jnb     .L3
        sub     rcx, rax
        and     rcx, -4
        lea     rax, [rdx+4+rcx]
        ret
.L4:
        mov     rax, rdx
        ret
merge:
        mov     r11, rdx
        mov     r10, rdi
        mov     r9, rsi
        mov     r8, rdi
        lea     rdx, [rsi+4]
        mov     eax, OFFSET FLAT:temp
        cmp     rsi, rdi
        jnb     .L35
        jmp     .L8
.L36:
        mov     ecx, esi
        add     r8, 4
        mov     DWORD PTR [rax-4], ecx
        cmp     r9, r8
        jb      .L13
.L35:
        cmp     r11, rdx
        jb      .L8
        mov     esi, DWORD PTR [r8]
        mov     ecx, DWORD PTR [rdx]
        add     rax, 4
        cmp     esi, ecx
        jle     .L36
        mov     DWORD PTR [rax-4], ecx
        add     rdx, 4
        cmp     r9, r8
        jnb     .L35
.L13:
        cmp     r11, rdx
        jb      .L15
.L37:
        mov     rdi, rax
        mov     rsi, rdx
.L16:
        movsd
        cmp     r11, rsi
        jnb     .L16
        sub     r11, rdx
        and     r11, -4
        add     rax, r11
.L17:
        cmp     rax, OFFSET FLAT:temp
        jb      .L7
        sub     rax, OFFSET FLAT:temp
        shr     rax, 2
        lea     rcx, [4+rax*4]
        xor     eax, eax
.L19:
        mov     edx, DWORD PTR temp[rax]
        mov     DWORD PTR [r10+rax], edx
        add     rax, 4
        cmp     rax, rcx
        jne     .L19
.L7:
        ret
.L8:
        cmp     r9, r8
        jb      .L13
        mov     rdi, rax
        mov     rsi, r8
.L14:
        movsd
        cmp     r9, rsi
        jnb     .L14
        sub     r9, r8
        and     r9, -4
        lea     rax, [rax+4+r9]
        cmp     r11, rdx
        jnb     .L37
.L15:
        sub     rax, 4
        jmp     .L17
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
        jb      .L42
        lea     rdi, [r12+4]
        cmp     rdi, rbp
        jb      .L43
.L40:
        mov     rdx, rbp
        mov     rsi, r12
        mov     rdi, rbx
        pop     rbx
        pop     rbp
        pop     r12
        jmp     merge
.L42:
        mov     rsi, r12
        call    mergesort.part.0
        lea     rdi, [r12+4]
        cmp     rdi, rbp
        jnb     .L40
.L43:
        mov     rsi, rbp
        call    mergesort.part.0
        jmp     .L40
mergesort:
        cmp     rdi, rsi
        jb      .L46
        ret
.L46:
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