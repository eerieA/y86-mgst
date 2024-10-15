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
        jb      .L42               # Jump to .L42 if rdi < r12 (if the array segment is large enough to sort further)
        
        lea     rdi, [r12+4]       # Set rdi to the next element after the midpoint (r12 + 4 bytes)
        cmp     rdi, rbp           # Compare rdi with the end pointer (rbp)
        jb      .L43               # Jump to .L43 if rdi < rbp (there are elements left in the second half to sort)
        
.L40:                              # Merge the sorted halves
        mov     rdx, rbp           # Set rdx to the end pointer (rbp)
        mov     rsi, r12           # Set rsi to the midpoint (r12), this is the beginning of the second half
        mov     rdi, rbx           # Set rdi to the start pointer (rbx), this is the beginning of the first half
        pop     rbx                # Restore the old value of rbx (popped from stack)
        pop     rbp                # Restore the old value of rbp (popped from stack)
        pop     r12                # Restore the old value of r12 (popped from stack)
        jmp     merge              # Jump to the merge function to merge the two sorted halves

.L42:                              # Recursively sort the first half
        mov     rsi, r12           # Set rsi to the midpoint (r12) for the first half
        call    mergesort.part.0   # Recursively sort the first half
        lea     rdi, [r12+4]       # Set rdi to the next element after the midpoint (r12 + 4 bytes)
        cmp     rdi, rbp           # Compare rdi with the end pointer (rbp)
        jnb     .L40               # If rdi >= rbp (no more elements to sort), jump to the merging phase (.L40)

.L43:                              # Recursively sort the second half
        mov     rsi, rbp           # Set rsi to the end pointer (rbp) for the second half
        call    mergesort.part.0   # Recursively sort the second half
        jmp     .L40               # After sorting, jump to the merging phase (.L40)

mergesort:                         # Entry point for mergesort
        cmp     rdi, rsi           # Compare the start (rdi) and end (rsi) pointers
        jb      .L46               # If rdi < rsi, jump to start sorting (mergesort.part.0)
        ret                        # Otherwise, the array is already sorted, so return

.L46:
        jmp     mergesort.part.0   # Jump to mergesort.part.0 to start sorting

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