// Fig. 9.2: Time.cpp

#include <stdexcept>
#include "Time.h"
#include <iostream>
#include <iomanip>

using namespace std;

 // Time constructor initializes each data member to zero.

 Time::Time(int h, int m, int s)
 
 {
 	Time::setTime(h, m, s);
} // end Time constructor

// set new Time value using universal time
 void Time::setTime( int h, int m, int s )
 {
 // validate hour, minute and second
 if ( ( h >= 0 && h < 24 ) && ( m >= 0 && m < 60 ) &&
 ( s >= 0 && s < 60 ) )
 {
 hour = h;
 minute = m;
 second = s;
 } // end if
 else
	throw invalid_argument( //throws an exception
		"hour, minute and/or second was out of range\n" );

 } // end function setTime

 // print Time in universal-time format (HH:MM:SS)
 void Time::printUniversal() const
 {
 cout << setfill( '0' ) << setw( 2 ) << hour << ":"
 << setw( 2 ) << minute << ":" << setw( 2 ) << second;
 } // end function printUniversal

 // print Time in standard-time format (HH:MM:SS AM or PM)
 void Time::printStandard() const
 {
 cout << ( ( hour == 0 || hour == 12 ) ? 12 : hour % 12 ) << ":"
 << setfill( '0' ) << setw( 2 ) << minute << ":" << setw( 2 )
 << second << ( hour < 12 ? " AM" : " PM" );
 } // end function printStandard
 
 
 
 
 /*
 ONCE DEFINED, Time can be used as a type in declarations as follows:
 
Time sunset; // object of type Time
array< Time, 5 > arrayOfTimes; // array of 5 Time objects
Time &dinnerTime = sunset; // reference to a Time object
Time *timePtr = &dinnerTime; // pointer to a Time object
 
 */

