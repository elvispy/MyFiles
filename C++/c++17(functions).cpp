#include <iostream>

using namespace std;

//you must define your functions before the main function. Otw an error will be raised
//in C++ all functions must have a type. You can use the reserved word "void" to emphasize that your function does not have a type
//but then you are not allowed to return any values

//so the next code will raise an error. Fix it


void lol( void ){
	cout << "lolazo";
	return 0;
}


void another( void ); //you can define a function after the main, using this way.}

//you can have multiple functions with the same name, as long as one of the parameters or the function types are different

int plusFunc(int x, int y) {
  return x + y;
}


double plusFunc(double x, double y) {
  return x + y;
  }
//wont raise any errors




int main(void ){
	int  vari = lol();
	return 0;
}

void another( void ){
	cout << "I just got executed!\n";
}
