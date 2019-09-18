#include <iostream>
using namespace std;

class Rectangle {
	private:
		int width, height;
	public:
		Rectangle() {}
		Rectangle(int x, int y) : width(x), height(y) {	}
		int area() {
			return width * height;
		}
		friend Rectangle duplicate (const Rectangle &);
		int perim ();
};

Rectangle::perim(){
	cout << this -> width << "\n"; //you can use this, its equivalent to just width
	//REMEMBER THAT THIS is a pointer, always.
	return 2*(width + height); //this is not an error since we are using the namespace operator ::
}

Rectangle duplicate (const Rectangle & param)
{
	Rectangle res;
	res.width = param.width * 2; //its not an error since Rectangle is a friend function
	res.height = param.height * 2;
	return res;
}
/*
int myfunc ( Rectangle myrec)
{
	cout << myrec.width; //error because width is private
}

*/
int main()
{
	Rectangle foo;
	Rectangle bar (2, 3);
	foo = duplicate(bar);
	cout << foo.perim() << "\n";
	//cout << foo.width << "\n"; //its an error because width is private
	cout << foo.area() << "\n";
}
