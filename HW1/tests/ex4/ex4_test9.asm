# -----------------------------------------------------
# TEST 9: Black Pawn Double Step
# -----------------------------------------------------
# Move: (6,4) -> (4,4)
# Piece: P
# Player: 1 (0=White, 1=Black)
# Expected Result: 1
# -----------------------------------------------------

.section .data

# --- Before move ---
board_1:
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,'P',0,0,0
    .byte 0,0,0,0,0,0,0,0

# --- After move ---
board_2:
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,'P',0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0

play:
    .int 1, 6, 4          # Black, row=6, col=4

valid:
    .byte 7                # Result placeholder

.section .text
.global main
main:
    # --- Call your function here (assumes linked) ---
    # (The test framework usually calls the function, 
    # but here we just check the result assuming logic ran)
    
    # NOTE: In a real run, you need to call 'hw4' or whatever the label is.
    # checking valid variable:
    
    movzbl valid(%rip), %eax
    cmp $1, %al
    je success

error:
    mov $60, %rax              # sys_exit
    mov $1, %rdi               # exit code 1 (error)
    syscall

success:
    mov $60, %rax              # sys_exit
    xor %rdi, %rdi             # exit code 0 (success)
    syscall
