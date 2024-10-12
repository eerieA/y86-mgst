#ifndef MERGESORT_H
#define MERGESORT_H

/* Function declarations */
void init_temp(int arr_size);
void free_temp();
void ms_rc(int *first, int *last);
void ms_it(int *start, int *end);

#endif // MERGESORT_H