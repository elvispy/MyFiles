#include<iostream>

using namespace std;

int max(int arr[], int size);

int main()
{
   int N;
   int M;
   cin >> N;
   cin >> M;
   cin.ignore();
   int dgr[N];
   for(int i = 0; i< N; i++)
   {
      cin >> dgr[i];
   }//end for
   
   int idx = 0;
   for(int j = 0; j<M; j++)
   {
   		idx = max(dgr, N);
   		cout << dgr[idx] << " ";
   		dgr[idx] = -1;
   }//end for
   
}//end main

int max(int arr[], int size)
{
	int m = arr[0];
	int inx = 0;
	for(int j = 0; j< size; j++)
	{
		if(arr[j] > m)
		{
			inx = j;
			m = arr[inx];
		}//end if
	}//end for
	
	return inx;
}//end function definition
