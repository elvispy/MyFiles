#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
#include <cstdlib>
using namespace std;

void outputLine ( int, const string &, double); //function prototype

int main ( void )
{
	//ifstream constructor opens the file
	ifstream inClientFile( "clients.txt", ios::in);
	
	//exit program if ifstream could not open file
	if ( !inClientFile )
	{
		cerr << "File could not be opened" << endl;
		exit ( EXIT_FAILURE );
	} // end if
	
	int account;
	string name;
	double balance;
	
	cout << left << setw(10) << "Account" << setw( 13 )
		<< "Name" << "Balance" << endl << fixed << showpoint;
		
	//displpay each record in file
	while ( inClientFile >> account >> name >> balance) //!inClientFile.eof() is a boolean that checks if we are in end of file.
	outputLine( account, name, balance);
} // end main

void outputLine( int account, const string &name, double balance)
{
    cout << left << setw( 10 ) << account << setw( 13 ) << name
    	 << setw( 7 ) << setprecision( 2 ) << right << balance << endl;

} //end function outputLine
