.global _start

.section .text
_start:
    lea exp(%rip), %rbx     # Load ADDRESS of exp into rbx (not value)
    
    # We will use registers r8-r12 as our "stack"
    # r8 is Top of Stack
    xor %r8, %r8
    xor %r9, %r9
    xor %r10, %r10
    xor %r11, %r11
    xor %r12, %r12

loop_HW1:
    movb (%rbx), %al        # Read 1 byte from the string
	
    cmpb $0, %al            # Check for null terminator
    je done_HW1

    cmpb $',', %al
    je next_char_HW1

    # Check for Operators
    cmpb $0x2B, %al         # '+'
    je add_HW1
    cmpb $0x2D, %al         # '-'
    je sub_HW1
    cmpb $0x2A, %al         # '*'
    je mul_HW1
    cmpb $0x2F, %al         # '/'
    je div_HW1

    # Convert ASCII char to integer, it must be a Digit (0-9)
    subb $'0', %al
    movzbq %al, %rax        # Zero extend byte to 64-bit

    # PUSH OPERATION: Shift registers down to make room in %r8
    movq %r11, %r12
    movq %r10, %r11
    movq %r9, %r10
    movq %r8, %r9
    movq %rax, %r8          # Place new number in Top of Stack (%r8)

    jmp next_char_HW1

# --- Math Operations ---
# Logic: Operate on %r9 (LHS) and %r8 (RHS). Result goes to %r9 temporarily, then we shift up.

add_HW1:
    addq %r8, %r9           # r9 = r9 + r8
    jmp shift_up_HW1		# newr8 = oldr9 + oldr8

sub_HW1:
    subq %r8, %r9           # r9 = r9 - r8
    jmp shift_up_HW1		# newr8 = oldr9 - oldr8

mul_HW1:
    imulq %r8, %r9          # r9 = r9 * r8
    jmp shift_up_HW1		# newr8 = oldr9 * oldr8

div_HW1:
    # Division requires %rax and %rdx
    movq %r9, %rax          # Move Dividend (LHS) to rax
    divq %r8                # rax = rax / r8
    movq %rax, %r9          # Store Quotient back in r9
    jmp shift_up_HW1

shift_up_HW1:
    # We need to make %r9 the new Top of Stack (%r8) and pull others up.
    movq %r9, %r8           # New TOS gets the result
    movq %r10, %r9          # r10 moves up to r9
    movq %r11, %r10         # r11 moves up to r10
    movq %r12, %r11         # r12 moves up to r11

next_char_HW1:
    addq $1, %rbx               # Move to next char in string
    jmp loop_HW1

done_HW1:
    movl %r8d, res(%rip)    # Store lower 32-bits to res label
