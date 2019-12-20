#include<iostream>

#include<algorithm>

using namespace std;

void ret(int a[]);

int main(void)
{
	int a[2] = {};
	ret(a);
	cout << a[1];// << b;
}//end main

void  ret(int a[]){
	a[1]++;
	//return a;
}
