#include<iostream>

#include<algorithm>

using namespace std;

int main(void)
{
	int lol[6] = {13, 9, 20, 0, 101, 2019};
	
	int found = *std::find(lol, lol + 4, 2019);
	cout << found;
	return 0;
}//end main
