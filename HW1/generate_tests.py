#!/usr/bin/env python3
"""
Test generator for ex1 (vowel counting) and ex2 (RPN calculator)
Generates 40 test files for each exercise.
"""

import os
import random

# Vowels (both lowercase and uppercase)
VOWELS = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}

def count_vowels(s):
    """Count vowels in a string (case-insensitive)."""
    return sum(1 for c in s if c in VOWELS)

def generate_ex1_test(test_num, test_string, expected_count):
    """Generate a test file for ex1 (vowel counting)."""
    # Escape special characters for .string directive
    escaped_string = test_string.replace('\\', '\\\\').replace('"', '\\"')
    
    content = f"""# -----------------------------------------------------
# TEST {test_num}: Vowel Counting
# -----------------------------------------------------
# String: "{test_string}"
# Expected count: {expected_count}
# -----------------------------------------------------

.section .data

str:
    .string "{escaped_string}"

count:
    .int -1                # output result placeholder

.section .text

    # After ex1 returns, check if count matches expected value
    movl count(%rip), %eax
    cmp ${expected_count}, %eax
    je success

error:
    mov $60, %rax              # sys_exit
    mov $1, %rdi               # exit code 1 (error)
    syscall

success:
    mov $60, %rax              # sys_exit
    xor %rdi, %rdi             # exit code 0 (success)
    syscall
"""
    return content

