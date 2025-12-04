#ifndef STACK_H
#define STACK_H

#include <memory>
#include <stdexcept>

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
    std::unique_ptr<T[]> elements;
    int capacity;
    int top;   
    Stack(const Stack&) = delete;
    Stack& operator=(const Stack&) = delete;
    Stack(Stack&&) = delete;
    Stack& operator=(Stack&&) = delete;

public:
    Stack()
        : elements(std::make_unique<T[]>(INITIAL_CAPACITY)),
          capacity(INITIAL_CAPACITY),
          top(0) {}

    int size() const {
        return top;
    }

    bool is_empty() const {
        return top == 0;
    }

    bool is_full() const {
        return top >= MAX_CAPACITY;
    }

    void push(const T& value) {
        if (is_full()) {
            throw std::overflow_error("Stack has reached maximum capacity");
        }

        if (top == capacity) {
            int new_capacity = capacity * 2;
            if (new_capacity > MAX_CAPACITY) {
                new_capacity = MAX_CAPACITY;
            }
            reallocate(new_capacity);
        }

        elements[top++] = value;  
    }

    T pop() {
        if (is_empty()) {
            throw std::underflow_error("cannot pop from empty stack");
        }

        T value = elements[top - 1];
        --top;

        if (capacity > INITIAL_CAPACITY && top < capacity / 4) {
            int new_capacity = capacity / 2;
            if (new_capacity < INITIAL_CAPACITY) {
                new_capacity = INITIAL_CAPACITY;
            }
            if (new_capacity < top) {
                new_capacity = top;
            }
            reallocate(new_capacity);
        }

        return value;
    }

private:
    void reallocate(int new_capacity) {
        if (new_capacity < top) {
            return;
        }

        std::unique_ptr<T[]> new_elements = std::make_unique<T[]>(new_capacity);
        for (int i = 0; i < top; ++i) {
            new_elements[i] = elements[i];
        }
        elements = std::move(new_elements);
        capacity = new_capacity;
    }
};

#endif 
