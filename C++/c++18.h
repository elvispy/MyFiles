
#include<string>

//headers should NEVER contain using directoresi or using declaration.

//example of a class without a main function to be imported  in other files
class Employee
{
public:
	explicit Employee ( std::string name );	
	
	void SetEmpName ( std::string name);

	std::string getEmpName() const;

	void DisplayMessage() const;
	
private:
	std::string EmpName;
	
};
