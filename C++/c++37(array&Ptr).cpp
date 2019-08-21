#include <iostream>

using namespace std;

int main( void )
{
	int b[5];
	int *bPtr;
	
	bPtr = b; // equivalent to &b[0];
	
	cout << *(bPtr + 3) << endl; // same as b[3]
	
	cout << bPtr + 1 << endl; // same as &b[3] and *(b + 1)
	
	//we can initialize strings as char arrays
	
	char color[] = "Blue"; //equivalent to char color[] = {'B', 'l' ... , '\0'}
	
	const char *colorPtr = "Blue";
}
