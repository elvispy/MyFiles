#include <iostream>

using namespace std;

int main( void )
{
	//let's see a subtle difference:
	int a = 1;
	const int b = 2;
	
	// both value and pointer are nonconstant
	int * Ptr1 = &a;
	//int *Ptr2 = &b; //error because b is const
	
	//constant value to nonconstant pointer
	const int *Ptr3 = &a; //NO error because of coercion?
	const int *Ptr4 = &b;
	
	//constant pointer to nonconstant value
	int* const Ptr5 = &a; 
	//int * const  Ptr6 = &b; //error because b is constant
	
	
	//Constant pointer and  constant value
	const int* const Ptr7 = &b;
	
	int c = 3;
	const int  d = 4;
	
	
	//*Ptr7 = 4; // error bc  b ( the memory address to which Ptr7 is pointing) is constant.
	//Ptr7 = &d; // error because the pointer is constant
	Ptr1 = &c; 
	return 0;
}
