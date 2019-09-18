#include <iostream>

using namespace std;

class Polygon {
	private: //Private! cannot be accesed vy inherited classes
		 int myval;
		 
	protected://protected! can be accesed by inheritance
		int width, height;
	public:
		Polygon():myval( 5 ){ count++;}
		static int count;
		void set_values (int a, int b)
		{width = a; height = b;	}
		void see() {cout << myval << "\n";}
};

class Rectangle: public Polygon {
	public:
		int area()
		{
			//cout << this -> myval; //Error! Myval is private
			return width * height;
		}
};

class Triangle: public Polygon{
	public:
		int area(){
			return width*height / 2;
		}
};

class Rombo: protected Polygon //al public elements of Polygon are protected now
{
	public:
		int perim(){ return width + height;}
	
};

int Polygon::count = 0;
int main(){
	Rectangle rect;
	Triangle trgl;
	rect.set_values(4, 5);
	trgl.set_values(4, 5);
	rect.see();
	trgl.see(); //even though myval is private, you can read the variable
	cout << rect.area() << '\n';
  	cout << trgl.area() << '\n';
    
	Rombo myromb;
	//myromb.set_values(10, 15); //Error! set values is protected
	//cout << Rombo::count; //Error! count is protected
	cout << Polygon::count;
	return 0;
}
