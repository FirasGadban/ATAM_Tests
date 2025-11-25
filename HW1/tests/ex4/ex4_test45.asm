# -----------------------------------------------------
# TEST 45: Filler Test Pawn 16 Valid
# -----------------------------------------------------
# Move: (3,3) -> (4,3)
# Piece: p
# Player: 0 (0=White, 1=Black)
# Expected Result: 1
# -----------------------------------------------------

.section .data

# --- Before move ---
board_1:
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,'p',0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0

# --- After move ---
board_2:
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,'p',0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0

play:
    .int 0, 3, 3          # White, row=3, col=3

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
