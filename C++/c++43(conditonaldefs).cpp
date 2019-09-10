#include <iostream>
//conditional compilation
#define my_const (1)
//We can also use #if, #ifdef, #ifndef, #elif, #else and #endif. With #if and #elif with can put one condition
#ifndef my_const

	#define my_const (10)
#else
	#define another (20)
#endif

int main()
{
	std::cout << my_const;
	
	#ifdef another
		std::cout << "\n \n" << another;
	#endif
	return 0;
}
