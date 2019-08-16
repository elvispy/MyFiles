#include<iostream>

#include "maximumtemplate.h"


using namespace std;

int main( void )
{
	int int1, int2, int3;
	
	cout << "Input three integer values: ";
	cin >> int1 >> int2 >> int3;
	
	cout << "The maximum integer values is: "
		<< maximum(int1, int2, int3);
		
	double dbl1, dbl2, dbl3;
	
	cout << "\n\nInput three double values: ";
	cin >> dbl1 >> dbl2 >> dbl3;
	
	cout << "The maximum double value is: " 
		<< maximum(dbl1, dbl2, dbl3);
	
	
	char char1, char2, char3;
	
	cout << "\n\nInput three characters: ";
	cin >> char1 >> char2 >> char3;
	
	cout << "The maximum character value is: "
		<< maximum(char1, char2, char3) << endl;
		
}//end main
