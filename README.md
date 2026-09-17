# MIPS Algorithm Implementations

A collection of fundamental algorithms implemented in MIPS assembly language. The repository is intended as a practical study of algorithmic thinking at the instruction level, with emphasis on control flow, memory addressing, register usage, procedure calls, recursion, and stack management.

The implementations are written primarily as reusable procedures rather than complete standalone applications. They are therefore suitable for studying how familiar high-level algorithms translate into low-level MIPS operations.

## Implemented Algorithms

### Numerical Algorithms

| Algorithm | File | Approach | Time Complexity | Auxiliary Space |
|---|---|---|---:|---:|
| Factorial | `Factorial/fac.asm` | Iterative | O(n) | O(1) |
| Fibonacci | `Fibonacci/fib.asm` | Iterative | O(n) | O(1) |
| Greatest Common Divisor | `GCD/GCD.asm` | Euclidean algorithm | O(log min(a,b)) | O(1) |

### Sorting Algorithms

| Algorithm | File | Approach | Time Complexity | Auxiliary Space |
|---|---|---|---:|---:|
| Bubble Sort | `Sort/BubbleSort.asm` | Iterative, early termination | O(n²) worst case | O(1) |
| Insertion Sort | `Sort/InsertionSort.asm` | Iterative, in-place | O(n²) worst case | O(1) |
| Selection Sort | `Sort/SelectionSort.asm` | Iterative, in-place | O(n²) | O(1) |
| Merge Sort | `Sort/MergeSort_1.asm` | Recursive, auxiliary array | O(n log n) | O(n) |
| Merge Sort (experimental) | `Sort/MergeSort_2.asm` | Recursive, dynamically allocated temporary storage | O(n log n) target | O(n) target |

### Matrix Operations

| Operation | File | Description |
|---|---|---|
| Matrix Multiplication | `Matrix/Multiply.asm` | Multiplication of matrices stored in row-major order using explicit address arithmetic and pointer traversal |

For matrices with dimensions A = x × y and B = y × z, the implementation computes C = A × B with dimensions x × z. Matrix dimensions are passed through the stack, while matrix base addresses are passed through argument registers.

## Implementation Details

The repository focuses not only on the algorithms themselves, but also on their low-level realization in MIPS.

### Register and Memory Usage

The procedures make use of the conventional MIPS argument and return-value registers:

- `$a0-$a3` for procedure arguments
- `$v0` for return values
- `$t0-$t8` for temporary values and address calculations
- `$s0-$s5` where values must be preserved across procedure calls
- `$sp` for stack management
- `$ra` for procedure return addresses

Array-based algorithms operate directly on memory through word-aligned addresses. Pointer arithmetic is performed explicitly using word offsets, making the relationship between array indexing and memory addressing visible at the instruction level.

### Recursion and Stack Management

The merge sort implementations provide examples of recursive procedure design in MIPS. They demonstrate:

- Saving and restoring return addresses
- Preserving procedure state across recursive calls
- Passing subarray boundaries through registers
- Allocating temporary storage dynamically through the MIPS heap syscall
- Managing auxiliary data on the stack

`MergeSort_1.asm` contains a more developed recursive implementation with a separate `Merge` procedure. `MergeSort_2.asm` represents an experimental alternative design and is currently incomplete.

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

## Execution Environment

The source files are intended to be assembled and executed in a MIPS simulator such as:

- MARS (MIPS Assembler and Runtime Simulator)
- QtSpim

Since most files implement procedures rather than complete programs, a suitable test harness or calling code may be required to provide input values, memory addresses, and procedure calls.

A typical workflow is:

1. Open the required `.asm` file in a MIPS simulator.
2. Assemble the source.
3. Provide the required arguments and memory structures.
4. Execute the procedure.
5. Inspect the resulting registers or memory contents.

## Design Goals

The main objectives of this repository are:

- Translating classical algorithms into MIPS assembly.
- Developing a stronger understanding of MIPS instruction semantics.
- Practicing register allocation and calling conventions.
- Understanding array representation and pointer arithmetic.
- Studying iterative and recursive control flow at the assembly level.
- Exploring stack-based state preservation and dynamic memory allocation.
- Comparing algorithmic complexity with its concrete low-level implementation.

The implementations intentionally remain relatively direct and readable so that the correspondence between the algorithm and the generated instruction sequence can be examined without excessive abstraction.

## Current Status

The repository is an evolving collection of MIPS implementations. The current set covers basic numerical algorithms, elementary sorting methods, recursive merge sort, and matrix multiplication.

Future additions may include more advanced searching, graph, dynamic programming, and number-theoretic algorithms, together with additional comparisons of implementation strategies and memory behavior.

## License

This project is provided for educational and experimental purposes, with the primary goal of studying MIPS assembly language and algorithm implementation.
