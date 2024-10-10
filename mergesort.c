#include <stdio.h>

#define SIZE 13

int array[SIZE] = { 4, 15, 6, 2, 21, 17, 11, 16, 8, 13, 14, 1, 9 };
int temp[SIZE];

/*
 * Copy helper: copy all elements from first to last into  dest. This
 * function assumes that first and last both point to elements of the
 * same array (and will not work correctly if they don't). It returns
 * the final value of dest (so we can continue copying from there).
 */
int *copy(int *first, int *last, int *dest)
{
    while (first <= last)
    {
	*dest++ = *first++;
    }
    return dest;
}

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
        printf ("%d\n", array[i]);
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

    /*
    1. Assume that both sub arrays are sorted, use *first <= *second to determine which is the "smaller" sub array.
    2. So copy the "smaller" sub array to the global temp array, while incrementing first and dest or second
        and dest pointers.
    3. Then copy whatever element that is left in the first or second sub array into the global temp,
        because they might be of slightly different lengths.
    4. Finally copy the temp array into the original array.  */

    /*
     * Beginning of the code to fill in in mergesort-student.s.
     */
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
    /*
     * End of the code to fill in in mergesort-student.s.
     */

    dest = copy(first, mid, dest);
    dest = copy(second, last, dest);
    copy(temp, dest - 1, initial_first);
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
	mid = first + (last - first)/2;
        mergesort(first, mid);
        mergesort(mid + 1, last);
        merge(first, mid, last);
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

