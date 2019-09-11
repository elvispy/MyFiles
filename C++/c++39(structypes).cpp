#include <iostream>
#include <string>
using namespace std;

struct Person
{
	string name;
	int age;
	float salary;
	
}Elvis; //direct declaration of struc member

int main()
{
	Person bill;
	bill.age = 50;
	bill.salary = 1;
	bill.name = "Jajaja c mamo";
	
	cout << bill.name << endl;
	Elvis.age = 20;
	cout << Elvis.age << endl;
	
	Person * Myptr = &Elvis; //Pointing to my structure!
	(*Myptr).name = "hahah";
	cout << (*Myptr).name << endl; //this is one (tedious) way of  referencing a vairable of a structure through a pointer
	
	//Introducing the arrow operator:
	cout << Myptr -> age; //equivalent to the last line of code
	//Serves to dereference member of an object (in this case, is a structure)
	return 0;
}//end main
