#include<iostream>

#include<algorithm>

using namespace std;

int  ret(int a){
	a++;
	return a;
}

int main(void)
{
	int a = 42;
	int b = ret(a);
	cout << a << b;
}//end main
