#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>


void SSRG_update(int* state){
	int bit = 1;//((*state&0x08)>>3) ^ (*state&0x01) ^ 1;
	*state = *state >> 1;
	*state = *state & 0x0F;
	*state = *state | (bit << 4);
	printf("%d,", bit);
}

int main(void){
	int state = 15;

	int i = 0;
	printf("[");
	for(i=0; i<100; i++){
		SSRG_update(&state);
	}
	printf("]");
}