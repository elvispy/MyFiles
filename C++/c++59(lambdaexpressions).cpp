#include<iostream>
using namespace std;

auto myfun = [](int x, int y) -> int { return x + y;}; //this is a lambda expression

int main()
{
	cout << myfun(-5, 2) << "\n";
	
	auto print = []() -> void {cout << "Hola amiguito" << endl;};
	print();
	return 0;
}
