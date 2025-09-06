1. The process of filtering a list involves choosing elements that fulfill particular conditions while removing all other elements. The process helps users to reduce their data by selecting information that matches specific requirements.

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

def is_even(n):
    return n % 2 == 0

even_numbers = list(filter(is_even, numbers))

print(even_numbers)  # Output: [2, 4, 6, 8, 10]

2. numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

cubed_numbers = numbers .^ 3

println(cubed_numbers)

3. The pragmatics of programming languages refers to the practical aspects of how programming languages are used in real-world situations

4. The fragment {+/x[&x!2]^2} is a K function that computes the sum of the squares of the odd numbers in x.
f:{+/x[&x!2]^2}
f 1 2 3 4 5
output: 35

5. The term object-orientation originally meant modeling real-world entities as objects that combined data and behavior, interacting through message passing. Today, it generally refers to a programming paradigm based on classes and objects.

6. ᐊ — U+140A CANADIAN SYLLABICS A. 
ᐃ — U+1403 CANADIAN SYLLABICS I. 
ᓐ — U+14D0 CANADIAN SYLLABICS N. 
ᖓ — U+1593 CANADIAN SYLLABICS NGA. 
ᐃ — U+1403 CANADIAN SYLLABICS I 
it means hello

7. control flow is the order a single computation follows what runs next in one thread/task.
   concurrency is composing multiple computations that overlap in time and coordinate

8. machine language is raw binary/hex opcodes and operands that the CPU executes directly
   assembly language is human-readable mnemonics that map to machine instructions

LDA #$01      ; load A with 1 (immediate)
ADC #$02      ; add 2 to A with carry
STA $0200     ; store A into memory address $0200

A9 01   ; LDA #$01
69 02   ; ADC #$02
8D 00 02; STA $0200

9.  defmodule StepFunc do
  def f(n) when is_integer(n) and rem(n, 2) == 0, do: 3 * n + 1
  def f(n) when is_integer(n), do: 4 * n - 3
end


10. Verse is a programming language from Epic Games, developed by a team led by Simon Peyton Jones, and first released publicly with Unreal Editor for Fortnite in March 2023 to script large-scale, creator-made Fortnite experiences and future Unreal “metaverse” worlds. It’s called “functional-logic” because it explicitly combines functional programming with logic programming