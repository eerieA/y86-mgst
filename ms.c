#include "utils.h"
#include "ms.h"
#include <string.h>  // For memcpy
#include <stdlib.h>  // For malloc

static int *temp = NULL;
static int size = 0;

/* Helper to initialize temp array */
void init_temp(int arr_size) {
    size = arr_size;
    temp = (int *)malloc(size * sizeof(int));
}

/* Clean up temp array */
void free_temp() {
    free(temp);
}

/* Merge function used by both versions */
void merge(int *first, int *mid, int *last) {
    int *initial_first = first;
    int *second = mid + 1;
    int *dest = temp;

    while (first <= mid && second <= last) {
        if (*first <= *second) {
            *dest++ = *first++;
        } else {
            *dest++ = *second++;
        }
    }

    dest = copy(first, mid, dest);
    dest = copy(second, last, dest);
    copy(temp, dest - 1, initial_first);
}

/* Recursive merge sort, identical with the given one */
void ms_rc(int *first, int *last) {
    int *mid;

    if (first < last) {
        mid = first + (last - first) / 2;
        ms_rc(first, mid);
        ms_rc(mid + 1, last);
        merge(first, mid, last);
    }
}

/* Iterative merge sort, new for y86 optz */
void ms_it(int *start, int *end) {
    int total_elements = (end - start + 1);
    int size = 1;

    while (size < total_elements) {
        int *left = start;

        while (left <= end) {
            int *mid = left + size - 1;
            int *right = left + 2 * size - 1;

            if (right > end) {
                right = end;
            }

            merge(left, mid, right);
            left += 2 * size;
        }

        size *= 2;
    }
}
