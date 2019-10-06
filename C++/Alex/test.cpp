#include<iostream>
#include<string>

using namespace std;

int thesum(int a);

int main()
{
   string name1;
   string name2;
   int val1 = 0, val2 = 0;

   cin >> name1;
   cin >> name2;
   
   for(char i: name1)
   {
   
   val1 += ((int)i-65);
   
   } //end for
   
   for(char j: name2)
   {
      val2 += ((int)j-65);
   }//end for
   while ( val1 >9 || val2 > 9)
   {
         if (val1 > 9 ) val1 = thesum(val1);
         
         if (val2 > 9 ) val2 = thesum(val2);
   }//end while
   
   cout << val1 << " " << val2;
   
   return 0;
}

int thesum(int a)
{
   if(a < 10) return a;
   else return (a%10 + thesum( (int) ((a - (a % 10)) / 10)));
   
}

