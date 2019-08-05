#include <iostream>

#include<stdio.h>

#include<math.h>

int main ( void ){
	double principal = 1000.0;
	double rate = .05;
	printf("%4s%21s\n", "Year", "Amount on deposit"); //%4s stands for four spaces.
	
	for (unsigned int year = 1; year<=10; year++){
		
		double amount = principal * pow(1.0 + rate, year);
		
		
		printf("%4d%15.2f\n", year, amount); //string formatting
	}
	return 0;
}
