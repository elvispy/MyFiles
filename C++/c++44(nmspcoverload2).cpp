#include <iostream>
namespace calculsPratiques
{
   template <typename T>
   T min(const T& a, const T& b)
   {
      if (a < b)
         return a;
      return b;
   }
}
//namespace overloading!
namespace calculsPratiques
{
   template <typename T>
   T max(const T& a, const T& b)
   {
      if (a > b)
         return a;
      return b;
   }
}

/*
Note that this is completely inefficient. You shouldn't be using namespaces overloading unless strictly needed, 
Also, note that the only element they contain is a template function, which is an extreme case of overloading.
*/
int main()
{	
	int nb1 = 3, nb2 = 4;
	int lePlusGrand = calculsPratiques::max(nb1, nb2);
	std::cout << lePlusGrand;
}

