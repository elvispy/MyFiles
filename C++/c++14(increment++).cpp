#include<stdio.h>

int main(void){
	unsigned int c; //this can be only nonnegative, it will have twice the scope (MAX_INT)
	
	c = 5;
	printf("%d\n", c); //print 5
	printf("%d\n", c++); //print 5 then postincrement
	printf("%d\n\n", c); // print 6
	
	
	//now preincrement
	
	c = 5;
	printf( "%d\n", c); //print 5
	printf( "%d \n", ++c);
	printf( "%d\n", c); //print 6
	
}
