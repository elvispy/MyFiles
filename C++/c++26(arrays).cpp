using namespace std;
#include <iostream>
#include<iomanip>
#include<array>

int main() 
{
	
	array< int, 5 > c; //defining an array
	
	for (size_t i =0; i < c.size(); ++i)
	{
		c[ i ] = 0;
	}
	
	cout << "Element" << setw( 13 ) << "Value" << endl;
	
	// output each array element's value
	for ( int j = 0; j < c.size(); ++j )
	cout << setw( 7 ) << j << setw( 13 ) << c[ j ] << endl;
	
	
	array < char, 4> n = {'a', '9', '.'}; //another way of initializing arrays
	
	array <int , 3 > p = {}; //if yout put less elements than excepted, the remaining ones will be initialized with a zero
	
}
