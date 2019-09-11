#include <iostream>
using namespace std;

int addition (int a, int b)
{
	return a+b;
}

int subtraction(int a, int b)
{
	return a-b;
}

int operation(int x, int y, int (functocall)(int, int))
{
	int g;
	g = (*functocall)(x, y);
	return g;
}


int main()
{
	int m, n;
	/*
	If you struggle to understand the next line of code, just think about it.
	When you point to some variable, you need to specify the data type. 
	Consider the existence of function overloading. This means that even though 
	the output may be equal in type, at least one of the inputs has to differ. 
	This implies that it is mandatory (and makes sense) to specify all inputs
	data types. 
	*/
	int (*minus)(int, int) = subtraction; //pointint to a function
	
	m = operation(7, 5, addition);
	n = operation(20, m, minus); 
	
	
	/*Important  observation: Note that in the definition of operation, the 
	third argument is a function. So you may think that in line 35 and 36, you
	must pass functions as arguments. However, if you pass one pointer, the
	compiler seems to understand that you are referring to a funcion
	
	and the other way around is true, also. If in the definition of
	operation, we were to change funtocall for *functocall, then 
	in the line 35, the compiler will understand that when we pass the function, 
	we really mean the pointer of the function.
	*/

	cout << n;
	return 0;
}
