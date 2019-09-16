#include <iostream>

using namespace std;
//ust like we can create function templates, we can also create class templates,
// allowing classes to have members that use template parameters as types
template <class T>
class mypair
{
	T values [2];
	public:
		mypair (T first, T second)
		{
			values[0] = first;
			values[1] = second;
		}
		T getmax();
};

//The constructor is the only member function in the previous class template 
//and it has been defined inline within the class definition itself. In case 
//that a member function is defined outside the defintion of the class template,
// it shall be preceded with the template <...> prefix

template <class T>
T mypair<T>::getmax()
{
	T retval;
	retval = values[0]>values[1] ? values[0] : values[1];
	return retval;
}

int main()
{
	mypair<int> myobject (100, 75);
	cout << myobject.getmax();
	return 0;
}
