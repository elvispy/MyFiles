#include <array>
#include <iostream>

using namespace std;

const size_t rows = 2;
const size_t columns = 3;
void printArray ( const array < array < int, columns >, rows > & );

int main()
{
	array < array < int, columns >, rows > array1 = { 1, 2, 3, 4, 5, 6};
	array < array < int, columns >, rows > array2 { 1, 2, 3, 4, 5}; // last value will be initialized as zero
	
	cout << "Values in array1 by row are: " << endl;
	printArray( array1);
	
	cout << "\nValues in array2 by row are: " << endl;
	printArray( array2 );
} //end main

void printArray ( const array < array < int, columns >, rows > &a)
{
	for ( auto const &row : a) //reference to a row
	{ //the auto keyword tells the compiler to infer a variable's data type based on the variable's initializer value.
		
		for ( auto const &element : row)
		cout << element << ' '; //we can also enter using array[i][j] but we need to practice pointing
		
		cout << endl;
	} //end outer for
} // end function print array
