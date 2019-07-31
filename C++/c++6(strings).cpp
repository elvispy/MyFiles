#include<iostream>
#include<string>

using namespace std;

int main(){
	string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	string dummy;
	
	cout << "The length of the string is :" << str.length() << endl;
	 //we can also do some slicing
	 
	 cout  << str[1] << endl;
	 
	 //observe that cin only recieves one word at a time
	 
	 string p;
	 cin >> p; //try to enter "Hola mundo"
	 cout << p << endl;
	 
	 //the next line will allow us to use gtline in a future time. It is stored in a dummy, not useful variable.
	 getline(cin, dummy);
	 
	 
	 //for that, we use the getline function
	 string z;
	 getline(cin, z);
	 cout << "Your name is " << z;
	 
	 return 0;
}
