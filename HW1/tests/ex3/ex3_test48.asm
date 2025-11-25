
.section .data
# הקלט לתרגיל
str:
    .string "HHHHHSSSSSSSSSSSSSSSZZZZZZZZZZZZZZhhhhhhSSSSSSSSSSSSSSooooooooooooooopppppppppppp"

# המקום שבו הקוד שלך צריך לכתוב את התוצאה
enc:
    .zero 200      # מקצה 200 בתים מאופסים לכתיבה

# התוצאה הצפויה (לצורך בדיקה בלבד)
expected:
    .string "5H15S14Z6h14S15o12p"

.section .text
# --- בדיקת התוצאה (strcmp) ---
check_result:
    # הכנת מצביעים להשוואה
    movq $enc, %rdi        # המחרוזת שלך
    movq $expected, %rsi   # המחרוזת הנכונה

compare_loop:
    movb (%rdi), %al       # טען תו מהפלט שלך
    movb (%rsi), %bl       # טען תו מהצפי
    
    cmpb %al, %bl          # השוואה
    jne error              # אם שונים - שגיאה
    
    cmpb $0, %al           # האם הגענו לסוף המחרוזת (NULL)?
    je success             # אם כן (וגם השני היה 0 כי עברנו את ה-cmp), הצלחה
    
    incq %rdi              # קדם מצביע
    incq %rsi              # קדם מצביע
    jmp compare_loop

error:
    movq $60, %rax
    movq $1, %rdi
    syscall

success:
    movq $60, %rax
    xorq %rdi, %rdi
    syscall
