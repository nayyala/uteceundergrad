#include "stdint.h"
#include "stdio.h"
#include <stdlib.h>
#include <math.h>

//sum of all digits in 2^1000

typedef struct uint128_t{
	long long x[2];
}uint128_t;

int main(void){
	uint128_t w = 2^1000;
	int y = 0;
	int z = 0;

	while (x != 0){
	 	y = x%10;
	 	x = x/10;
	 	z += y;
	 	printf("%d\n", y);
	}

	printf("%d\n", z);
}
