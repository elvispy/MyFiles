#include <iostream>

using namespace std;

//Anonymous unions
struct book1_t
{
	char title[50];
	char author[50];
	union
	{
		float dollars;
		int yen;
	}price;
}book1;

struct book2_t
{
	char title[50];
	char author[50];
	union{
		float dollars;
		int yen;
	};
}book2;

int main()
{
	//notice that in the definitions we dont have names for the unions.
	//Furthermore, there is another difference. In the second book, we didn't
	//create any abjects related to the union. Still, we can access the dollars and yen members
	cout << book1.price.dollars << endl;
	cout << book2.dollars;
	return 0;
}
