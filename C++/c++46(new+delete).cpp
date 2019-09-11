#include <iostream>
#include <new>
using namespace std;

int main()
{
	int * foo;
	foo = new ( nothrow ) int[5];
	//This is another way of defining pointers. You define an "array" 
	//of values. you can access them in two equivalent ways
	if ( foo != nullptr)
	{
		cout  << foo[1] << endl;
		cout << *(foo + 1) << endl;
	}
	/*
	In most cases, memory allocated dynamically is only needed during 
	specific periods of time within a program; once it is no longer needed,
	it can be freed so that the memory becomes available again for other
    requests of dynamic memory. This is the purpose of operator delete
	*/
	
	//another example
	
	int i, n;
	int *p = nullptr;
	cout << "How many numbers would you like to type? ";
	cin >> i;
	p = new (nothrow) int[i];
	if ( p == nullptr)
		cout << "Error: memory could not be allocated";
	else
	{
		for ( n = 0; n< i; n++)
		{
			cout << "Enter number: ";
			cin >> p[n];
		}
		cout << "You have entered: ";
		for (n = 0; n<i; n++)
			cout << p[n] << ", ";
			delete[] p; //deletes all
	}
	return 0;
		
}
