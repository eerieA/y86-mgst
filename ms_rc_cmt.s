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
        mov     rax, rsi           # Copy the end pointer (rsi) to rax
        push    r12                # Save r12 (callee-saved register) on the stack
        sub     rax, rdi           # Calculate the size of the current segment: rax = rsi - rdi
        push    rbp                # Save rbp (callee-saved register) on the stack
        mov     rbp, rsi           # Save the end pointer (rsi) in rbp (callee-saved)
        sar     rax, 3             # Divide the size (rax) by 8 (size of a long) -> rax = (rsi - rdi) / 8
        push    rbx                # Save rbx (callee-saved register) on the stack
        mov     rbx, rdi           # Save the start pointer (rdi) in rbx (callee-saved)
        lea     r12, [rdi+rax*4]   # Compute the midpoint r12 = rdi + (rax * 4), dividing the array roughly in half
        cmp     rdi, r12           # Compare the start pointer (rdi) with the midpoint (r12)
        jb      .L38               # Jump to .L38 if rdi < r12 (if the array segment is large enough to sort further)
        lea     rdi, [r12+4]       # Set rdi to the next element after the midpoint (r12 + 4 bytes)
        cmp     rdi, rbp           # Compare rdi with the end pointer (rbp)
        jb      .L39               # Jump to .L39 if rdi < rbp (there are elements left in the second half to sort)
.L36:
        mov     rdx, rbp           # Set rdx to the end pointer (rbp)
        mov     rsi, r12           # Set rsi to the midpoint (r12), this is the beginning of the second half
        mov     rdi, rbx           # Set rdi to the start pointer (rbx), this is the beginning of the first half
        pop     rbx                # Restore the old value of rbx (popped from stack)
        pop     rbp                # Restore the old value of rbp (popped from stack)
        pop     r12                # Restore the old value of r12 (popped from stack)
        jmp     merge              # Jump to the merge function to merge the two sorted halves

.L38:                              # Recursively sort the first half
        mov     rsi, r12           # Set rsi to the midpoint (r12) for the first half
        call    mergesort.part.0   # Recursively sort the first half
        lea     rdi, [r12+4]       # Set rdi to the next element after the midpoint (r12 + 4 bytes)
        cmp     rdi, rbp           # Compare rdi with the end pointer (rbp)
        jnb     .L36               # If rdi >= rbp (no more elements to sort), jump to the merging phase (.L36)

.L39:                              # Recursively sort the second half
        mov     rsi, rbp           # Set rsi to the end pointer (rbp) for the second half
        call    mergesort.part.0   # Recursively sort the second half
        jmp     .L36               # After sorting, jump to the merging phase (.L36)

mergesort:                         # Outer fall-through for mergesort
        cmp     rdi, rsi           # Compare the start (rdi) and end (rsi) pointers
        jb      .L42               # If rdi < rsi, jump to start sorting (mergesort.part.0)
        ret                        # Otherwise, the array is already sorted, so return
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