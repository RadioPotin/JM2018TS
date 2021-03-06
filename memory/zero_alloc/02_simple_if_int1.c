#include <stdio.h>
#include <stdlib.h>
#include "zero_alloc.h"

void zero_alloc_if_else_int1(int x, int y) {
    size_t size;
    int* data;

#ifdef CATCH_BAD_PARAM
    if(x > 10 && x < y) {
        return;
    }
#endif

    if(x <= 10) {
        size = 5 * sizeof(int);
    } else {
        size = 0;
    }

    if(x >= y) {
        size += 3 * sizeof(int);
    } else {
        size = size * 5;
    }

    data = malloc(size); /* DANGER, if !a & !b */

    if(data) {
        *data = 34;
        printf("%i\n", *data);
        free(data);
    }
}

#ifndef NO_MAIN
int main() {
#ifdef NO_BUG
    zero_alloc_if_else_int1(10, 10);
    zero_alloc_if_else_int1(10, 11);
    zero_alloc_if_else_int1(11, 11);
#else
    zero_alloc_if_else_int1(10, 10); /* OK */
    zero_alloc_if_else_int1(11, 12); /* DANGER */
    zero_alloc_if_else_int1(11, 11); /* OK */
#endif

    return 1;
}
#endif
