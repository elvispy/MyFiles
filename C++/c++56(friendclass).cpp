#include <iostream>

using namespace std;

class Square; //class definition!

class Rectangle{
	private:
		int width, height;
	public:
		int area()
		{
			return width * height;
		}
		void convert ( Square a);
};

class Square {
	friend class Rectangle; //now rectangle can access to private members of square
	
	/*
	Friendship is not transitive nor reciprocal. Although Rectangle is considered to
	be a friend of Square, the other way around is not ture. Also, a friend of a friend is not
	a friend, unless explicitly specified.
	*/
	private:
		int side;
	public:
		Square(int a): side(a){	}
};

void Rectangle::convert(Square a){
	width = a.side;
	height = a.side;
}

int main(){
	Rectangle rect;
	Square sqr(4);
	rect.convert(sqr);
	cout << rect.area();
	return 0;
}
