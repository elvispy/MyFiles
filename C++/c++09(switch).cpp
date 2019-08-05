#include<iostream>

using namespace std;

int main(){
	//lets analize the switch structure
	
	int day = 1;
	switch (day){
		case 1:
			cout << "Monday";
			break; //if you dont put the break, it'll execute all following instructions
			
		case 2: //if you don't put any instructions, both will be squeezed into one
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
