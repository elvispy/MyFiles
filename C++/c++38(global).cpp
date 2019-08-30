#include <iostream>
using namespace std;

//defining the global cariable
int a = 10;

int main ( void )
{
	int a; //local variable
	
	cout << a << endl;
	
	cout << ::a << endl;
	
	::a = 14; //assign value to global variable
	
	cout << ::a << endl;
	
	return 0;
}
