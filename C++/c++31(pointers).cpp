#include <iostream>
#include <iomanip>
#include <array>
#include <string>
#include <algorithm> //contains sort  and binary search

using namespace std;

int main( void )
{
	int y  = 5;
	int *MyPtr = nullptr; //Initializes the pointer to be a null pointer.
    MyPtr = &y; //assigning adress of y to MyPtr
    
    
    cout << "The address of y is " << &y 
    	 << "\nThe value of MyPtr is " << MyPtr;
    cout << "\n\nThe value of  y is " << y
    	 << "\nThe value of *MyPtr is  " << *MyPtr << endl;
} // end main
