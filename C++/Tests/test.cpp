#include<bits/stdc++.h>
#include<string>
using namespace std;

int main(){
   int N;
   cin >> N;
   cin.ignore();
   string mot;
   getline(cin, mot);
   int v1 = 0;

   for(char L: mot){
   	  //cout << L << "\n";
      if(L == '('){
         v1++;
      }else if(L == ')'){
         v1--;
      }//end if
      if(v1<0){
         cout << "0";
         return 0;
      }//end if
      
      cout << v1 << "\n";
   }//end for
   
   cout << "1";
   return 0;
}//end main
