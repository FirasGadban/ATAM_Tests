.global _start

.section .text
_start:
   
    lea str, %rsi           # Load source address
    lea enc, %rdi           # Load dest address

    xor %rax, %rax          # Clear rax
    movb (%rsi), %al        # Load first char into al 
    cmpb $0, %al            # Check if empty str
    je terminate_string_HW1     # Go to terminate to write "\0" if empty

    movb %al, %r8b          # Save current char in r8b
    movq $1, %rcx           # Init counter
    addq $1, %rsi           # Move pointer to next char 

count_char_loop_HW1:
    movb (%rsi), %al        # Read new char into al
    
	cmpb $0, %al            # Check null terminator
    je sequence_ended_HW1     

    cmpb %r8b, %al          # Compare with current(al) and previos saved in r8b
    jne sequence_ended_HW1  # If diff, process seq

    addq $1, %rcx           # If same : Increment counter
    addq $1, %rsi           # Move pointer to next char
    jmp count_char_loop_HW1    


sequence_ended_HW1:
    movb %al, %r9b          # Save the "next" char (sequence breaker) in r9b
    movq %rcx, %rax         # Move count to rax
    movq $1, %r10           # Init divisor


find_max_power_10_HW1:
    movq %r10, %rbx
    imulq $10, %rbx         # Calc power of 10
    cmpq %rax, %rbx         # Check if div > num
    jg print_digits_loop_HW1 # If bigger, start printing
    movq %rbx, %r10         # Update divisor
    jmp find_max_power_10_HW1

# --- Printing Loop: Convert Number to ASCII ---
# Divide the number by the divisor to get the leading digit. 
# Convert it to ASCII ('0'-'9'), write it to memory, and repeat for the remainder.
print_digits_loop_HW1:
    xor %rdx, %rdx          # Clear remainder
    div %r10                # Divide rax by r10
    
    addb $'0', %al          # Convert to ASCII
    movb %al, (%rdi)        # Write digit to dest
    addq $1, %rdi           # Inc dest pointer

    movq %rdx, %rax         # Remainder becomes next num
    
    xor %rdx, %rdx          # Clear remainder for next div
    movq %rax, %rbx         # Save num temp
    movq %r10, %rax         # Load divisor to rax
    movq $10, %r12          # Set divisor 10
    div %r12                # Div divisor by 10
    movq %rax, %r10         # Update divisor
    movq %rbx, %rax         # Restore num

    cmpq $0, %r10           # Check if divisor is 0
    jne print_digits_loop_HW1

    movb %r8b, (%rdi)       # Write current char itself
    addq $1, %rdi           # Inc dest pointer

	cmpb $0, %r9b           # Check the "next" char saved in r9b
    je terminate_string_HW1 # If it is 0, end of string reached

    movb %r9b, %r8b         # Update current char
    movq $1, %rcx           # Reset counter to 1
    addq $1, %rsi           # Inc source pointer
    jmp count_char_loop_HW1


terminate_string_HW1:
    movb $0, (%rdi)      #Add Null Terminator to dest string

exit_program_HW1:
    # Done
	