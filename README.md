# ATAM Tests - Technion

This repository contains homework assignments and test suites for the Computer Organization and Programming course (ארגון ותכנות המחשב) at the Technion - Israel Institute of Technology.

## Testing Your Solutions

### Run All Tests for an Exercise

From within a homework directory (e.g., `HW1/`):

```bash
chmod +x ./run_all_tests.sh
./run_all_tests.sh
```

This will:
1. Display available exercises
2. Let you select which exercise to test
3. Run all tests for the selected exercise
4. Display a summary of passed/failed tests

### Run a Single Test

```bash
chmod +x ./run_test.sh
./run_test.sh <asm_file> <test_file>
```

Example:
```bash
./run_test.sh ex4.asm tests/ex4/ex4_test1
```

## Course Information

**Institution:** Technion - Israel Institute of Technology  
**Course Number:** 02340118  
**Course Name:** ארגון ותכנות המחשב (Computer Organization and Programming)  
**Semester:** חורף 2025-2026 (Winter 2025-2026)

---

For specific instructions on each homework assignment, see the `README.md` file in each exercise directory.

