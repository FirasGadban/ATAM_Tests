.global _start

.section .text
_start:
    lea board_1(%rip), %r12
    lea board_2(%rip), %r13
    lea play(%rip), %r14
    lea valid(%rip), %r15

    movb $0, (%r15)

    movl (%r14), %ebx        # side: 0 white, 1 black
    movl 4(%r14), %ecx       # origin row
    movl 8(%r14), %edx       # origin col

    cmpl $0, %ebx
    jl invalid_exit
    cmpl $1, %ebx
    jg invalid_exit

    cmpl $0, %ecx
    jl invalid_exit
    cmpl $7, %ecx
    jg invalid_exit
    cmpl $0, %edx
    jl invalid_exit
    cmpl $7, %edx
    jg invalid_exit

    movl %ecx, %r8d
    shll $3, %r8d
    addl %edx, %r8d          # origin index

    movzbl (%r12,%r8,1), %r11d
    cmpb $0, %r11b
    je invalid_exit

    cmpl $0, %ebx
    jne check_black_piece
    cmpb $'a', %r11b
    jl invalid_exit
    cmpb $'z', %r11b
    jg invalid_exit
    jmp piece_color_ok

check_black_piece:
    cmpb $'A', %r11b
    jl invalid_exit
    cmpb $'Z', %r11b
    jg invalid_exit

piece_color_ok:
    movl $-1, %r9d           # destination index (unset)
    xor %r10d, %r10d         # holds board1 dest occupant
    xor %edi, %edi           # loop counter

diff_loop:
    cmpl $64, %edi
    jge diff_done

    movzbl (%r12,%rdi,1), %eax
    movzbl (%r13,%rdi,1), %esi
    cmpl %eax, %esi
    je next_cell

    cmpl %edi, %r8d
    jne diff_non_origin
    cmpl $0, %esi
    jne invalid_exit
    jmp next_cell

diff_non_origin:
    cmpl $-1, %r9d
    jne invalid_exit
    movl %edi, %r9d
    movl %eax, %r10d         # board_1 occupant at destination
    cmpl %r11d, %esi         # board_2 must contain moving piece
    jne invalid_exit

next_cell:
    addl $1, %edi
    jmp diff_loop

diff_done:
    cmpl $-1, %r9d
    je invalid_exit

    movl %r10d, %eax
    cmpl $0, %eax
    je dest_empty
    cmpl $0, %ebx
    jne dest_for_black
    cmpb $'A', %al
    jl invalid_exit
    cmpb $'Z', %al
    jg invalid_exit
    movl $1, %r10d
    jmp occupant_checked

dest_for_black:
    cmpb $'a', %al
    jl invalid_exit
    cmpb $'z', %al
    jg invalid_exit
    movl $1, %r10d
    jmp occupant_checked

dest_empty:
    xor %r10d, %r10d

occupant_checked:
    movl %r9d, %eax
    movl %eax, %esi
    shrl $3, %esi            # dest row
    movl %eax, %edi
    andl $7, %edi            # dest col

    movl %esi, %eax
    subl %ecx, %eax
    movl %eax, %esi          # dr

    movl %edi, %eax
    subl %edx, %eax
    movl %eax, %edi          # dc

    cmpl $0, %esi
    jne have_displacement
    cmpl $0, %edi
    jne have_displacement
    jmp invalid_exit

have_displacement:
    movl %r11d, %eax
    orl $0x20, %eax
    movl %eax, %r11d         # lowercase type

    cmpb $'k', %r11b
    je piece_king
    cmpb $'q', %r11b
    je piece_queen
    cmpb $'r', %r11b
    je piece_rook
    cmpb $'b', %r11b
    je piece_bishop
    cmpb $'n', %r11b
    je piece_knight
    cmpb $'p', %r11b
    je piece_pawn
    jmp invalid_exit

piece_rook:
    jmp rook_logic

piece_queen:
    movl %esi, %eax
    cmpl $0, %eax
    je rook_logic
    movl %edi, %eax
    cmpl $0, %eax
    je rook_logic
    jmp bishop_logic

piece_bishop:
    jmp bishop_logic

piece_king:
    movl %esi, %eax
    cmpl $0, %eax
    jge king_abs_row
    imull $-1, %eax
king_abs_row:
    movl %eax, %ebp          # |dr|
    movl %edi, %edx
    cmpl $0, %edx
    jge king_abs_col
    imull $-1, %edx
king_abs_col:
    cmpl $1, %ebp
    jg invalid_exit
    cmpl $1, %edx
    jg invalid_exit
    cmpl $0, %esi
    jne move_success
    cmpl $0, %edi
    jne move_success
    jmp invalid_exit

piece_knight:
    movl %esi, %eax
    cmpl $0, %eax
    jge knight_abs_row
    imull $-1, %eax
knight_abs_row:
    movl %eax, %ebp          # |dr|
    movl %edi, %edx
    cmpl $0, %edx
    jge knight_abs_col
    imull $-1, %edx
