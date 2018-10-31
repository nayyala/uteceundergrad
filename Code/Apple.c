#include <stdio.h>
#include <stdint.h>

#define foo(a) int a=1;

int main() {
    int something = 1;
    if (something)
        int bar = 1;
    else
        printf("not something\n");
}