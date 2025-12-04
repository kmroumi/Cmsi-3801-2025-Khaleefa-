#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 16

struct _Stack {
    char **elements;
    int size;
    int capacity;
};


static response_code grow_if_needed(struct _Stack *s) {
    if (s->size < s->capacity) {
        return success;
    }

    if (s->capacity >= MAX_CAPACITY) {
        return stack_full;
    }

    int new_capacity = s->capacity * 2;
    if (new_capacity > MAX_CAPACITY) {
        new_capacity = MAX_CAPACITY;
    }

    char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
    if (new_elements == NULL) {
        return out_of_memory;
    }

    s->elements = new_elements;
    s->capacity = new_capacity;
    return success;
}

static void shrink_if_needed(struct _Stack *s) {
    if (s->capacity <= INITIAL_CAPACITY) return;
    if (s->size >= s->capacity / 4) return;

    int new_capacity = s->capacity / 2;
    if (new_capacity < INITIAL_CAPACITY) {
        new_capacity = INITIAL_CAPACITY;
    }
    if (new_capacity < s->size) {
        new_capacity = s->size;
    }

    char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
    if (new_elements == NULL) return;

    s->elements = new_elements;
    s->capacity = new_capacity;
}


stack_response create() {
    stack_response res;

    struct _Stack *s = malloc(sizeof(struct _Stack));
    if (s == NULL) {
        res.code = out_of_memory;
        res.stack = NULL;
        return res;
    }

    s->elements = malloc(INITIAL_CAPACITY * sizeof(char *));
    if (s->elements == NULL) {
        free(s);
        res.code = out_of_memory;
        res.stack = NULL;
        return res;
    }

    s->size = 0;
    s->capacity = INITIAL_CAPACITY;

    res.code = success;
    res.stack = s;
    return res;
}

int size(const stack s) {
    if (s == NULL) return 0;
    return s->size;
}

bool is_empty(const stack s) {
    return s == NULL || s->size == 0;
}

bool is_full(const stack s) {
    if (s == NULL) return false;
    return s->size >= MAX_CAPACITY;
}

response_code push(stack s, char *item) {
    if (s == NULL || item == NULL) {
        return stack_element_too_large;
    }

    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (s->size >= MAX_CAPACITY) {
        return stack_full;
    }

    response_code rc = grow_if_needed(s);
    if (rc != success) {
        return rc;
    }

    char *copy = malloc(strlen(item) + 1);
    if (copy == NULL) {
        return out_of_memory;
    }

    strcpy(copy, item);
    s->elements[s->size++] = copy;

    return success;
}

string_response pop(stack s) {
    string_response res;
    res.string = NULL;

    if (s == NULL || s->size == 0) {
        res.code = stack_empty;
        return res;
    }

    char *stored = s->elements[s->size - 1];

    char *copy = malloc(strlen(stored) + 1);
    if (copy == NULL) {
        res.code = out_of_memory;
        res.string = NULL;
        return res;
    }

    strcpy(copy, stored);
    free(stored);

    s->size--;
    shrink_if_needed(s);

    res.code = success;
    res.string = copy;
    return res;
}

void destroy(stack *ps) {
    if (ps == NULL || *ps == NULL) return;

    struct _Stack *s = *ps;

    for (int i = 0; i < s->size; i++) {
        free(s->elements[i]);
    }

    free(s->elements);
    free(s);

    *ps = NULL;
}
