#include<iostream>
#include<math.h>

using namespace std;
typedef unsigned long long int big;

int main()
{
	
	big a = 1;
	big res = 1;
	for(big b = pow(10, 10); b>= 1; b--)
	{
		big residual = b;
		big aux = ceil(sqrt(b));
		for(big i = 2; i < aux; i++)
		{
			while(residual%i==0)
			{
				residual = (big) residual/i;
			}
			if (b >= aux * residual )
			{
				res++;
				cout << res << " " << b << "\n";
				
				break;
			}
			
		}//end inner for
		
		
	}//end outer for
	cout << res;
	
	return 0;
}//end main


