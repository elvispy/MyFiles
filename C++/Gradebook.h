#include <string>



class Gradebook
{
public:
	explicit Gradebook ( std::string ); //initializes course name
	void setCourseName( std::string ); // set the course name
	std::string getCourseName() const; //retireve the course name
	void displayMessage() const; //display a welcome message
	void inputGrades() ; // input three grades from user
	void displayGradeReport() const; //display report based on the grades
	int maximum ( int, int, int) const; //you dont need to specify the name of the variables if you are not defining the function in this part
	
private:
	std::string courseName; //course name for this gradebook
	int maximumGrade; //maximum of three grades
	
}; //end of class Grade
