#include<iostream>
#include<cctype>

using namespace std;

struct casillas
{
   int f;
   int c;
};

bool valid(casillas a);

casillas * crear(casillas b);

int main()
{
    char carre[8][8];
   
    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j< 8; j++)
            cin >> carre[i][j];
        cin.ignore();
    }//end for
   
    for(int i = 0; i < 8; i++)
    {
        for(int j = 0; j< 8; j++)
        {
            if (carre[i][j] == 'C')
            {
            	casillas aux;
            	aux.f = i;
            	aux.c = j;
            	casillas * creados = crear(aux);
            	for(int l = 0; l<8;l++)
            	{	
            		if (valid(*(creados + l)))
            		{
            			casillas res = *(creados + l);
            			if(islower(carre[res.f][res.c]))
						{
							cout << "yes";
							return 0;
						}//end if 	
					}//end if	
				}//end innermost for
            }//end if
        }//end for
    }//end for
    cout << "no";
    return 0;
}//end main


casillas * crear(casillas b)
{
	static casillas r[8];
	r[0].c = b.c + 2;
	r[0].f = b.f + 1;
	r[1].c = b.c + 2;
	r[1].f = b.f - 1;
	r[2].c = b.c - 2;
	r[2].f = b.f + 1;
	r[3].c = b.c - 2;
	r[3].f = b.f - 1;
	r[4].c = b.c + 1;
	r[4].f = b.f + 2;
	r[5].c = b.c + 1;
	r[5].f = b.f - 2;
	r[6].c = b.c - 1;
	r[6].f = b.f + 2;
	r[7].c = b.c - 1;
	r[7].f = b.f - 2;
	
	return r;
	
	
}//end function definition

bool valid(casillas a)
{
    if( a.c < 0 || a.f < 0 || a.c>7 || a.f > 7)
        return false;
    return true;
}//end function definition

