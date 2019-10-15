#include<iostream>
#include<string>
#include<cctype>

using namespace std;

char circ(char aux, int hm, bool isup);
int guess(string line);

int main()
{
   cout << circ('D', 104, false) << "\n";
   int nPages;
   cin >> nPages;
   cin.ignore();
   for(int i = 0; i< nPages; i++)
   {
      
      if(i>0)
      {
         string linea;
         getline(cin, linea);
         int chiffre = guess(string line);
         //cout << chiffre << "\n";
         for(char aux: linea)
         {
            if(isalpha(aux))
            {
               cout << circ(aux, chiffre, isupper(aux));
            }else
            {
               cout << aux;
            }//end inner if
         }//end for
         cout << "\n";
      }//end if
   
   }//end for
   return 0;
}//end main

char circ(char aux, int hm, bool isup)
{
   hm = hm % 26;
   aux = tolower(aux);
   int alph;
   if((int)(aux + hm) > 122)
      alph = aux + hm -26;
   else if ( (int)(aux + hm) < 97)
      alph = aux + hm + 26;
   else
      alph = aux + hm;
   return isup ? (char)toupper((char)alph) : (char)(alph);
}//end functino definition

int guess(string line)
{
	bool mybool = true;
	bool mybool2 = true;
	bool mybool3 = true;
	char ant = line[0];
	char aux2 = line[1];
	char aux3 = line[2];
	int cont = 0;
	char guesses[26];
	for(int i = 0; i < line.length(); i++)
	{
		if(i>2)
		{
			if(ant == ' ' && aux == ' ')
			{
				
				
			}//end if
			ant = aux2;
			aux2 = aux3;
			aux3 = aux;
		}//end if
		
		
	}//end for
}//end function definition

