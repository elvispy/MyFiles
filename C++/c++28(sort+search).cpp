#include <iostream>
#include <iomanip>
#include <array>
#include <string>
#include <algorithm>


using namespace std;

int main()
{
	const size_t arraySize = 7; //size of array colors
	array< string, arraySize > colors = { "red", "orange", "yellow", "green", "blue", "indigo", "violet"};
	
	for (string color:colors)
	cout << color << " ";
	
	sort(colors.begin(), colors.end());
	
	bool found = binary_search( colors.begin(), colors.end(), "cyan");
	
	cout << "\n\n\"cyan\" " << ( found ? "was" : "was not" ) << " found in colors" << endl;
	
	
	return 0;
}
