#include <iostream>

#include <string>

using namespace std; //just in case


int main( void ){
	//You can reference another variable in C++
	string food = "Pizza";
	string &meal = food; // reference to food
	
	cout << food << "\n";
	cout << meal << "\n"; //Both will output Pizza
	
	meal = "jojo";
	
	cout << food << endl;
	
	cout << meal << endl;
	
	
	//You can address the memory position of a variable
	
	cout << &food << "\n"; //returns 0x22fe20 (dont know if it will change after another compilation)
	
	
	//A pointer is a variable that stores the memory address as its value
	
	string* ptr = &food; //a pointer variable, must be the same type of the variable
	food = "sushi";
	//So ptr is a pointer variable. It references to a memory address.
	//You can dereference the pointer value ( ask for the value stored in the memory) by using the * operator
	
	cout << *ptr << "\n";//will print sushi
	
	
	return 0;
}
