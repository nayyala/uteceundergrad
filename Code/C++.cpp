#include <stdlib.h>
#include <iostream>
using namespace std;
#define PRINT_JOE

int main(void){
	#ifdef PRINT_JOE
cout << "Joe" << endl;
#endif 
#ifdef PRINT_BOB
cout << "Bob" << endl;
#endif

}