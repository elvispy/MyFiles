// strings and NTCS:
#include <iostream>
#include <string>
using namespace std;

int main ()
{
	//Strings and chars are almost interchangeables.
    char question1[] = "What is your name? ";
    string question2 = "Where do you live? ";
    char answer1 [80];
    string answer2;
    cout << question1;
    cin >> answer1;
    cout << question2;
    cin >> answer2;
    cout << "Hello, " << answer1;
    cout << " from " << answer2 << "!\n";
    
    /*However, there is a difference. char arrays have
    fixed length calculated in compilation time, and strings are not
    */
    
    char myntcs[] = "some text";
    string mystring = myntcs; //Convert char array to string object
    cout << myntcs;
    cout << mystring.c_str(); //printed as c-string
    return 0;
}
