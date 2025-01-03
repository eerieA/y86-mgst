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

mergesort:
        push    r15                # Save r15 (callee-saved register) on the stack
        mov     rax, rsi           # Copy the end pointer (rsi) to rax
        mov     r15, rsi           # Save the end pointer (rsi) in r15 (callee-saved)
        push    r14                # Save r14 (callee-saved register) on the stack
        sub     rax, rdi           # Calculate the size of the array: rax = rsi - rdi
        mov     r14, rdi           # Save the start pointer (rdi) in r14 (callee-saved)
        push    r13                # Save r13 (callee-saved register) on the stack
        sar     rax, 2             # Divide the size (rax) by 4, because this is a 32-bit (4-byte) array
        mov     r13d, 1            # Initialize r13d to 1 (this will be the merge size, starts with 1 element)
        push    r12                # Save r12 (callee-saved register) on the stack
        add     eax, 1             # Increment rax by 1 to adjust the size (round up for odd sizes)
        push    rbp                # Save rbp (callee-saved register) on the stack
        push    rbx                # Save rbx (callee-saved register) on the stack
        sub     rsp, 8             # Allocate 8 bytes of space on the stack
        mov     DWORD PTR [rsp+4], eax  # Store the adjusted size in memory (on the stack at rsp + 4)
        cmp     eax, 1             # Compare the size with 1
        jle     .L34               # If size <= 1, the array is already sorted, jump to .L34 (exit)

.L35:                              # Main loop (iterates over different merge sizes)
        movsx   rdx, r13d          # Sign-extend r13d (current merge size) to 64 bits and store in rdx
        add     r13d, r13d         # Double the merge size (merge two blocks of the current size)
        cmp     r15, r14           # Compare the end pointer (r15) with the start pointer (r14)
        jb      .L39               # If r15 < r14 (array size is too small), jump to .L39 (exit the loop)
        
        movsx   rbx, r13d          # Sign-extend the new merge size (r13d) to 64 bits and store in rbx
        lea     r12, [-4+rdx*4]    # Calculate the offset for the midpoint: r12 = (rdx * 4) - 4
        mov     r11, r14           # Set r11 to the start pointer (r14)
        sal     rbx, 2             # Multiply the merge size (rbx) by 4 (scale to 32-bit array elements)
        lea     rbp, [rbx-4]       # Calculate rbp = rbx - 4 (size for the merge blocks)

.L37:                              # Loop through each pair of blocks to merge them
        lea     rdx, [rbp+0+r11]   # Calculate the pointer to the end of the current block (rdx = rbp + r11)
        lea     rsi, [r12+r11]     # Calculate the pointer to the midpoint of the block (rsi = r12 + r11)
        mov     rdi, r11           # Set rdi to the start of the current block (r11)
        cmp     r15, rdx           # Compare the end pointer (r15) with the calculated end of the block (rdx)
        cmovbe  rdx, r15           # If rdx > r15, set rdx to r15 (ensure the block doesn’t go out of bounds)
        add     r11, rbx           # Move r11 to the start of the next block (r11 = r11 + rbx)
        call    merge              # Call the merge function to merge the two sorted blocks
        cmp     r15, r11           # Compare the end pointer (r15) with the current pointer (r11)
        jnb     .L37               # If r15 >= r11, continue merging the next block

.L39:                              # End of the current iteration over block pairs
        mov     eax, DWORD PTR [rsp+4]  # Load the original size of the array from the stack
        cmp     r13d, eax          # Compare the current merge size (r13d) with the array size (eax)
        jl      .L35               # If the merge size is less than the array size, go back to .L35 to merge larger blocks

.L34:                              # Cleanup and exit
        add     rsp, 8             # Deallocate the 8 bytes of space from the stack
        pop     rbx                # Restore rbx from the stack
        pop     rbp                # Restore rbp from the stack
        pop     r12                # Restore r12 from the stack
        pop     r13                # Restore r13 from the stack
        pop     r14                # Restore r14 from the stack
        pop     r15                # Restore r15 from the stack
        ret                        # Return from the function

main:
        mov     esi, OFFSET FLAT:array+48
        mov     edi, OFFSET FLAT:array
        call    mergesort
        xor     eax, eax
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