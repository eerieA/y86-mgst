#include "utils.h"
#include "ms.h"
#include <string.h>  // For memcpy
#include <stdlib.h>  // For malloc

// Helper function to allocate memory for the array and copy the original array into it
int *initialize_array(int *original_array, int size) {
    // Dynamically allocate memory for the array to be sorted
    int *array = (int *)malloc(size * sizeof(int));
    if (!array) {
        printf("Memory allocation failed.\n");
        return NULL;
    }

    // Copy original array to the allocated array
    memcpy(array, original_array, size * sizeof(int));

    return array;
}

int main() {
    // Array to be sorted, allocated in stack mem
    // int original_array[] = { 4, 15, 6, 2, 21, 17, 11, 16, 8, 13, 14, 1, 9 };
    int original_array[] = { 2, 1, 2, 1 };
    int size = sizeof(original_array) / sizeof(original_array[0]);

    // Allocate and initialize mem for a copy of the above array
    int *array = initialize_array(original_array, size);
    if (!array) { return 1; }

    // Initialize temp array for both versions
    init_temp(size);

    printf("\nRecursive mergesort:\n");
    ms_rc(array, array + size - 1);
    print_array(array, size);

    // Copy original_array into array again
    memcpy(array, original_array, size * sizeof(int));

    printf("\nIterative mergesort:\n");
    ms_it(array, array + size - 1);
    print_array(array, size);
    
    // Free them
    free_temp();
    free(array);

    return 0;
}