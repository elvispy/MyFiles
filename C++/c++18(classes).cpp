#include <iostream>

#include <string>

using namespace std;

class GradeBook //convention: Begin a classname with capital letter.
{
public: //access specifier

	explicit GradeBook (string name, int num) // this is called a constructor and is the equivalent of __init__ in python (also, it can have default values)
	:courseName( name ), difficulty(num) //initializes courseName, separated by commas
	{
		//empty body
	}
	
	void displayMessage( ) const //this const reserved word tells c++ that  this function mustn't modify the instance of the class
	{
		cout << "Welcome to the Grade Boook\n" << getCourseName() << "!" << endl; //it is recommended to get the coursename in this way
	}
	void setCourseName( string name){
		courseName = name; //sets the coursename
	}
	string getCourseName() const{
		return courseName; //gets the coursename
	}
private: //this is another access specifier
	//Here you define the variables needed in the initialization
	string courseName; //variable inside the courseName, only available inside the class
	int difficulty;
};


int main( void ){
	GradeBook myGradeBook("Alaverginsky", 3);
	GradeBook gradeBook2( "CS102 Data Structures in C++", 1 ); //instantiating a second objecct
	
	//myGradeBook.setCourseName("Introduccion a c mamo"); //uncomment this to set the Course Name
	
	myGradeBook.displayMessage();
	
	
	
}
