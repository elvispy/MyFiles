#include <iostream>

using namespace std;

#include "Gradebook.h"

Gradebook::Gradebook(string name) 
  : maximumGrade(0) //maximumGrade will initialize with value zero
{
	setCourseName ( name );
}//end of constructor

void Gradebook::setCourseName(string name)
{
	if ( name.size() <= 25)
	{
		courseName = name;
	}else
	{
		courseName = name.substr(0,25);
		cerr << "Name \"" << name << "\" exceeds maximum length if .\n" << endl;
	}
} //end function setCourseName

string Gradebook::getCourseName() const
{
	return courseName;
}

void Gradebook::displayMessage() const
{
	cout << "Welcome to the grade book for \n" << getCourseName() << "!\n" << endl;
}

void Gradebook::inputGrades()
{
	int grade1;
	int grade2;
	int grade3;
	
	cout << "Enter integer grades: ";
	cin >> grade1 >> grade2 >> grade3;

	
	maximumGrade = maximum(grade1, grade2, grade3);

}

int Gradebook::maximum(int x, int y, int z) const
{
	return (x>=y && x>=z) ? x : ((y>=z) ? y : z); // boolean ? expression : expression
	
}

void Gradebook::displayGradeReport() const
{
	cout << "Maximum of grades entered: " << maximumGrade << endl;
}

int main()
{
	
	Gradebook myGradeBook( "CS101 C++ Programming");
	
	myGradeBook.displayMessage();
	myGradeBook.inputGrades();
	myGradeBook.displayGradeReport();
}
