#include<bits/stdc++.h>

using namespace std;
int * substract(int prod[], int nb, int aux);

int main(){
	ios::sync_with_stdio(0);
	cin.tie(0);
	int P;
	cin >> P;
	int *dates[P];
	int *prod[P];
	int aux = 0;
	for(int i = 0; i< P; i++)
	{
		int nb, dat;
		cin >> nb >> dat;
		if (nb >0)
		{
			dates[aux+1] = dat;
			prod[aux+1] += nb;
			aux++;
		}else{
			substract(prod, nb, aux);
		}//end if
	}//end  for
	
	return 0;
}

int * substract(int prod[], int nb, int aux){
	while(nb < 0)
	{
		while(prod[aux]>0)
		{
			prod[aux]--;
			bn++;
		}//end inner while
		aux--;
	}//end outer while
	return prod;
}//end function definition
