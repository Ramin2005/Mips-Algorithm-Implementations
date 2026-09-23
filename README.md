# MIPS Algorithm Implementations

A collection of fundamental algorithms implemented in **MIPS assembly language**, focused on understanding how algorithms translate into low-level instructions, registers, memory accesses, procedure calls, and control flow.

The implementations are written as assembly procedures and are intended primarily for study and experimentation with MIPS.

## Implemented Algorithms

### Numerical Algorithms

| Algorithm | File | Approach | Time | Auxiliary Space |
|---|---|---|---|---|
| Factorial | `Factorial/fac.asm` | Iterative | O(n) | O(1) |
| Fibonacci | `Fibonacci/fib.asm` | Iterative | O(n) | O(1) |
| GCD | `GCD/GCD.asm` | Euclidean algorithm | O(log min(a,b)) | O(1) |

### Sorting Algorithms

| Algorithm | File | Approach | Time | Auxiliary Space |
|---|---|---|---|---|
| Bubble Sort | `Sort/BubbleSort.asm` | In-place, early termination | O(n²) worst case | O(1) |
| Insertion Sort | `Sort/InsertionSort.asm` | In-place | O(n²) worst case | O(1) |
| Selection Sort | `Sort/SelectionSort.asm` | In-place | O(n²) | O(1) |
| Merge Sort | `Sort/MergeSort_1.asm` | Recursive | O(n log n) | O(n) |
| Merge Sort 2 | `Sort/MergeSort_2.asm` | Recursive/experimental | O(n log n) target | O(n) target |

### Matrix Operations

- **Matrix Multiplication** — `Matrix/Multiply.asm`
- Matrices are stored in row-major order.
- Matrix base addresses are passed through argument registers.
- Matrix dimensions are read from the stack.
- The implementation explicitly performs address arithmetic and pointer traversal.

## MIPS Concepts Demonstrated

This repository is intended to make the connection between algorithms and MIPS architecture visible.

- Register-based procedure arguments and return values
- Temporary and saved registers
- Branches and loops
- Pointer arithmetic
- Word-aligned memory access
- Array traversal
- Stack usage
- Recursive procedure calls
- Saving and restoring `$s` registers
- Return-address management through `$ra`
- Dynamic temporary memory allocation in the merge-sort implementation
- Matrix addressing and row/column traversal

### Register Usage

The implementations use conventional MIPS registers, including:

- `$a0-$a3` — procedure arguments
- `$v0` — return value
- `$t0-$t8` — temporary values and address calculations
- `$s0-$s5` — preserved state where required
- `$sp` — stack pointer
- `$ra` — return address

Individual source files contain additional comments describing their specific register assignments.

## Repository Structure

```text
Mips-Algorithm-Implementations/
├── Factorial/
│   └── fac.asm
├── Fibonacci/
│   └── fib.asm
├── GCD/
│   └── GCD.asm
├── Matrix/
│   └── Multiply.asm
└── Sort/
    ├── BubbleSort.asm
    ├── InsertionSort.asm
    ├── SelectionSort.asm
    ├── MergeSort_1.asm
    └── MergeSort_2.asm
```

## Running the Code

The source is written for the MIPS architecture and can be studied or executed with a MIPS simulator such as **MARS** or **QtSpim**.

Most files define procedures rather than complete standalone applications. A caller/test harness may therefore be required to:

1. Load the required input into the expected registers or memory.
2. Prepare any required stack parameters.
3. Call the procedure.
4. Inspect the return value in `$v0` or the modified memory.

The exact calling convention and input requirements are documented in the comments of each assembly file.

## Educational Focus

The main purpose of the repository is not only to implement algorithms, but to study their **low-level realization**.

Particular attention is given to:

- How high-level loops become branches and jumps.
- How arrays become address calculations and load/store operations.
- How procedure state is preserved across calls.
- How recursive algorithms use the stack.
- How algorithmic complexity relates to actual memory traversal and instruction-level work.

## Current Status

The repository currently contains numerical algorithms, elementary sorting algorithms, recursive merge-sort implementations, and matrix multiplication.

Some implementations are experimental; in particular, `MergeSort_2.asm` is retained as an alternative/incomplete implementation rather than being presented as a finalized version.

## License

This repository is intended for educational and experimental use.
