#include <iostream>
#include<array>

using namespace std;

int main()
{
	array <int, 5> items = {1, 2, 3, 4, 5};
	
	//display items before modification
	for (int item: items)
	cout << item << " ";
	  
	//multiply the elements of items by 2
	for ( int &itemRef : items) //observe that itemRef is a reference to  the value in items. 
	itemRef *= 2; //this line changes the reference, thus the value of the element in item
	
	//display items after modification
	cout << "\nitems after modification: ";    
    
    for ( int item: items)
    cout << item << " ";
    
    cout << endl;
    
    return 0;

} // end main
