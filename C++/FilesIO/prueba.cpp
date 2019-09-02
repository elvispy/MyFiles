#include <iostream>
#include <string>
using namespace std;



int main ( void ) 
{
   int size;
   int q;
   string abc = "abcdefghijklmnopqrstuvwxyz";
   cin >> q;
   size = 2 * q-1;
   int x, y;
   for(int i = 0; i< size; i++)
   {
   
   for ( int j = 0; j < size; j++)
   {
      x = i;
      y = j;
	  x = ( x >= q ? size-1-x : x);
      y = ( y >= q ? size-1-y : y);
      
      cout << abc[min(x, y)];
   
   }//end inner for
   
   cout << endl;
   } //end outer for

} //end main

