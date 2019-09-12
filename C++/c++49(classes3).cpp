// classes and uniform initialization
#include <iostream>
using namespace std;

class Circle {
    double radius;
  public:
    Circle(double r) { radius = r; }
    double circum() {return 2*radius*3.14159265;}
    double area() const
    {
    	return radius*radius*3.14159265;
	}
};

class Cylinder
{
	private:
		Circle base;
		double height;
	public:
		Cylinder (double r = 2, double h = 3): base(r), height(h){ }
		double volume () {return base.area() * height;}
		
}mycil(1.0, 1.0);

int main () {
  Circle foo (10.0);   // functional form
  Circle bar = 20.0;   // assignment init.
  Circle baz {30.0};   // uniform init.
  Circle qux = {40.0}; // POD-like
  
  Cylinder cil2;

  cout << "My cil's volume: " << mycil.volume() << "\n";
  cout << "foo's circumference: " << foo.circum() << "\n";
  return 0;
}
