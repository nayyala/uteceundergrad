#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define _CRT_NO_WARNINGS

enum coin{Tails, Heads};

int flip() {
	int i = rand() % 2;

	switch(i){
	    case Tails:
	        return 0;
	        break;
	    case Heads:
	        return 1;
	        break;
	}
	
}

int main()
{
	// initialize random number generator
	srand(time(NULL)); 
	// initialize variables
		int side;
		int toss;
		int heads = 0;
		int tails = 0;
		// for loop on flipping
		for (toss = 1; toss <= 100; toss++) {
		    side = flip();
			//print the number it flip on output
			switch (side){
			    case Tails:
			        printf("Tails\n");
	                tails++;
	                break;
	            case Heads:
	                printf("Heads\n");
	                heads++;
	                break;
			}
		}
		//the number of times it would flip
		printf("heads was flipped %d times\n", heads);
		printf("tails was flipped %d times\n", tails);
		getchar();
		return 0;

	

	
}