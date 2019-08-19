#include <iostream>
using namespace std;

void  cubeByReference ( int  *); // prototype expecting an address

int main()
{
	int number = 12;
	
	cout << "The originla value of number is " << number;
	
	cubeByReference ( &number ); //pass number address to cubeByReference
	
	cout << "\nThe new value of number is " << number << endl;
}//end main

void cubeByReference( int *nPtr )
{

	*nPtr = *nPtr * *nPtr * *nPtr; //Cube the value

} //end function cubeByReference
