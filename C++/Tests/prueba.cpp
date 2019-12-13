#include <bits/stdc++.h>
#define N 100

using namespace std;
int * eq(int mylist[]){
	mylist[0]--;
	mylist[0]--;
	return mylist;
}

int main()
{
   ios_base::sync_with_stdio(0);
   cin.tie(0);
   int mylist[4] = {1, 3, 5, 7};
   int *p = eq(mylist);
   //p[0] = 2;
   cout << mylist[0];
}
