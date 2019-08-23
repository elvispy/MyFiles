#ifndef TIME_H //if not defined, define this
#define TIME_H

// Time class definition
 class Time
 {
 public:
 
 	Time( int = 0, int = 0, int = 0); // constructor
 	void setTime( int, int, int ); // set hour, minute and second
 	void printUniversal() const; // print time in universal-time format
 	void printStandard() const; // print time in standard-time format
 
 private:
 
 	unsigned int hour; // 0 - 23 (24-hour clock format)
 	unsigned int minute; // 0 - 59
 	unsigned int second; // 0 - 59
}; // end class Time

#endif
