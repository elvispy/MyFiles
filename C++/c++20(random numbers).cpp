#include <iostream>
#include <iomanip>
#include <cstdlib>
using namespace std;


//random number generator
int main( void )
{
	unsigned int seed = 0;
	
	cout  << "Enter seed: ";
	cin >> seed;
	srand( seed ); //this will randomize te sequence. Ensure to input different numbers to output different results.
	//If you put the same number twice, you will get the same result twice.
	
	
	//to randomize without having to enter a seed each time, we may use a statement like
	// srand static_cast < unsigned int > ( time( 0 ) ) );
	for(unsigned int counter = 1; counter <=50; ++counter)
	{
		cout << setw(10) << (1+rand() %6 );
		
		if ( counter % 5 ==0) cout << endl;
	} // end for
	return 0;
} // end main
