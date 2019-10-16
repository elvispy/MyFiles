#include<iostream>

using namespace std;

int main()
{
   int N;
   cin >> N;
   int table[N][N];
   for(int i = 0; i< N; i++)
   {
      for(int j = 0; j< N; j++)
      {
         cin >> table[i][j];
      } //end inner for
      cin.ignore();
   }//end for
   int aux = 0;
   int aux2 = 0;
   for(int l = 0; l < N; l++)
   {
      aux += table[l][l];
      aux2 += table[N-1-l][l];
   }//end for
   if(aux != aux2)
   {
      cout << "no";
      return 0;
   }
   
   aux2 = 0;
   int aux3 = 0;
   
   for(int i = 0; i < N; i++)
   {
      aux2 = 0;
      aux3 = 0;
      
      for(int j = 0; j < N; j++)
      {
         aux2 += table[i][j];
         aux3 += table[j][i];
      }//end for
      if(aux2 != aux || aux3 != aux)
      {
         cout << "no";
         return 0;
      }
   }//end for
   cout << "yes";
   return 0;
}//end main
