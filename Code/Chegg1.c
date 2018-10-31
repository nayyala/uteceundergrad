//
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <math.h>


    
int main(void){
    int a = 22 + 3*13/2 + 12 - 7%13;
    int b; = 12 + 2*10/1 + 2 - 6%10;
    int c = b + a;
    int d = b*a;
    int e = (c+d) - (c-d);

    printf("%d %d", d, e);
}