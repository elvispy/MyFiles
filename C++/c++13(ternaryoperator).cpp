#include<stdio.h>

int main(void){
	int grade;
	int lol;
	
	scanf("%d", &grade);
	
	grade >= 60 ? puts("Passed") : lol = 42; //will do one or another
	
	float average = ( float ) grade / 17; //will convert to float, since integer  division returns an integer
	
	printf("Deixa eu ver %.2f\n", average); //.2f means two digits of precision default precision is six if no number is specified
	
	return 0;
}
