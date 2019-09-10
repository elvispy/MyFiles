// using
#include <iostream>
using namespace std;

namespace first
{
  int x = 5;
  int y = 10;
  float z  = 3.1;
}

namespace second
{
  double x = 3.1416;
  double y = 2.7183;
  long double z = 1.23456789;
}

namespace third = second; //namespace aliasing

int main () {
  using first::x;
  using second::y;
  cout << x << '\n';
  cout << y << '\n';
  cout << first::y << '\n';
  cout << second::x << '\n';
  
  {
  	using namespace first;
  	cout << z << "\n";
  }
  
  {
  	using namespace second;
  	cout << z << "\n";
  }
  //using namespace third;
  //cout << z << "\n"; //will give error
  return 0;
}