def evaluate_rpn(expression):
    """Evaluate an RPN expression and return the result."""
    stack = []
    i = 0
    while i < len(expression):
        if expression[i] == ',':
            i += 1
            continue
        elif expression[i].isdigit():
            num = 0
            while i < len(expression) and expression[i].isdigit():
                num = num * 10 + int(expression[i])
                i += 1
            stack.append(num)
        elif expression[i] in ['+', '-', '*', '/']:
            if len(stack) < 2:
                return None
            b = stack.pop()
            a = stack.pop()
            if expression[i] == '+':
                stack.append(a + b)
            elif expression[i] == '-':
                stack.append(a - b)
            elif expression[i] == '*':
                stack.append(a * b)
            elif expression[i] == '/':
                if b == 0:
                    return None
                stack.append(a // b)
            i += 1
        else:
            i += 1
    return stack[0] if len(stack) == 1 else None

def generate_ex2_test(test_num, rpn_expression, expected_result):
    """Generate a test file for ex2 (RPN calculator)."""
    # Escape special characters for .string directive
    escaped_expr = rpn_expression.replace('\\', '\\\\').replace('"', '\\"')
    
    content = f"""# -----------------------------------------------------
# TEST {test_num}: RPN Calculator
# -----------------------------------------------------
# Expression: "{rpn_expression}"
# Expected result: {expected_result}
# -----------------------------------------------------

.section .data

exp:
    .string "{escaped_expr}"

res:
    .int -1                # output result placeholder

.section .text

    # After ex2 returns, check if res matches expected value
    movl res(%rip), %eax
    cmp ${expected_result}, %eax
    je success

error:
    mov $60, %rax              # sys_exit
    mov $1, %rdi               # exit code 1 (error)
    syscall

success:
    mov $60, %rax              # sys_exit
    xor %rdi, %rdi             # exit code 0 (success)
    syscall
"""
    return content

def generate_ex1_tests():
    """Generate 40 test cases for ex1 (vowel counting)."""
    tests = []
    
    # Edge cases
    tests.append(("", 0))  # Empty string
    tests.append(("aeiou", 5))  # All lowercase vowels
    tests.append(("AEIOU", 5))  # All uppercase vowels
    tests.append(("xyz", 0))  # No vowels
    tests.append(("bcdfg", 0))  # No vowels
    
    # Simple cases
    tests.append(("hello", 2))
    tests.append(("world", 1))
    tests.append(("python", 1))
    tests.append(("assembly", 2))
    tests.append(("programming", 3))
    
    # Mixed case
    tests.append(("Hello", 2))
    tests.append(("WORLD", 1))
    tests.append(("PyThOn", 1))
    tests.append(("AsSeMbLy", 2))
    
    # Longer strings
    tests.append(("aeiouaeiou", 10))
    tests.append(("hello world", 3))
    tests.append(("the quick brown fox", 5))
    tests.append(("abcdefghijklmnopqrstuvwxyz", 5))
    
    # Single character
    tests.append(("a", 1))
    tests.append(("b", 0))
    tests.append(("E", 1))
    tests.append(("Z", 0))
    
    # Repeated vowels
    tests.append(("aaaa", 4))
    tests.append(("eeeee", 5))
    tests.append(("iiiiii", 6))
    tests.append(("ooooooo", 7))
    tests.append(("uuuuuuuu", 8))
    
    # Mixed patterns
    tests.append(("a1e2i3o4u5", 5))
    tests.append(("test123", 1))
    tests.append(("vowel", 2))
    tests.append(("consonant", 3))
    
    # Generate random tests to reach 40
    consonants = "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ"
    vowels_list = list("aeiouAEIOU")
    
    while len(tests) < 40:
        # Random length between 1 and 20
        length = random.randint(1, 20)
        test_str = ""
        vowel_count = 0
        
        for _ in range(length):
            if random.random() < 0.3:  # 30% chance of vowel
                char = random.choice(vowels_list)
                vowel_count += 1
            else:
                char = random.choice(consonants)
            test_str += char
        
        tests.append((test_str, vowel_count))
    
    return tests[:40]

def generate_ex2_tests():
    """Generate 40 test cases for ex2 (RPN calculator)."""
    tests = []
    
    # Simple single operations
    tests.append(("7,4+", 11))
    tests.append(("9,3-", 6))
    tests.append(("2,3*", 6))
    tests.append(("8,2/", 4))
    tests.append(("5,1+", 6))
    tests.append(("9,4-", 5))
    tests.append(("3,4*", 12))
    tests.append(("9,3/", 3))
    
    # Two operations
    tests.append(("1,2+3+", 6))  # (1+2)+3
    tests.append(("5,3-2-", 0))  # (5-3)-2
    tests.append(("2,3*4*", 24))  # (2*3)*4
    tests.append(("8,4/2/", 1))  # (8/4)/2
    
    # Mixed operations
    tests.append(("1,2+3*", 9))  # (1+2)*3
    tests.append(("1,2*3+", 5))  # (1*2)+3
    tests.append(("5,9,2*+", 23))  # 5+(9*2)
    tests.append(("1,2*3,4*+", 14))  # (1*2)+(3*4)
    
    # More complex
    tests.append(("2,3+4,5+*", 45))  # (2+3)*(4+5)
    tests.append(("8,2/3+", 7))  # (8/2)+3
    tests.append(("6,2/3*", 9))  # (6/2)*3
    tests.append(("8,4/2*", 4))  # (8/4)*2
    
    # Single digits with multiple operations
    tests.append(("1,2,3++", 6))
    tests.append(("9,3,1--", 7))
    tests.append(("2,2,2***", 8))  # (2*2)*2 = 8
    tests.append(("8,2,2//", 8))   # (8/2)/1 = 8, where 2/2=1
    
    # Edge cases
    tests.append(("0,5+", 5))
    tests.append(("5,0+", 5))
    tests.append(("1,1*", 1))
    tests.append(("9,1/", 9))
    
    # Longer chains
    tests.append(("1,2+3,4+*", 21))  # (1+2)*(3+4)
    tests.append(("2,3*4,5*+", 26))  # (2*3)+(4*5)
    tests.append(("8,2/5,3-*", 8))  # (8/2)*(5-3)
    
    # Generate more to reach 40
    while len(tests) < 40:
        # Generate a valid RPN expression
        # Stack depth constraint: max 5 values
        # So we can have at most 4 operations (need 5 values)
        num_ops = random.randint(1, 4)  # 1-4 operations
        num_values = num_ops + 1
        
        # Ensure we don't exceed stack depth of 5
        if num_values > 5:
            num_values = 5
            num_ops = 4
        
        # Generate values (single digits 1-9 to avoid division by zero)
        values = [random.randint(1, 9) for _ in range(num_values)]
        ops = [random.choice(['+', '-', '*', '/']) for _ in range(num_ops)]
        
        # Build RPN expression: values separated by commas, then operators
        expr = ""
        for i in range(num_values - 1):
            expr += f"{values[i]},"
        expr += f"{values[num_values - 1]}"
        for op in ops:
            expr += op
        
        # Evaluate to get expected result
        result = evaluate_rpn(expr)
        if result is not None and result >= 0:  # Only positive results for simplicity
            tests.append((expr, result))
    
    return tests[:40]

def main():
    """Generate all test files."""
    # Create tests directory if it doesn't exist
    tests_dir = "tests"
    if not os.path.exists(tests_dir):
        os.makedirs(tests_dir)
    
    # Create exercise subdirectories
    ex1_dir = os.path.join(tests_dir, "ex1")
    ex2_dir = os.path.join(tests_dir, "ex2")
    if not os.path.exists(ex1_dir):
        os.makedirs(ex1_dir)
    if not os.path.exists(ex2_dir):
        os.makedirs(ex2_dir)
    
    # Generate ex1 tests
    print("Generating ex1 tests...")
    ex1_tests = generate_ex1_tests()
    for i, (test_string, expected_count) in enumerate(ex1_tests, 1):
        filename = os.path.join(ex1_dir, f"ex1_test{i}")
        content = generate_ex1_test(i, test_string, expected_count)
        with open(filename, 'w') as f:
            f.write(content)
        print(f"  Created {filename}")
    
    # Generate ex2 tests
    print("\nGenerating ex2 tests...")
    ex2_tests = generate_ex2_tests()
    for i, (rpn_expr, expected_result) in enumerate(ex2_tests, 1):
        filename = os.path.join(ex2_dir, f"ex2_test{i}")
        content = generate_ex2_test(i, rpn_expr, expected_result)
        with open(filename, 'w') as f:
            f.write(content)
        print(f"  Created {filename}")
    
    print(f"\nDone! Generated {len(ex1_tests)} ex1 tests and {len(ex2_tests)} ex2 tests.")

if __name__ == "__main__":
    main()

