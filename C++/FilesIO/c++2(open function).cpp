/*
ios::app 		Append all output to the end of the file.
ios::ate 		Open a file for output and move to the end of the file (normally used to
				append data to a file). Data can be written anywhere in the file.
ios::in 		Open a file for input.
ios::out 		Open a file for output.
ios::trunc		Discard the file’s contents (this also is the default action for ios::out).
ios::binary 	Open a file for binary, i.e., nontext, input or output.

*/

#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
using namespace std;

int main ( void )
{
	//You can create an ofstream object without referencing to a file
	ofstream outClientFile;
	
	//The function open can attatch the object to an existing file
	outClientFile.open("clients.txt", ios::out);
	
	//You can also close the file
	outClientFile.close();
}
