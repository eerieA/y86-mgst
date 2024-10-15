#include <stdio.h>

#define SIZE 13

int array[SIZE] = {4, 15, 6, 2, 21, 17, 11, 16, 8, 13, 14, 1, 9};
int temp[SIZE];

/*
 * Helper  that is not in file mergesort-student.s (since we can view
 * the contents of the array in the simulator, we don't need to print
 * it).
 */
void print()
{
    int i;
    for (i = 0; i < SIZE; i++)
    {
        printf("%d\n", array[i]);
    }
}

/**
 * Merge  the portion of the array between the  elements that first and
 * mid point to, with the portion between the elements that mid + 1 and
 * last point to.
 */
void merge(int *first, int *mid, int *last)
{
    int *initial_first = first; /* Save ptr to first position to merge */
    int *second = mid + 1;      /* Current element in second half. */
    int *dest = temp;           /* Where the next element goes. */

    /* Merge the two halves until one is exhausted */
    while (first <= mid && second <= last)
    {
        if (*first <= *second)
        {
            *dest++ = *first++;
        }
        else
        {
            *dest++ = *second++;
        }
    }

    /* Copy remaining elements from the first half, if any */
    while (first <= mid)
    {
        *dest++ = *first++;
    }

    /* Copy remaining elements from the second half, if any */
    while (second <= last)
    {
        *dest++ = *second++;
    }

    /* Copy merged elements back into the original array */
    dest = temp;
    while (initial_first <= last)
    {
        *initial_first++ = *dest++;
    }
}

/**
 * The mergesort algorithm. Please note that we can not use the expr-
 * ession
 *     mid = (first + last)/2
 * because adding 2 pointers in C is not allowed (however subtracting
 * pointers that point to  elements in  the same array will give  the
 * number of positions between the elements in the array).
 */
void mergesort(int *first, int *last)
{
    int total_elements = (last - first + 1);
    int size = 1;

    while (size < total_elements) {
        int *left = first;

        while (left <= last) {
            int *mid = left + size - 1;
            int *right = left + 2 * size - 1;

            if (right > last) {
                right = last;
            }

            merge(left, mid, right);
            left += 2 * size;
        }

        size *= 2;
    }
}

/*
 * Main function: call mergesort and print the sorted array.
 */
int main(int argc, char *argv[])
{
    mergesort(array, array + (SIZE - 1));
    print();
    return 0;
}
