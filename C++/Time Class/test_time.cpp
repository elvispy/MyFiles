#include <iostream>
#include <stdexcept>
#include  "Time.h" //include definition of class Time from Time.h
#include "Time.cpp"
using namespace std;

int main()
{
	Time t; // instantiate object t o f class Time
	
	//cout Time object t's initial values
	cout << "The initial universal time is ";
	t.printUniversal();
	cout << "\nThe initial standard time is ";
	t.printStandard();
	
	t.setTime(13, 27, 6 ); //change time
	
	// output Time object t's new values
    cout << "\n\nUniversal time after setTime is ";
    t.printUniversal(); // 13:27:06
    cout << "\nStandard time after setTime is ";
    t.printStandard(); 
	cout << "\n" ; // 1:27:06 PM

    // attempt to set the time with invalid values
    try
    {
        t.setTime( 99, 99, 99 ); // all values out of range
    } // end try
	catch ( invalid_argument &e )
	{
		cout << "Exception: " << e.what() << endl;
	} // end catch

 	// output t's values after specifying invalid values
 	cout << "\n\nAfter attempting invalid settings:"
 	<< "\nUniversal time: ";
 	t.printUniversal(); // 13:27:06
 	cout << "\nStandard time: ";
 	t.printStandard(); // 1:27:06 PM
 	cout << endl;
 	
 	return 0;
 } // end main

