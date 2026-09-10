# MIPS Algorithm Implementations

This repository contains a small collection of classic algorithms implemented in MIPS assembly language. The goal is to provide clear, educational examples of common computational problems and their low-level implementations.

## Repository structure

- `Factorial/` — factorial calculation
- `Fibonacci/` — Fibonacci number generation
- `GCD/` — greatest common divisor
- `Matrix/` — matrix multiplication
- `Sort/` — sorting algorithms (`BubbleSort`, `InsertionSort`, `SelectionSort`)

## Included algorithms

### Factorial
- File: `Factorial/fac.asm`
- Computes the factorial of a number using a loop.

### Fibonacci
- File: `Fibonacci/fib.asm`
- Generates a Fibonacci value based on the input parameter.

### GCD
- File: `GCD/GCD.asm`
- Computes the greatest common divisor of two integers using the Euclidean algorithm.

### Matrix multiplication
- File: `Matrix/Multiply.asm`
- Multiplies matrices using row-major memory layout and pointer-based indexing.

### Sorting algorithms
- `Sort/BubbleSort.asm` — bubble sort
- `Sort/InsertionSort.asm` — insertion sort
- `Sort/SelectionSort.asm` — selection sort

## How to run

These assembly programs are intended to be opened and executed in a MIPS simulator such as:

- MARS
- QtSpim

Typical workflow:

1. Open the `.asm` file in your MIPS simulator.
2. Assemble the program.
3. Run it with the required input values.
4. Observe the result in registers or memory, depending on the implementation.

## Notes

- These files are written as teaching examples and are intentionally simple and readable.
- Register conventions follow standard MIPS calling conventions where applicable.
- Some algorithms assume input values are passed via `$a0`, `$a1`, or stack arguments depending on the specific program.

## License

This project is provided as educational material for learning MIPS assembly and algorithm implementation.