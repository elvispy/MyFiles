#include <iostream>
#include <fstream>
#include <cstdlib>
#include <iomanip> //includes setprecision
using namespace std;

void outputLine ( int, const string &, double); //function prototype


int main ( void )
{
	ifstream myfile("clients.txt", ios::in);
	
	if ( !myfile){
		cerr << "File could not be opened" << endl;
		exit(EXIT_FAILURE);
	}
	
	int account;
	string name;
	double balance;
	
	myfile >> account >> name >> balance;
	/*
	You can change the pointer of the file object. In fact, for ifstream objects you can use seekg and tellg methods.
	for ofstream objects, use seekp and tellp. 
	seek recieves two arguments, the offset and the mode. Available modes are ios::beg (default), ios::cur and ios::end
	*/
	cerr << "1  " << account << name << balance << endl;
	
    myfile.seekg(0, ios::beg); //goes to the beggining
	
	myfile >> account >> name >> balance;
	
	cerr << "2  " << account << name << balance << endl;
	
	myfile >> account >> name >> balance;
	
	cerr << "3  " << account << name << balance << endl;
	
	myfile.seekg(0, ios::end);//goes to the end
	return 0;
} //end main


void outputLine( int account, const string &name, double balance)
{
    cout << left << setw( 10 ) << account << setw( 13 ) << name
    	 << setw( 7 ) << setprecision( 2 ) << right << balance << endl;

} //end function outputLine
