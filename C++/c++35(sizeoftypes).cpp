// Fig. 8.14: fig08_14.cpp
// sizeof operator used to determine standard data type sizes.
#include <iostream>
using namespace std;
int main()
{
char c; // variable of type char
short s; // variable of type short
int i; // variable of type int
long l; // variable of type long
long ll; // variable of type long long
float f; // variable of type float
double d; // variable of type double
long double ld; // variable of type long double
int array[ 20 ]; // built-in array of int
int *ptr = array; // variable of type int *

cout << "sizeof c = " << sizeof(c)
<< "\tsizeof(char) = " << sizeof(char)
<< "\nsizeof s = " << sizeof(s)
<< "\tsizeof(short) = " <<  sizeof(short)
<< "\nsizeof i = " << sizeof(i)
<< "\tsizeof(int) = " << sizeof(int)
<< "\nsizeof l = " << sizeof(l)
<< "\tsizeof(long) = " << sizeof(long)
<< "\nsizeof ll = " << sizeof(ll)
<< "\tsizeof(long long) = " << sizeof( long long)
<< "\nsizeof f = " << sizeof(f)
<< "\tsizeof(float) = " << sizeof( float)
<< "\nsizeof d = " << sizeof( d)
<< "\tsizeof(double) = " << sizeof( double )
<< "\nsizeof ld = " << sizeof( ld )
<< "\tsizeof(long double) = " << sizeof( long double )
<< "\nsizeof array = " << sizeof(array)
<< "\nsizeof ptr = " << sizeof( ptr ) << endl;
} // end main
