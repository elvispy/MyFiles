#include<bits/stdc++.h>

using namespace std;


int main(){
	cin.sync_with_stdio(false);
	cin.tie(0);
	int nb[1000] = {};
	int dates[1000] = {};
	int idx1 = 0;
	int idx2 = 0;
	int P;
	cin >> P;
	for(int i = 0; i<P; i++)
	{
		int num, dat;
		cin >> num >> dat;
		if(num > 0)
		{
			myPile = put(myPile, num, dat);
		}else{
			myPile = quit(myPile, -num);
		}//end if
	}//end for
	cout << myPile.dates[myPile.idx1];
	return 0;
}
