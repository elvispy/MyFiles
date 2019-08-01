#include<stdio.h>


int main(){
	/*
	This is a multiline comment
	*/
    int integer1;
    printf("Alo polisia \n"); //stdio enables you to used printf instead of cout
    scanf("%d", &integer1);
    integer1 = integer1 * integer1;
    printf("The square is %d \n", integer1); //this does not have to be preceeded by amphersand
    
    
    //you can format the scanning
	int lol1, lol2;
	scanf("%d %d", &lol1, &lol2); //note that if you dont put a \n at the end  of the last printf, errors may occur
	
	printf("equide %d", lol1+lol2);
	return 0;
}
