#include<iostream>
#include<cmath>
using namespace std;
long long int converser(long long int i);
int main()
{
	long long int c = 1020304050607080900;
	int i = 0;
	while(true)
	{
		long long int a = converser(i) + c;
		long long int b = (long long int) sqrt(a);
		if(b*b == a)
		{
			cout << a;
			break;
		}//end if
		i++;
	}//end while
	
	return 0;
}//end main

long long int converser(long long int i)
{
	long long int res = 0;
	for(int j = 0; j< floor(log(i))+1;j++)
	{
		long long int aux = (long long int) i/pow(10,j);
		aux = aux%10;
		res += aux * pow(10, 3+2*j);
	}//end for
	return res;
}//end function definition

