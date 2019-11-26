#include<iostream>


using namespace std;
typedef unsigned long long int LINT;
LINT P(LINT k)
{
	LINT n = 4*k*k+1;
	LINT d = 1;
	while(n>1)
	{
		d+=4;
		while(n%d == 0)
			n = (LINT) n/d;
		if(d*d > n && n>1)
			return (LINT)n;
	}//end while
	return (LINT)d;
}//end P definition

int main(void)
{

	LINT res = 0;
	long int tresh = 10000000;
	long int start = 1;
	for(long int i = start; i<=tresh; i++)
	{
		res += P(i);
		res = res%1000000000000000000;
	}//end for
	
	cout << res;
	return 0;
}//end main definition
