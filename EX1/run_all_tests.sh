#!/bin/bash

TESTS_DIR="tests"
PASSED=0
FAILED=0
TOTAL=0

# Check if tests directory exists
if [ ! -d "$TESTS_DIR" ]; then
    echo -e "\033[31mError: $TESTS_DIR directory not found\033[0m"
    exit 1
fi

# Discover available exercises from test files
declare -a available_exercises
for test_file in "$TESTS_DIR"/*; do
    [ -f "$test_file" ] || continue
    test_name=$(basename -- "$test_file")
    ex_prefix=$(echo "$test_name" | cut -d'_' -f1)
    
    # Check if we already have this exercise and if ASM file exists
    if [[ ! " ${available_exercises[@]} " =~ " ${ex_prefix} " ]] && [ -f "${ex_prefix}.asm" ]; then
        available_exercises+=("$ex_prefix")
    fi
done

# Sort exercises
IFS=$'\n' available_exercises=($(sort <<<"${available_exercises[*]}"))
unset IFS

# Check if any exercises found
if [ ${#available_exercises[@]} -eq 0 ]; then
    echo -e "\033[31mError: No exercises with tests found\033[0m"
    exit 1
fi

# Display menu
echo "Available exercises:"
for i in "${!available_exercises[@]}"; do
    echo "  $((i+1))) ${available_exercises[$i]}"
done
echo ""

# Get user selection
read -p "Select exercise to test (1-${#available_exercises[@]}): " selection

# Validate selection
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#available_exercises[@]} ]; then
    echo -e "\033[31mError: Invalid selection\033[0m"
    exit 1
fi

# Get selected exercise
SELECTED_EX="${available_exercises[$((selection-1))]}"
echo ""
echo "Running tests for ${SELECTED_EX}..."
echo ""

# Iterate through test files for selected exercise
for test_file in "$TESTS_DIR"/${SELECTED_EX}_*; do
    # Skip if not a regular file
    [ -f "$test_file" ] || continue
    
    # Get basename of test file
    test_name=$(basename -- "$test_file")
    
    # Construct ASM filename
    asm_file="${SELECTED_EX}.asm"
    
    # Check if ASM file exists
    if [ ! -f "$asm_file" ]; then
        echo -e "Skipping ${test_name}: \033[33m${asm_file} not found\033[0m"
        continue
    fi
    
    # Run the test
    TOTAL=$((TOTAL + 1))
    ./run_test.sh "$asm_file" "$test_file"
    
    # Check exit status
    if [ $? -eq 0 ]; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
    
    echo ""
done

# Print summary
echo "----------------------------------------"
echo "Summary for ${SELECTED_EX}:"
echo -e "  Total tests: ${TOTAL}"
echo -e "  \033[32mPassed: ${PASSED}\033[0m"
echo -e "  \033[31mFailed: ${FAILED}\033[0m"
echo "----------------------------------------"

# Exit with appropriate code
if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi

