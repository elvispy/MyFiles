#include <iostream>
#define repeat(nb) for(int _loop = 1, _max = (nb); _loop <= _max; _loop++)
#define MY_CONST (3) //always put parenthesis!!
#define y && //replacing key words

//marcos can be used to define some formules that are type independent!
#define abs(nb) ((nb) < 0 ? -(nb) : (nb))
#define minn(a,b) ((a) < (b) ? (a) : (b))
//they resemble lambda expressions from python

using namespace std;
int main()
{
	int saisie;

	repeat (MY_CONST)
	{
		cin >> saisie;
		cout << saisie << "\n";
	}
	cout << "\n\n\n";
	
	if(true y true)
	{
	
		cout << minn(1, 2);
		//we can undefine macros!
		#undef y
	}//end if
	
	//next line wil give an error
	if (true y false) cout << "Hola mundo";
		
}
