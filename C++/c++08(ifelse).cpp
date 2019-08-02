#include<iostream>
#include<string>

using namespace std;

int main(){
	// if, else, else if , switch structures
	
	int x;
	bool t = false;
	cin >> x; //you cant put a endl after a cin
	if (x % 2 == 0){
		cout << "El numero ingresado es par";
	} else if (x == 1) {
		cout << "el numero es igual a 1";
	}else {
		cout << "El numero ingresado es impar, diferente de 1";
	}
	
	
	//shorthand if else operator
	
	int time = 20;
	string result = (time <18 ) ? "It is time to have supper" : "Lol keep doing nothing";
	//it will take the second value if the condition is false
	
	cout << result;
	return 0;
}
