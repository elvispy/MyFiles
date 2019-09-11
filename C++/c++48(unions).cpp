#include <iostream>

using namespace std;

/*Unions allow one portion of memory to be accessed as different data types.
 Its declaration and use is similar to the one of structures,
  but its functionality is totally different*/
union mix_t {
  int o;
  struct {
    short hi;
    short lo;
    } s;
  char c[4];
} mix;

int main()
{
	mix.o = 4;
	cout << mix.o << endl;
	(mix.c)[0] = 'a'; //you cannot put "abcd" since you need the termination character /0
	cout << mix.o << endl;
	cout << mix.c << endl;
	
	/*
	In the union structure, we have a dependency of the values. So if we change the value in one type, 
	the other will be affected.
	*/
	return 0;
}
