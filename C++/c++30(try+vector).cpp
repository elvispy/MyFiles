#include <iostream>

#include <iomanip>
#include <vector>
#include <stdexcept>

using namespace std;

void outputVector ( const vector < int > &); //display the vector
void inputVector ( vector <int> &);

int main( )
{
	vector< int > integers1( 7 ); // 7-element vector< int >
	vector< int > integers2( 10 ); // 10-element vector< int >	
	
	cout << "Size of vector integers1 is: " << integers1.size() << "\nvector after initialization: " << endl;
	outputVector ( integers1 );
	
	cout << "\nSize of vector integers2 is: " << integers2.size() << "\nvector after initialization:" << endl;
	outputVector( integers2 );
	
	//Input and print integers1 and integers2
	cout << "\n Enter 17 integers:" << endl;
	inputVector( integers1 );
	inputVector( integers2 );
	
	cout << "\nAfter input, the vectors contain: \n" << "integers1:" << endl;
	outputVector( integers1 );
	cout << "integers2: " << endl;
	outputVector ( integers2 );
	
	
	
	cout << "\nEvaluating: integers1 != integers2" << endl;
  
   if ( integers1 != integers2 )
   cout << "integers1 and integers2 are not equal" << endl;
   
   
   
   vector <int > integers3 ( integers1 ); //copy constructor
  


   cout << "\nSize of vector integers3 is "  << integers3.size()
   << "\nvector after initialization:" << endl;
   outputVector( integers3 );
  
  
  cout << "\nAssigning integers2 to integers1: " << endl;
  integers1 = integers2;
  
  
   cout << "integers1:" << endl;
   outputVector( integers1 );
   cout << "integers2:" << endl;
   outputVector( integers2 );
  
   // use equality (==) operator with vector objects
   cout << "\nEvaluating: integers1 == integers2" << endl;
  
   if ( integers1 == integers2 )
   cout << "integers1 and integers2 are equal" << endl;	
   
   
   cout << "\n\nAssigning 1000 to integers1[5]" << endl;
   integers1 [5] = 1000; //assigning to integers1
   cout << "integers1:" << endl;
   outputVector( integers1 );
   
   
   
   // attempt to use out-of-range subscript
try
{
cout << "\nAttempt to display integers1.at( 15 )" << endl;
cout << integers1.at( 15 ) << endl; // ERROR: out of range
} // end try
catch ( out_of_range &ex )
{
cerr << "An exception occurred: " << ex.what() << endl;
} // end catch

cout << "\nCurrent integers3 size is: " << integers3.size() << endl;
integers3.push_back( 1000 ); // add 1000 to the end of the vector
cout << "New integers3 size is: " << integers3.size() << endl;
cout << "integers3 now contains: ";
outputVector( integers3 );
   
} // end main


void outputVector( const vector <int > &items)
{
	for ( int item: items)
	    cout << item << " ";
	
	cout << endl;
} // end function outputVector

void inputVector( vector <int > &items)
{
	for (int &item : items)
	  cin >> item;
	
	
}