knight_abs_col:
    cmpl $1, %ebp
    jne knight_check_two
    cmpl $2, %edx
    jne invalid_exit
    jmp move_success
knight_check_two:
    cmpl $2, %ebp
    jne invalid_exit
    cmpl $1, %edx
    jne invalid_exit
    jmp move_success

piece_pawn:
    movl %edi, %eax
    cmpl $0, %eax
    jge pawn_abs_dc
    imull $-1, %eax
pawn_abs_dc:
    movl %eax, %ebp          # |dc|
    cmpl $0, %ebx
    je pawn_white

pawn_black:
    cmpl $-1, %esi
    je pawn_black_one
    cmpl $-2, %esi
    je pawn_black_two
    jmp invalid_exit

pawn_black_one:
    cmpl $0, %ebp
    je pawn_black_forward
    cmpl $1, %ebp
    jne invalid_exit
    cmpl $1, %r10d
    jne invalid_exit
    jmp move_success

pawn_black_forward:
    cmpl $0, %r10d
    jne invalid_exit
    jmp move_success

pawn_black_two:
    cmpl $0, %ebp
    jne invalid_exit
    cmpl $0, %r10d
    jne invalid_exit
    cmpl $6, %ecx
    jne invalid_exit
    movl %r8d, %eax
    subl $8, %eax
    movzbl (%r12,%rax,1), %edx
    cmpl $0, %edx
    jne invalid_exit
    jmp move_success

pawn_white:
    cmpl $1, %esi
    je pawn_white_one
    cmpl $2, %esi
    je pawn_white_two
    jmp invalid_exit

pawn_white_one:
    cmpl $0, %ebp
    je pawn_white_forward
    cmpl $1, %ebp
    jne invalid_exit
    cmpl $1, %r10d
    jne invalid_exit
    jmp move_success

pawn_white_forward:
    cmpl $0, %r10d
    jne invalid_exit
    jmp move_success

pawn_white_two:
    cmpl $0, %ebp
    jne invalid_exit
    cmpl $0, %r10d
    jne invalid_exit
    cmpl $1, %ecx
    jne invalid_exit
    movl %r8d, %eax
    addl $8, %eax
    movzbl (%r12,%rax,1), %edx
    cmpl $0, %edx
    jne invalid_exit
    jmp move_success

rook_logic:
    movl %esi, %eax
    cmpl $0, %eax
    jne rook_vertical
    movl %edi, %eax
    cmpl $0, %eax
    je invalid_exit
    movl %edi, %ebp
    cmpl $0, %ebp
    jl rook_step_neg1
    movl $1, %ebp
    jmp rook_have_step

rook_step_neg1:
    movl $-1, %ebp
    jmp rook_have_step

rook_vertical:
    movl %edi, %eax
    cmpl $0, %eax
    jne invalid_exit
    movl %esi, %ebp
    cmpl $0, %ebp
    jl rook_step_neg8
    movl $8, %ebp
    jmp rook_have_step

rook_step_neg8:
    movl $-8, %ebp

rook_have_step:
    movl %r8d, %eax

rook_path_loop:
    addl %ebp, %eax
    cmpl %eax, %r9d
    je move_success
    movzbl (%r12,%rax,1), %edx
    cmpl $0, %edx
    jne invalid_exit
    jmp rook_path_loop

bishop_logic:
    movl %esi, %eax
    cmpl $0, %eax
    je invalid_exit
    movl %edi, %edx
    cmpl $0, %edx
    je invalid_exit

    movl %esi, %eax
    cmpl $0, %eax
    jge bishop_abs_dr
    imull $-1, %eax
bishop_abs_dr:
    movl %eax, %ebp
    movl %edi, %edx
    cmpl $0, %edx
    jge bishop_abs_dc
    imull $-1, %edx
bishop_abs_dc:
    cmpl %ebp, %edx
    jne invalid_exit

    movl %esi, %eax
    cmpl $0, %eax
    jg bishop_dr_pos
    movl %edi, %edx
    cmpl $0, %edx
    jg bishop_step_neg7
    movl $-9, %ebp
    jmp bishop_have_step

bishop_step_neg7:
    movl $-7, %ebp
    jmp bishop_have_step

bishop_dr_pos:
    movl %edi, %edx
    cmpl $0, %edx
    jg bishop_step_pos9
    movl $7, %ebp
    jmp bishop_have_step

bishop_step_pos9:
    movl $9, %ebp

bishop_have_step:
    movl %r8d, %eax

bishop_path_loop:
    addl %ebp, %eax
    cmpl %eax, %r9d
    je move_success
    movzbl (%r12,%rax,1), %edx
    cmpl $0, %edx
    jne invalid_exit
    jmp bishop_path_loop

move_success:
    movb $1, (%r15)
    jmp finish_ex4

invalid_exit:
    movb $0, (%r15)

finish_ex4:
