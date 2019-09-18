#include  <iostream>

using namespace std;

class Dummy {
	public:
		static int n;
		int x;
		Dummy (int val = 10) : x(val) {
			n++;
		};
		
		const int& get () const {return x;}
		
		void set() {
			x++;
		}
};

void print (const Dummy & arg)
{
	cout << arg.get() << "\n";
}


/*to avoid them to be declared several times, they cannot be
 initialized directly in the class, but need to be initialized somewhere outside it*/
int Dummy::n = 0;

int main()
{
	Dummy a;
	Dummy b[5];
	cout << a.n << "\n";
	Dummy* c = new Dummy;
	cout << Dummy::n << "\n";
	
	//Because it is a common variable for all the objects of the same class, 
	//it can be referred to as a member of any object of that class or even directly by the class name
	
	cout << a.n << "\n";
	cout << Dummy::n << "\n";
	
	//Just as other variable types, we can define const objects to be read-only
	const Dummy md(12);
	
	//Recall the difference between const func and func const.
	//Inside the class, func const  is called a constant member function. If we define an instance of the class
	// to be constant, then it can access only constant member functions
	//
	print(md);
	//md.set(); //this will give an error
	
}
