#include<iostream>
//#define AUTOS (1000)


//int autos[AUTOS] = {};
using namespace std;
void pprint(int arr[], int i);
void calc(int autos[], int nbA);

int main()
{
  int nbA;
  cin >> nbA;
  cin.ignore();
  int autos[nbA] = {};
  for(int i = 0; i<nbA; i++)
  {
    cin >> autos[i];
  }//end for
  calc(autos, nbA);
  for(int i = 1; i<=nbA; i++)
  {
  
  for(int j= 0; j<nbA; j++)
  {
  
     if(autos[j]== i)
     {
     	pprint(autos, j);
     	break;
	 }//end inner if
  }//end inner for
  
  }//end outer for
  
  return 0;
}//end main

void calc(int autos[], int nbA)
{
	int s = 0;
	for(int i = 0; i < nbA-1; i++)
	{
		for(int j= i+1; j< nbA; j++)
		{
			if(autos[i] > autos[j])
				s++;
		}//end inner for
	
	}//end outer for
	cout << s << "\n";
}//end function definition

void pprint(int arr[], int j)
{
	int val = arr[j];
	j--;
	while(j>=0)
	{
		if (arr[j]>val)
		{
			cout << arr[j] << " " << val << "\n";
		}//end if
		j--;
	}//end while
}//end function definition
