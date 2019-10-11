#include<iostream>
#include<string>
#include<cctype>

using namespace std;

string tolower(string mys);
string ACR(string mys);
string toupper(string mys);


int main()
{
	//cout << tolower("Lets see if this works");
    string acronym;
    cin >> acronym;
    acronym = toupper(acronym);
    int nLivres;
    cin >> nLivres;
    string linhe = "";
    for (int i = 0; i < nLivres; i++)
    {
        getline(cin, linhe);
		linhe = tolower(linhe);      
        if (ACR(linhe) == acronym)
			cout << linhe << "\n";
      
    }//end for
    return 0;
}//end main

string toupper(string mys)
{   
    string res = "";
    for(char aux: mys)
        res = res + (char)toupper(aux);
   
    return res;
}//end function definition

string tolower(string mys)
{   
	char ant = mys[0];
    string res = string() + (char)toupper(ant);
    bool mybool = true;
    for(char aux: mys)
    {
    	if (mybool == true)
    	{
    		mybool = false;
    		continue;
		}//end first if
		
		if ( ant == ' ')
			res = res + (char)toupper(aux);
    	else
			res = res + (char)tolower(aux);
			
		ant = aux;
	}//end for
   
    return res;
}//end function definition

string ACR(string mys)
{
    char ant = mys[0];

    string res = string() + ant;
    bool mybool = true;
    for(char aux: mys)
    {
        if (mybool == true)
        {
            mybool = false;
            continue;
        }
        if(ant == ' ')
        {
            res = res + aux;
        } // end if
      
        ant = aux;
      
   }//end for
   
   
   
   return res;
   
}//end acr definition
