#include<iostream>
#define MAX 40

using namespace std;

int check(int tableau[MAX][MAX], int i, int j);

int main()
{
   int nbTbl = 0;
   cin >> nbTbl;
   int tableau[MAX][MAX];
   cin.ignore();
   for(int i = 0; i < nbTbl; i++)
   {
      for(int j = 0; j< nbTbl; j++)
      {
         cin >> tableau[i][j];
      }//end inner for
      cin.ignore();
   }//end outer for
   
   //Analyzing whether it is possible to 
   
   for(int i=2; i < nbTbl-2; i++)
   {
      for(int j = 2; j < nbTbl-2; j++)
      {
         if(tableau[i][j] != 0)
         {
         
         if(check(tableau, i, j))
         {
            cout << tableau[i][j];
            return 0;
         }//end inner if
         
         }//end outer if
      }//end inner for
   }//end outer for
   cout << 0;
   return 0;

}//end main


int check(int tableau[MAX][MAX], int i, int j)
{
   int val = tableau[i][j];
   if(val == 0)
       throw "Debe ser diferente de zero";
   if(tableau[i-1][j] == val && tableau[i-2][j] == val && tableau[i+1][j] == val && tableau[i+2][j] == val)
      return true;
   if(tableau[i][j-1] == val && tableau[i][j-2] == val && tableau[i][j+1] == val && tableau[i][j+2] == val)
      return true;
   if(tableau[i-1][j-1] == val && tableau[i-2][j-2] == val && tableau[i+1][j+1] == val && tableau[i+2][j+2] == val)
      return true;
   if(tableau[i-1][j+1] == val && tableau[i-2][j+2] == val && tableau[i+1][j-1] == val && tableau[i+2][j-2] == val)
      return true;
   return false;
}//end function definition
