#include <iostream>


#include "c++18.h"

using namespace std;

Employee::Employee( string name)
	:EmpName( name )
{	
 Employee::DisplayMessage();
}  //initializing the instance (always put comments after a bracket is closed)

void Employee::SetEmpName(string name)
{
   EmpName = name;	
} //changes the Employee's name

string Employee::getEmpName() const
{
	return EmpName;
}//returns the name

void Employee::DisplayMessage() const 
{
	cout << "Welcome to the Bussiness, " << getEmpName() << endl;
}//prints out the employee's name
