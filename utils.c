#include "utils.h"

/* Copy helper function */
int *copy(int *first, int *last, int *dest) {
    while (first <= last) {
        *dest++ = *first++;
    }
    return dest;
}

/* Print helper function */
void print_array(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}