#include <iostream>
#include <string>
#include <fstream> // constains file stream processing types
#include <cstdlib> // exit function prototype
using namespace std;

int main( void )
{
	//ofstream constructor opens file
	ofstream outClientFile( "clients.txt", ios::out );
	
	//exit program if unable to create file
	if ( !outClientFile) // Overloaded ! operator
	{
		cerr << "File could not be opened" << endl;
		exit( EXIT_FAILURE );
	} // end if
	
	cout << "Enter the account, name, and balance." << endl << "Enter end-of-file to end the input. \n?";
	
	int account; // the account number
	string name; // the account owner's name
	double balance; // the account balance
	
	//read account, name and balance from cin, then place in file
	while(cin >> account >> name >> balance)
	{
		outClientFile << account << " " << name << " " << balance << endl;
		cout << "?";
	} //end while
}//end main
