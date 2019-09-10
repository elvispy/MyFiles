#include <iostream>
#include <string>
using namespace std;

struct Person
{
	string name;
	int age;
	float salary;
	
};

int main()
{
	Person bill;
	bill.age = 50;
	bill.salary = 1;
	bill.name = "Jajaja c mamo";
	
	cout << bill.name << endl;
	
	return 0;
}//end main
