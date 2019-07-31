#include<iostream>

using namespace std;

int main(){
	//lets analize the while and for structure
	
	int i = 0;
	
	while (i<5){
		cout << i << "\n";
		i++;
	}
	
	
	/*
	There is do/while structure, which will evaluate at least once the structure
	
	*/
	do{
		i--;
	} while (i>-30);
	
	cout << i << "\n";
	
	//-------------------------------------
	//Now lets see the for loop
	/*
	SYNTAX
	for (statement 1; statement 2; statement 3) {
         code block to be executed
    }
    
    Statement 1 will be executed one time before the execution of the block begins
    
	Statement 2 is the condition for executing the block
	
	Statement 3 is executed every time after the code block has been executed;
  
	*/
	
	for (int i = 0; i<10; i++){ //or i = i++2
		cout << i << "\n";
	}
	
	
	return 0;
}
