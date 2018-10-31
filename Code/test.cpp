#include <stdlib.h>
#include <iostream>
#include <fstream>


int main(void){
	char* s1 = "it";
	char* s2 = "make";
	char* s3 = "easy";

	if (s1>s2){
		if(s1>s3){
			printf("%s%s%s\n", s1,s3,s2);
		}
		else{
			printf("%s%s%s\n", s3,s1,s2);
		}
	}
	else{
		if (s2>s3){
			printf("%s%s%s\n", s2,s3,s1);
		}
		else{
			printf("%s%s%s\n", s3, s2, s1);
		}
	}

	if ("make" > "easy"){
		printf("Yes");
	}
	else{
		printf("No");
	}
	

}




