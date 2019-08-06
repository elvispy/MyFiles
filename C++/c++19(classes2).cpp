#include<iostream>
#include "c++18.cpp" //include the c++18 employee class from the definitions
using namespace std;

int main( void ){
	Employee Emp1("Elvisaguero");
	Employee Emp2("Sidharta Gautama");
	
	cout  << Emp1.getEmpName() << endl;
	cout << Emp2.getEmpName() << endl;
	
	return 0;
	
} //end main
