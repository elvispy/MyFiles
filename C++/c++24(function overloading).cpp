#include<iostream>

using namespace std;

int square( int x )
{
cout << "square of integer " << x << " is ";
return x * x;
} 


// function square for double values
double square( double y )
{
cout << "square of double " << y << " is ";
return y * y;
} // end function square with double argument



int main(void ){
	//the purpose of this script is to show that you can actually define  two functions of the same name but different outputs
	//this can help you introduce different types of inputs, without affecting the result nor the intuition.
	cout  << square(7);
	cout << endl;
	cout << square(7.5);
	cout  << endl;
	
	return 0;
} //end main
