#include<iostream>
#include<math.h>


using namespace std;
typedef unsigned long long int big;
//bool is_prime(big a);
bool is_prime(big a);


int main()
{
	//bf = new bool[455052511];
	big a = 1;
	while(a<= pow(10, 10))
	{
		bool c = is_prime(a);
		a++;
	}
	return 0;
}//end main

bool is_prime(big a)
{
	if (a == 1)
		return false;
	big aux = floor(sqrt(a));
	for(big i = 2; i <= aux; i++)
	{
		if (a%i == 0)
			return false;
	}//end for
	return true;
}//end function definition
/*
bool is_prime(int a)
{
	if (a == 1)
		return false;
	big aux = floor(sqrt(a));
	for(big i = 2; i <= aux; i++)
	{
		if (a%i == 0)
			return false;
	}//end for
	return true;
}//end function definition
*/
