#include <iostream>
#include <string>
using namespace std;

class Example4{
	private:
		string*ptr;
	public:
		//Constructors
		Example4() : ptr (new string) {	} //You can overload constructors!
		Example4 ( const string & str) : ptr(new string (str)) {}
		//destructor
		~Example4() {delete ptr;}
		const string  content() const {return *ptr;}
};
int main()
{
	Example4 foo;
	Example4 bar ("My exx");
	
	cout << "Bar's content: " << bar.content() << " \n";
	return 0;
}
