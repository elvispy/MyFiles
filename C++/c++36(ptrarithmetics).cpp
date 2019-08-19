#include <iostream>

using namespace std;

int main( void )
{
	//You can point to elements of an array. The difference between elements of an array is the size of the type  of the elements of the array.
	int c[4] = {3, 2, 1, 5};
	
	int * Ptr = &c[0];
	
	cout << *Ptr << endl;
	++Ptr; //will point to the next element of the array
	cout << *Ptr << endl;
	
	Ptr += 100; //this will point to an empty element. Since the values of the array steps are sizeof(c[0]). 
	
	cout << *Ptr << endl;
	
	int * Ptr2 =&c[1];
	int * Ptr3 = &c[4];
	int  v = Ptr3 - Ptr2;
	
	cout << v << endl;
	
	return 0;
}
