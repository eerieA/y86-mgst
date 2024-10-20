#include <stdio.h>

#define SIZE 13

int array[SIZE] = {4, 15, 6, 2, 21, 17, 11, 16, 8, 13, 14, 1, 9};
int temp[SIZE];

void print()
{
    int i;
    for (i = 0; i < SIZE; i++)
    {
        printf("%d\n", array[i]);
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
    int *mid;

    if (first < last)
    {
        mid = first + (last - first) / 2;
        mergesort(first, mid);
        mergesort(mid + 1, last);

        // Equivalent to merge(first, last, mid);
        // Orig merge() sig:
        //      void merge(int *first, int *last, int *mid)
        // mg_first = first;
        // mg_last = last;
        // mg_mid = mid;
        int *initial_first = first;
        int *second = mid + 1;
        int *dest = temp;

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

        while (first <= mid)
        {
            *dest++ = *first++;
        }

        while (second <= last)
        {
            *dest++ = *second++;
        }

        dest = temp;
        while (initial_first <= last)
        {
            *initial_first++ = *dest++;
        }
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