#include <iostream>
using namespace std;

int lol(const int b) //this will give an error since we declared b as read only
{
	//b +=1; //comment to continue
	return b;
}

int f2(int a)
{
	//when you pass by value, the actual value is not modified
	a *=2;
	return a;
}

int f2(int *a)
{
	*a *= 2;
	return *a;
}
int main (void )
{
	int c[5] = {1, 2, 3, 3, 2}; //built in array (size can also be ommited)
	cout << c[2] << endl;
	
	cout << sizeof(c)/sizeof(*c) << endl; //size of the array
	
	cout << lol(c[4]) << endl;
	
	int *Ptr = &c[0];
	
	cout << Ptr << endl;
	
	//now let's see the difference between pass by value and pass by reference
	cout << "Pass by value returned: " << f2(c[1]) << endl;
	cout << "Value after pass-by-value function: " << c[1] << endl;
	cout << "Pass by reference function returned: " << f2(&c[1]) << endl; //we give the address
	cout << "Value after pass-by-reference: "c[1] << endl;
	
	return 0;
}
