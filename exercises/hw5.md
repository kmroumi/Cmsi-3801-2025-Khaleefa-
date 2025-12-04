1.  a. a is an array of n pointers to double.
b. b is a pointer to an array of n doubles.
c. c is an array of n pointers to functions returning double.
d. d is a function returning a pointer to an array of n doubles.

2. Arrays decay to pointers when passed to functions or used in expressions,

3. a. Allocated memory that is never freed
b. Pointer referencing freed or invalid memory.
c. Freeing the same memory twice.
d. Writing past allocated memory boundaries.
e. Exceeding available call stack memory.
f. Uninitialized pointer with unknown memory address.

4. Move constructors and move assignment operators only apply to r-values because r-values represent temporary objects that are about to be destroyed

5. c++ has move semantics because without moves all transfers of large objects would require slow heap copies.

6. The Rule of Five states that if a class defines any of the following, it should usually define all five:
Destructor
Copy constructor
Copy assignment operator
Move constructor
Move assignment operator

7. Each value has exactly one owner at a time.
When the owner goes out of scope, the value is automatically dropped.
Ownership moves by default when assigning or passing values.

8. You may have either one mutable reference or many immutable references at a time.
References must always be valid.
Mutable and immutable references cannot coexist simultaneously.