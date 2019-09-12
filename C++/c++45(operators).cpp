#include <iostream>
using namespace std;

//We can overload operators as well, not only functions.
/*
Overloadable operators
+ - * / = < > += -= *= /= << >>
<<= >>= == != <= >= ++ -- % & ^ ! |
~ &= ^= |= & || %= [] () , ->* -> new
delete new[] delete[]
*/
class Test
{
   private:
      int count;
   public:
       Test(): count(5){}
       void operator ++() 
       { 
          count = count+1; 
       }
       void Display() { cout<<"Count: "<<count; }
};

//another possible syntax
class Cvector
{
	public:
		int x, y;
		Cvector() {};
		Cvector (int a, int  b) : x(a), y(b) {};
		Cvector operator + (const Cvector&);
};


//Note the :: operator. This means that "+" is only defined inside Cvector class
//and then it is called a member function overloading
Cvector Cvector::operator + (const Cvector & param)
{
	Cvector temp;
	temp.x = x + param.x;
	temp.y = y + param.y;
	return temp;
 } 
 
 //this is called a non-member function overloading
 Cvector operator -(const Cvector & lhs, const Cvector&rhs)
 {
 	Cvector temp;
 	temp.x = lhs.x - rhs.x;
 	temp.y = lhs.y - rhs.y;
 	return temp;
 	
 }
int main()
{
    Test t;
    // this calls "function void operator ++()" function
    ++t;    
    t.Display();
    cout << "\n";
    
    
    
    
    Cvector foo(3, 1);
    Cvector bar(1, 2);
    Cvector result = foo + bar; //equivalent to a.operator+(b)
    cout << result.x << ", " << result.y << "\n";
    cout << (foo-bar).x << ", " << (foo- bar).y << "\n";
    
    return 0;
}
