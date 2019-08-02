#include<iostream>

using namespace std;

int main(){
	//lets analize the switch structure
	
	int day = 7;
	switch (day){
		case 1:
			cout << "Monday";
			break;
		case 2:
			cout << "Tuesday";
			break;
		case 3:
			cout << "Wednesday";
			break;
		case 4:
			cout << "Thursday";
			break;
		case 5:
			cout << "Friday";
			break;
		default: //this piece of code will be executed if no match was found.
			cout << "Its weekend!";
	}
	return 0;
}
