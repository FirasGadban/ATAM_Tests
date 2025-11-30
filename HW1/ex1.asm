.global _start

.section .text
_start:
    movq $0, %rax           # Initialize counter to 0
    movq $str, %rbx         # Load address of 'str' into rbx

my_loop_HW1:
    movb (%rbx), %cl        # Load current char (byte) into cl
    
    cmpb $0, %cl            # Check for null terminator (end of str)
    je end_loop_HW1         # exit loop

    cmpb $'A', %cl          # Compare with 'A'
    jl check_vowels_HW1         # If less than 'A', it's not a capital letter (skip conversion)
    
    cmpb $'Z', %cl          # Compare with 'Z'
    jg check_vowels_HW1         # If greater than 'Z', it's not a capital letter (skip conversion)

    # If we are here, the char is between 'A' and 'Z'.
    addb $32, %cl           # Convert to lowercase (Add 32 to ASCII value)
    

check_vowels_HW1:
    cmpb $'a', %cl          # Check if char is 'a'
    je is_vowel_HW1       
    
    cmpb $'e', %cl          # Check if char is 'e'
    je is_vowel_HW1
    
    cmpb $'i', %cl          # Check if char is 'i'
    je is_vowel_HW1
    
    cmpb $'o', %cl          # Check if char is 'o'
    je is_vowel_HW1
    
    cmpb $'u', %cl          # Check if char is 'u'
    je is_vowel_HW1

    jmp next_iter_HW1       # Not a vowel

is_vowel_HW1: 
    addq $1, %rax           # Increment vowel counter

next_iter_HW1:
    addq $1, %rbx           # Move pointer to next char
    jmp my_loop_HW1         # Jump back to start of loop

end_loop_HW1:
    movl %eax, count(%rip)      # Store final result in 'count'
	