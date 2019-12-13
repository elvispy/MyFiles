#include <iostream>

#include <string>

void substract ( int arr[]);

using namespace std;

int nbLivres;

int main ( void )
{
   int nbJours;
   cin >> nbLivres >> nbJours; //initialazing days and books
   
   int liv [ nbLivres ] = {}; //initialize with zeros
   string out = "";
   
   
   int clients;
   int livid, days;
   
   for ( int j = 0; j< nbJours; j++)
   {
      
      cin >> clients;
      
      for ( int i = 0; i<clients; i++)
      {
         cin >> livid >> days; //reads the id of the book and the number of days to lend
         
         bool condition = (liv[ livid] == 0); // checks whether the book is  available
         
         out = out + (condition ? "1" : "0"); //string that keeps track of successfulnes of clients
         
         liv [livid] = (condition ? days : 0); // if available, stores the number of days it will be unavailable
         
         
      } //end inner for
      
      substract(liv); // substracts one of every element of the list
      
   } // end outer for
   
   int size = out.size();
   //cout << out << endl;
   for (int i = 0; i < size; i++)
   {
      cout <<  out[i] << endl;
   } // end for
} // end main


void substract (int arr[])
{
   for (int i=0; i< nbLivres; i++)
   {
      arr[i] = (arr[i] > 0 ? arr[i]-1 : 0 );
   }
 
   
}//end function definition

