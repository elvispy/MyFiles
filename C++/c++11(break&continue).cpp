#include<iostream>

using namespace std;

int main(){
	// break can also be used in other loops
	
	for (int i=0; i<10; i++){
		if  (i == 4){
			break;
		}
		cout << i << "\n";
	}
	
	//in contrast, continue will break only one loop
	cout << "\n\n\n\n";
	for (int i=0; i<10; i++){
		if  (i == 4){
			continue;
		}
		cout << i << "\n";
	}
	
	//obviously, you can use break and continue in other structures
	return 0;
}
