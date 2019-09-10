#include <iostream>


#include <string>


//There are some ways of passing an array as an input
void procedure( int arr[10]);

void procedure2 (int * ptr);

using namespace std;
int main (void ){
	
	string cars[5] = {"Val1", "val2", "val3", "val4", "val5"}; //initializing
	
	//cars = {'Val1', 'val2', 'val3', 'val4', 'val6'}; //this will give an error
	//you cannot  excede the number of elements of an array once it's defined
	cars[0] = "new_value";
	
	int numb[4] = {1, 2, 3, 4}; //integer array
    
    // we can omit the size of the array, but then the size will be the size of the initialized  array
    int arr[] = {42, 0, 3};
    
    //if you specify the size, the array will save extra space
    int arra[10] = {1, 2, 3, 4}; //it can store 10 values
    arra[9] = 42;//you can initialize any element
    arra[11] = 0; // beware! this wont give you error but if you try to print it will do
    //cout << arra[11] << "\n";
    cout << arra[9] << "\n";
    
    
    int *Myptr = &numb[0];
    procedure2(Myptr);
    procedure(numb);
    
    
    return 0;
    
}

void procedure(int arr[10])
{
	cout << arr[1] << "\n";
}

void procedure2 ( int * ptr)
{
	cout << *(ptr + 1) << "\n";
}
