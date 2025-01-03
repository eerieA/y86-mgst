merge:
        mov     r10, rdi
        mov     r9, rsi
        lea     rax, [rdx+4]
        cmp     rdx, rdi
        jb      .L13
        cmp     rsi, rax
        jb      .L13
        mov     esi, OFFSET FLAT:temp+4
        mov     r8, rdi
        jmp     .L5
.L3:
        add     rax, 4
        mov     rcx, rsi
        mov     edi, r11d
.L4:
        mov     DWORD PTR [rsi-4], edi
        add     rsi, 4
        cmp     rdx, r8
        jb      .L2
        cmp     r9, rax
        jb      .L2
.L5:
        mov     edi, DWORD PTR [r8]
        mov     r11d, DWORD PTR [rax]
        cmp     edi, r11d
        jg      .L3
        add     r8, 4
        mov     rcx, rsi
        jmp     .L4
.L13:
        mov     r8, r10
        mov     ecx, OFFSET FLAT:temp
.L2:
        cmp     rdx, r8
        jb      .L7
        mov     rdi, rcx
        mov     rsi, r8
.L8:
        add     rsi, 4
        add     rdi, 4
        mov     r11d, DWORD PTR [rsi-4]
        mov     DWORD PTR [rdi-4], r11d
        cmp     rdx, rsi
        jnb     .L8
        sub     rdx, r8
        shr     rdx, 2
        lea     rcx, [rcx+4+rdx*4]
.L7:
        cmp     r9, rax
        jb      .L9
.L10:
        add     rax, 4
        add     rcx, 4
        mov     edx, DWORD PTR [rax-4]
        mov     DWORD PTR [rcx-4], edx
        cmp     r9, rax
        jnb     .L10
.L9:
        cmp     r9, r10
        jb      .L1
        sub     r9, r10
        shr     r9, 2
        lea     rcx, [4+r9*4]
        mov     eax, 0
.L12:
        mov     edx, DWORD PTR temp[rax]
        mov     DWORD PTR [r10+rax], edx
        add     rax, 4
        cmp     rax, rcx
        jne     .L12
.L1:
        ret

mergesort:
        cmp     rdi, rsi              # Compare rdi (first) with rsi (last)
        jb      .L24                  # If first < last, go to main part
        ret
.L24:
        push    r12                   # Save r12 (callee-saved register)
        push    rbp                   # Save rbp (callee-saved register)
        push    rbx                   # Save rbx (callee-saved register)
        mov     rbx, rdi              # Copy first in rbx
        mov     rbp, rsi              # Copy last in rbp

        mov     rax, rsi              # rax = last
        sub     rax, rdi              # rax = last - first
        mov     rdx, rax
        sar     rdx, 2                # rdx = (last-first) / 4
        shr     rax, 63               # Copy sign bit of rax into all bits, handle signed division
        add     rax, rdx              # Add rax and rdx (adjustment for signed division)
        sar     rax                   # right shift, rax /= 2, rax is now midpoint idx

        lea     r12, [rdi+rax*4]      # r12 = rdi + midpoint * 4, midpoint addr
        mov     rsi, r12              # rsi = midpoint, for mergesort(first, mid)
        call    mergesort

        lea     rdi, [r12+4]          # rdi = r12 + 4 (mid + 1)
        mov     rsi, rbp              # rsi = last, for mergesort(mid+1, last)
        call    mergesort

        mov     rdx, r12              # rdx = midpoint, for merge()
        mov     rsi, rbp              # rsi = last, for merge()
        mov     rdi, rbx              # rdi = first, for merge()
        call    merge
        pop     rbx
        pop     rbp
        pop     r12
        ret

main:
        sub     rsp, 8
        mov     esi, OFFSET FLAT:array+48
        mov     edi, OFFSET FLAT:array
        call    mergesort
        mov     eax, 0
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