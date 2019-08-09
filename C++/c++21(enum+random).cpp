/*
A player rolls two dice. Each die has six faces. These faces contain 1, 2, 3, 4, 5 and 6
spots. After the dice have come to rest, the sum of the spots on the two upward faces is
calculated. If the sum is 7 or 11 on the first roll, the player wins. If the sum is 2, 3 or
12 on the first roll (called “craps”), the player loses (i.e., the “house” wins). If the sum
is 4, 5, 6, 8, 9 or 10 on the first roll, then that sum becomes the player’s “point.” To
win, you must continue rolling the dice until you “make your point.” The player loses
by rolling a 7 before making the point.
*/

#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

unsigned int rollDice(); //function prototype


int main ( void )
{
	enum Status { CONTINUE, LOST, WON}; //this is an enum data type
	
	//observe that you can begin an enumeration with another index
	enum day { LUNDI = 1, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE}; //ll this values are constant (For example, JEUDI = 4)
	
	srand ( static_cast <unsigned int> ( time ( 0 ) ) );
	
	unsigned int myPoint = 0;
	
	Status gameStatus = CONTINUE;
	unsigned int sumOfDice = rollDice();
	
	switch ( sumOfDice)
	{
		case 7:
		case 11:
			gameStatus = WON;
			break;
		case 2:
		case 3:
		case 12:
			gameStatus = LOST;
			break;
		default:
			gameStatus = CONTINUE;
			myPoint = sumOfDice;
			cout  << "Point is " << myPoint << endl;
			break;
	}
	
	while ( CONTINUE == gameStatus) //put the constant to the left, always
	{
		sumOfDice = rollDice();
		
		if (sumOfDice == myPoint)
		{
			gameStatus = WON;
		}else
		{
			if (sumOfDice == 7 ) gameStatus = LOST;
		}//wne if
	}//end while
	
	
	if ( WON == gameStatus)
		cout << "Player wins" << endl;
	else
		cout << "Player loses" << endl;
		
} // end main




unsigned int rollDice()
{
	unsigned int die1 = 1 + rand() % 6;
	unsigned int die2 = 1 + rand() % 6;
	
	unsigned int sum = die1 + die2;
	
	cout << "Player rolled " << die1 << " + " << die2
	    << " = " << sum << endl;
	    
	return sum;
}//end of rollDice Function
